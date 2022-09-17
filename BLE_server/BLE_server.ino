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

/**
   @brief Updates a given array to contain the values extracted from the ice machine

   @param data size 8 array that will hold values for mode, amp rate, error states, etc.

*/
void getData(byte data[])
{

  byte request[] = {
    90, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 152, 171
  };
  byte reply[170]; // was 167
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
    // data[0] = reply[133]; //amps lowbyte was 130
    // data[1] = reply[134]; //amps highbyte was 131
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
  else
  {
    data[0] = 255;
    data[1] = 255;
  }
}


#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID_2 "beb5483e-36e1-4688-b7f5-ea07361b26a9"
// BLECharacteristic *pCharacteristic;
// BLECharacteristic *pCharacteristic2;
BLECharacteristic *ampsLow;
BLECharacteristic *ampsHigh;
BLECharacteristic *mergedin0_7;
BLECharacteristic *mergedin8_12;
BLECharacteristic *dipSwitches;
BLECharacteristic *dout0;
BLECharacteristic *errLow;
BLECharacteristic *errHigh;
BLECharacteristic *mode;
uint8_t ampsLow_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, -1}}; // -1 indicates array is not full.
uint8_t ampsHigh_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}};
uint8_t mergedin0_7_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}};
uint8_t mergedin8_12_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}};
uint8_t dipSwitches_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}};
uint8_t dout0_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}};
uint8_t errLow_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}};
uint8_t errHigh_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}};
uint8_t mode_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}};
int timeCounter = 7; // next data point counter.

// Updates advertising value
int updateData() {
  ampsLow->setValue((uint8_t *)ampsLow_TS, sizeof(ampsLow_TS) / sizeof(ampsLow_TS[0]) * 2);
  ampsHigh->setValue((uint8_t *)ampsHigh_TS, sizeof(ampsHigh_TS) / sizeof(ampsHigh_TS[0]) * 2);
  mergedin0_7->setValue((uint8_t *)mergedin0_7_TS, sizeof(mergedin0_7_TS) / sizeof(mergedin0_7_TS) * 2);
  mergedin8_12->setValue((uint8_t *)mergedin8_12_TS, sizeof(mergedin8_12_TS) / sizeof(mergedin8_12_TS[0]) * 2);
  dipSwitches->setValue((uint8_t *)dipSwitches, sizeof(dipSwitches) / sizeof(dipSwitches[0]) * 2);
  dout0->setValue((uint8_t *)dout0_TS, sizeof(dout0_TS) / sizeof(dout0_TS[0]) * 2);
  errLow->setValue((uint8_t *)errLow_TS, sizeof(errLow_TS) / sizeof(errLow_TS[0]) * 2);
  errHigh->setValue((uint8_t *)errHigh_TS, sizeof(errHigh_TS) / sizeof(errHigh_TS[0]) * 2);
  mode->setValue((uint8_t *)mode_TS, sizeof(mode_TS) / sizeof(mode_TS[0]) * 2);
}

// Notifies iPhone about information for each data entry
void sendData() {

  ampsLow->notify();
  ampsHigh->notify();
  mergedin0_7->notify();
  mergedin8_12->notify();
  dipSwitches->notify();
  dout0->notify();
  errLow->notify();
  errHigh->notify();
  mode->notify();

}

bool addData(byte data[]) {
  if (ampsLow_TS[6][1] == -1) { // If array is not full then add value

    int i = timeCounter % 7;
    ampsLow_TS[i][2] = data[0];
    ampsHigh_TS[i][2] = data[1];
    mergedin0_7_TS[i][2] = data[2];
    mergedin8_12_TS[i][2] = data[3];
    dipSwitches_TS[i][2] = data[4];
    dout0_TS[i][2] = data[5];
    errLow_TS[i][2] = data[6];
    errHigh_TS[i][2] = data[7];
    mode_TS[i][2] = data[8];
    timeCounter++;
    return true;

  }
  else {
    return false;
  }

}

void resetData() {
  int c = timeCounter;

  for (int i = 0; i < 8; i++) {

    ampsLow_TS[i][0] = c;
    ampsHigh_TS[i][0] = c;
    mergedin0_7_TS[i][0] = c;
    mergedin8_12_TS[i][0] = c;
    dipSwitches_TS[i][0] = c;
    dout0_TS[i][0] = c;
    errLow_TS[i][0] = c;
    errHigh_TS[i][0] = c;
    mode_TS[i][0] = c;
    c++;

    ampsLow_TS[i][1] = 0;
    ampsHigh_TS[i][1] = 0;
    mergedin0_7_TS[i][1] = 0;
    mergedin8_12_TS[i][1] = 0;
    dipSwitches_TS[i][1] = 0;
    dout0_TS[i][1] = 0;
    errLow_TS[i][1] = 0;
    errHigh_TS[i][1] = 0;
    mode_TS[i][1] = -1;
  }
  timeCounter = c; 
}

void setup()
{
  Serial.begin(115200);
  Serial.println("Starting BLE work!");

  BLEDevice::init("Follett Ice Machine");
  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Intialize Bluetooth Characteristics
  ampsLow = pService->createCharacteristic(
              CHARACTERISTIC_UUID,
              BLECharacteristic::PROPERTY_READ |
              BLECharacteristic::PROPERTY_WRITE);
  ampsHigh = pService->createCharacteristic(
               CHARACTERISTIC_UUID,
               BLECharacteristic::PROPERTY_READ |
               BLECharacteristic::PROPERTY_WRITE);
  mergedin0_7 = pService->createCharacteristic(
                  CHARACTERISTIC_UUID,
                  BLECharacteristic::PROPERTY_READ |
                  BLECharacteristic::PROPERTY_WRITE);
  mergedin8_12 = pService->createCharacteristic(
                   CHARACTERISTIC_UUID,
                   BLECharacteristic::PROPERTY_READ |
                   BLECharacteristic::PROPERTY_WRITE);
  dipSwitches = pService->createCharacteristic(
                  CHARACTERISTIC_UUID,
                  BLECharacteristic::PROPERTY_READ |
                  BLECharacteristic::PROPERTY_WRITE);
  dout0 = pService->createCharacteristic(
            CHARACTERISTIC_UUID,
            BLECharacteristic::PROPERTY_READ |
            BLECharacteristic::PROPERTY_WRITE);
  errLow = pService->createCharacteristic(
             CHARACTERISTIC_UUID,
             BLECharacteristic::PROPERTY_READ |
             BLECharacteristic::PROPERTY_WRITE);
  errHigh = pService->createCharacteristic(
              CHARACTERISTIC_UUID,
              BLECharacteristic::PROPERTY_READ |
              BLECharacteristic::PROPERTY_WRITE);
  mode = pService->createCharacteristic(
           CHARACTERISTIC_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);

  // Start Bluetooth Service
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06); // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  Serial.println("Characteristic defined! Now you can read it in your phone!");

  //  uint8_t to_send[6][2] = {{2,102},{4,100},{5,88},{6,123},{7,99},{8,111}};
  //  pCharacteristic->setValue((uint8_t *)to_send, sizeof(to_send)/sizeof(to_send[0]) * 2);
  //  pCharacteristic->notify();
}

void loop()
{

  byte data[9]; // Stores data entries by second
  getData(data);// Load data into array


  if (addData(data)) { // Successful add, array not full
    // keep adding data to respective arrays until RTS.
  }
  else { // Array full, notify iPhone of past minute of recorded data
    updateData(); // Notify iPhone of changes
    resetData(); // Clear values with new time points from updated counter.
  }

  delay(1000); // Update every second
}
