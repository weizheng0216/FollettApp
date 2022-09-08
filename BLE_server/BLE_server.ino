/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleServer.cpp
    Ported to Arduino ESP32 by Evandro Copercini
    updates by chegewara
*/

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID_2 "beb5483e-36e1-4688-b7f5-ea07361b26a9"
BLECharacteristic *pCharacteristic;
BLECharacteristic *pCharacteristic2;
uint8_t to_send[7][2] = {{9,79},{10,99},{11,67},{12,88},{13,120},{14,131}, {15, 111}};
uint8_t temp[12] = {1,1,0,0,1,0,1,0,0,0,0,1};

void setup() {
  Serial.begin(115200);
  Serial.println("Starting BLE work!");

  BLEDevice::init("Follett Ice Machine");
  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );
                                      
  pCharacteristic2 = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID_2,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");

//  uint8_t to_send[6][2] = {{2,102},{4,100},{5,88},{6,123},{7,99},{8,111}};
//  pCharacteristic->setValue((uint8_t *)to_send, sizeof(to_send)/sizeof(to_send[0]) * 2);
//  pCharacteristic->notify();
  
}

void loop() {
  // put your main code here, to run repeatedly:
  
  to_send[5][0] = to_send[5][0] + 1;
  to_send[5][1] = to_send[5][1] + 10;
  
  temp[random(11)] =0;
  pCharacteristic->setValue((uint8_t *)to_send, sizeof(to_send)/sizeof(to_send[0]) * 2);
  pCharacteristic2->setValue((uint8_t *)temp, 12);
  pCharacteristic->notify();
  pCharacteristic2->notify();
  delay(5000);
}
