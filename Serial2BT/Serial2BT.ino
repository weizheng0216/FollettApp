//This example code is in the Public Domain (or CC0 licensed, at your option.)
//By Evandro Copercini - 2018
//
//This example creates a bridge between Serial and Classical Bluetooth (SPP)
//and also demonstrate that SerialBT have the same functionalities of a normal Serial

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

class InputReceivedCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharWriteState) {
        uint8_t *inputValues = pCharWriteState->getData();

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

void setup() {
  Serial.begin(14400);
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
}

void loop() {
  if (Serial.available()) {
    SerialBT.write(Serial.read());
  }
  if (SerialBT.available()) {
    Serial.write(SerialBT.read());
  }
  delay(20);
}
