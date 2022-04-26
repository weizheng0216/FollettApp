// This example code is in the Public Domain (or CC0 licensed, at your option.)
// By Evandro Copercini - 2018
//
// This example creates a bridge between Serial and Classical Bluetooth (SPP)
// and also demonstrate that SerialBT have the same functionalities of a normal Serial

#include "BluetoothSerial.h"
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define PERIPHERAL_NAME "Follett Ice Machine"
#define SERVICE_UUID "6e30db6a-b6a8-11ec-b909-0242ac120002"  //auto generated uuids
#define CHARACTERISTIC_INPUT_UUID "17bca85c-ba6a-11ec-8422-0242ac120002"
#define CHARACTERISTIC_OUTPUT_UUID "3ad55230-ba6a-11ec-8422-0242ac120002"

// Current value of output characteristic persisted here
static uint8_t outputData[1];

// Output characteristic is used to send the response back to the connected phone
BLECharacteristic *pOutputChar;

// Class defines methods called when a device connects and disconnects from the service
class ServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        Serial.println("BLE Client Connected");
    }
    void onDisconnect(BLEServer* pServer) {
        BLEDevice::startAdvertising();
        Serial.println("BLE Client Disconnected");
    }
};

class InputReceivedCallbacks: public BLECharacteristicCallbacks {    //we need this class but we need to change it somehow
    void onWrite(BLECharacteristic *pCharWriteState) {               //Currently using code from calculator example
        uint8_t *inputValues = pCharWriteState->getData();           // TODO: figure out what actually goes in here

        switch(inputValues[2]) {
          case 0x00: // add
            //Serial.printf("Adding:   %02x %02x\r\n", inputValues[0], inputValues[1]);  
            outputData[0] = inputValues[0] + inputValues[1];  
            break;
          case 0x01: // subtract
            //Serial.printf("Subtracting:   %02x %02x\r\n", inputValues[0], inputValues[1]);  
            outputData[0] = inputValues[0] - inputValues[1];  
            break;
          default: // multiply
            //Serial.printf("Multiplying:   %02x %02x\r\n", inputValues[0], inputValues[1]);  
            outputData[0] = inputValues[0] * inputValues[1];  
        }
        
        //Serial.printf("Sending response:   %02x\r\n", outputData[0]);  
        
        pOutputChar->setValue((uint8_t *)outputData, 1);
        pOutputChar->notify();
    }
};

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;
unsigned long mainMillis = millis(); // Used to track time between measurements

void setup() {
  Serial.begin(14400);    // ht5; Baud Rate of Ice machine. Hard set.
  Serial.setTimeout(200); // ht5
  SerialBT.begin("Follett Ice Machine"); //Bluetooth device name
  Serial.println("Begin Setup BLE Service and Characteristics");

  // Configure the server
  BLEDevice::init(PERIPHERAL_NAME);
  BLEServer *pServer = BLEDevice::createServer();

  // Create the service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a characteristic for the service
  BLECharacteristic *pInputChar = pService->createCharacteristic(
                              CHARACTERISTIC_INPUT_UUID,                                        
                              BLECharacteristic::PROPERTY_WRITE_NR | BLECharacteristic::PROPERTY_WRITE);

  pOutputChar = pService->createCharacteristic(
                              CHARACTERISTIC_OUTPUT_UUID,
                              BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);

  // Hook callback to report server events
  pServer->setCallbacks(new ServerCallbacks());
  pInputChar->setCallbacks(new InputReceivedCallbacks());

  // Initial characteristic value
  outputData[0] = 0x00;
  pOutputChar->setValue((uint8_t *)outputData, 1);

  // Start the service
  pService->start();

  // Advertise the service
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();

  Serial.println("The device started, now you can pair it with bluetooth!");

  mainMillis = millis(); // init start time

}

void loop()
{

  if (millis() - mainMillis >= 250)
  {

    mainMillis = millis();
    digitalWrite(0, LOW); // led on

    byte request[] = {
        90, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 152, 171};
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

    if (!flag)
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
      
      //Send Bluetooth Data Message
      //[TODO]
    }
    else
    {
      data[0] = 255;
      data[1] = 255;

      //Send Bluetooth Error message: 
      // [TODO]

    }
  }

  // if (Serial.available()) {
  //   SerialBT.write(Serial.read());
  // }
  // if (SerialBT.available()) {
  //   Serial.write(SerialBT.read());
  // }
  // delay(20);
}
