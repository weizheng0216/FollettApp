#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <EEPROM.h> // Library for Read/Write to ESP32 flash memory

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"


unsigned long mainMillis = millis(); // Initialize start time
const unsigned long loopTimer = 2; // Handles rate in seconds at which values are read and stored from ice machine to dongle. CHANGE to 60 Left at 2 for testing
unsigned long addr = 0; // Address for next write to flash memory



/*
   [TODO]
   This function condenses a byte array of size 8 into one to store inside a single address line.
   @param data - array that holds low and high amps, mode state, dipswitches, and low and high error bytes
*/
byte condenseData(byte allData[]) {
  //left empty for now.
  return 1;
}


/*
 * This function is for testing purposes.
 * The goal of this function is to check if there have been 20+ values written to the flash memory 
 * If so, write to the serial monitor a warning followed by all values stored. 
 */
void checkLocalStorage(){
  if(addr > 20)
    Serial.println("Many have been saved!");
}

void setup() {

  Serial.begin(14400); // Baud rate locked by the Ice machine board
  Serial.setTimeout(200);

  Serial.println("Starting Bluetooth Connection");


  BLEDevice::init("Follett Dongle");
  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);
  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );

  pCharacteristic->setValue("Follett message!!!");
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");
}


void loop() {
  byte request[] = {
    90, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 152, 171
  };
  byte reply[170]; // was 167
  byte data[9];
  byte i;
  bool flag = false;

  Serial.write(request, 105); // was 102

  unsigned long currentMillis = millis();
  while (!Serial.available())
  {
    if (millis() - currentMillis >= 500)
    {
      flag = true;
      break;
    }
    delay(0);
  }

  Serial.readBytes(reply, 170); // was 167

  if (!flag) // Valid Serial Connection; Proceed with execution
  {
    // condense data
    data[0] = reply[133]; // amps lowbyte was 130
    data[1] = reply[134]; // amps highbyte was 131
    for (i = 0; i < 8; i++)
    {
      bitWrite(data[2], i, reply[135 + i]);
    } // merge din0-7 into 1 byte was 132
    data[3] = 0;
    for (i = 0; i < 1; i++)
    {
      bitWrite(data[3], i, reply[143 + i]);
    }                     // merge din8-12 into 1 byte was 140 --- only 1st byte still valid, following 4 bytes are new auger current min/max
    data[4] = reply[148]; // dipswitches was 145
    data[5] = reply[149]; // dout0 was 146
    // ignore dout8,16,24
    data[6] = reply[153]; // errors lowbyte was 150
    data[7] = reply[154]; // errors highbyte was 151
    data[8] = reply[155]; // mymode was 152
  }
  else // Error
  {
    data[0] = 255;
    data[1] = 255;
  }

  // Condense data[] into single byte for storage [TODO]
  // byte allData = condenseData(data);

  // As of now for testing purposes, only write the high amp value locally and transmit that over BT
  EEPROM.write(addr, data[1]); //Write locally; change data[1] to allData when condenseData() is finished
  EEPROM.commit(); // Save changes
  
  addr++; //update pointer


  // FOR TESTING PURPOSES 
  if(addr > 20){
    for(int i = 0; i < 20; i++){
      //put write through bluetooth function for iPhone here
    }
  }
  
  delay(loopTimer * 1000);
}
