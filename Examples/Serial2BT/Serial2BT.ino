#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <EEPROM.h> // Library for Read/Write to ESP32 flash memory

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"


unsigned long mainMillis = millis(); // Initialize start time
const unsigned long loopTimer = 1; // Handles rate in seconds at which values are read and stored from ice machine to dongle. CHANGE to 60 Left at 2 for testing
unsigned long addr = EEPROM.read(0); // Address for next write to flash memory

unsigned short counter = 0; //Tracks if to_send array is newly updated
unsigned short id = 0; 

// Initialize Bluetooth objects
BLEServer* pServer; 
BLEService* pService; 
BLECharacteristic *pCharacteristic;
//__uint8_t to_send[5][2] = {{1,50},{2,105},{3,24},{4,140},{5,120}}; // Byte array to be transmitted over BT
__uint8_t to_send[5][2] = {{1,10},{2,20},{3,15},{4,20},{5,180}};

BLEAdvertising *pAdvertising; 



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
 * The goal of this function is to check if there have been 1000+ values written to the flash memory 
 * If so, write to the serial monitor a warning followed clearing them. 
 */
void checkLocalStorage(){
  if(addr == 1000){
    Serial.println("Clearing data");
    for(int i = 1; i < 1001; i+=4){ // Loop unroll 4x1 for performance :) 
      EEPROM.write(i, 0);
      EEPROM.write(i+1, 0);
      EEPROM.write(i+2, 0);
      EEPROM.write(i+3, 0);
      EEPROM.commit();
    }
  }
}


//void updateArr(u_int)(){}

void setup() {

  Serial.begin(14400); // Baud rate locked by the Ice machine board
  Serial.setTimeout(200);

  Serial.println("Starting Bluetooth Connection");




  BLEDevice::init("Follett Ice Machine");
  pServer = BLEDevice::createServer();
  pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );

  // pCharacteristic->setValue("Follett message!!!");
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);

 //pCharacteristic->setValue((uint8_t *)to_send, sizeof(to_send)/sizeof(to_send[0]) * 2);
  

  
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


// // Update byte array for tranmission
// if(counter == 60){
//   counter = 0;
//   //Update BT advertising message; Full array for graphing 
//   pCharacteristic->setValue((uint8_t *)to_send, sizeof(to_send)/sizeof(to_send[0]) * 2);
// }
// else{
//   to_send[counter][0] = addr;
//   to_send[counter][1] = data[1];
//   addr++;
//   counter++;
//   EEPROM.write(0, addr);
//   EEPROM.commit();
// }

//  to_send[counter][0] = id;
//  to_send[counter][1] = data[1];
//  if(counter == 10){
//    pCharacteristic->setValue((uint8_t *)to_send, sizeof(to_send)/sizeof(to_send[0]) * 2);
//    counter = 0;
//  }

  to_send[4][1] = (__uint8_t)data[8];

  delay(5* 1000);
  
  pCharacteristic->setValue((uint8_t *)to_send, sizeof(to_send)/sizeof(to_send[0]) * 2);
  BLEDevice::startAdvertising();
 
  delay(loopTimer * 1000);
}
