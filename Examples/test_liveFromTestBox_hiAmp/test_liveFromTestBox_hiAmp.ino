#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define ampsLow_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A2"
#define ampsHigh_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A3"
#define dip_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A4"
#define err_UUID  "BEB5483E-36E1-4688-B7F5-EA07361B26A5"
#define mode_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A1"
#define led1_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A6"
#define led2_UUID "BEB5483E-36E1-4688-B7F5-EA07361B26A7"



BLECharacteristic *ampsLow;
BLECharacteristic *ampsHigh;
//BLECharacteristic *mergedin0_7;
//BLECharacteristic *mergedin8_12;
BLECharacteristic *dipSwitches;
//BLECharacteristic *dout0;
//BLECharacteristic *errLow;
//BLECharacteristic *errHigh;
BLECharacteristic *err;
BLECharacteristic *mode;
BLECharacteristic *led1;
BLECharacteristic *led2;



unsigned long mainMillis = millis();
uint8_t ampsLow_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {6, 0}}; // -1 indicates array is not full.
uint8_t dipSwitches_TS[7][2] = {{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}, {5, 0}, {10, 0}};
uint8_t counter = 0;

// [TODO] Change to send only hiamp data point
bool getData(byte data[])
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
  return !flag;
}

// Notifies iPhone about information for each data entry
void sendData() {

  ampsLow->notify();
  ampsHigh->notify();
  //  mergedin0_7->notify();
  //  mergedin8_12->notify();
  //  dipSwitches->notify();
  //  dout0->notify();
  //  errLow->notify();
  //  errHigh->notify();
  mode->notify();

}

void setup() {
  Serial.begin(14400);
  Serial.setTimeout(200); //ht5
  digitalWrite(17, LOW); // turns on serial1 output pin.

  Serial.println("Starting BLE work!");
  mainMillis = millis(); //init start time

  BLEDevice::init("Follett Ice Machine");
  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Intialize Bluetooth Characteristics
  ampsLow = pService->createCharacteristic(
              ampsLow_UUID,
              BLECharacteristic::PROPERTY_READ |
              BLECharacteristic::PROPERTY_WRITE);
  ampsHigh = pService->createCharacteristic(
               ampsHigh_UUID,
               BLECharacteristic::PROPERTY_READ |
               BLECharacteristic::PROPERTY_WRITE);
  //  mergedin0_7 = pService->createCharacteristic(
  //                  CHARACTERISTIC_UUID_3,
  //                  BLECharacteristic::PROPERTY_READ |
  //                  BLECharacteristic::PROPERTY_WRITE);
  //  mergedin8_12 = pService->createCharacteristic(
  //                   CHARACTERISTIC_UUID_4,
  //                   BLECharacteristic::PROPERTY_READ |
  //                   BLECharacteristic::PROPERTY_WRITE);
  dipSwitches = pService->createCharacteristic(
                  dip_UUID,
                  BLECharacteristic::PROPERTY_READ |
                  BLECharacteristic::PROPERTY_WRITE);
  //  dout0 = pService->createCharacteristic(
  //            CHARACTERISTIC_UUID_6,
  //            BLECharacteristic::PROPERTY_READ |
  //            BLECharacteristic::PROPERTY_WRITE);
  //  errLow = pService->createCharacteristic(
  //             errLow_UUID,
  //             BLECharacteristic::PROPERTY_READ |
  //             BLECharacteristic::PROPERTY_WRITE);
  //  errHigh = pService->createCharacteristic(
  //              errHigh_UUID,
  //              BLECharacteristic::PROPERTY_READ |
  //              BLECharacteristic::PROPERTY_WRITE);

  err = pService->createCharacteristic(
          err_UUID,
          BLECharacteristic::PROPERTY_READ |
          BLECharacteristic::PROPERTY_WRITE);
  mode = pService->createCharacteristic(
           mode_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  led1 = pService->createCharacteristic(
           led1_UUID,
           BLECharacteristic::PROPERTY_READ |
           BLECharacteristic::PROPERTY_WRITE);
  led2 = pService->createCharacteristic(
           led2_UUID,
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


  Serial2.begin(9600);
  Serial2.println("Second serial begins.");

}

void loop() {

  byte minAmpLB = 0; // left byte
  byte minAmpRB =  0; // right byte

  byte maxAmpLB = 0;
  byte maxAmpRB = 0;

  int minAmp = 0 ;
  int maxAmp = 0 ;

  //  uint8_t mdin07 = 0;
  //  uint8_t mdin812 = 0;
  //  uint8_t ds = 0;
  //  uint8_t dout = 0;
  //  uint8_t errLowv = 0;
  //  uint8_t errHighv = 0;
  int errv = 0;
  uint8_t modev = 0;
  uint8_t led1v = 0;
  uint8_t led2v = 0;



  // Extraction
  if (millis() - mainMillis >= 250) {

    mainMillis = millis();
    digitalWrite(0, LOW); //led on

    byte request[] = {
      90, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 152, 171
    };
    byte reply[170]; //was 167
    byte data[9];
    byte i;
    bool flag = false;

    Serial.write(request, 105); //was 102

    unsigned long currentMillis = millis();
    while (!Serial.available()) {
      if (millis() - currentMillis >= 500) {
        flag = true;
        break;
      }
      delay(0);
    }

    Serial.readBytes(reply, 170); // was 167

    if (!flag) { // extract informaiton from ice machine
      //condense data
      //data[0] = reply[133]; //amps lowbyte was 130
      //data[1] = reply[134]; //amps highbyte was 131
      //      maxAmpLB = reply[145]; // left byte of max amp
      //      maxAmpRB = reply[144]; // right byte of max amp
      //      minAmpLB = reply[146]; //amps lowbyte was 130; => was 133; max auger current
      //      minAmpRB = reply[147]; // right byte of max amp

      maxAmpRB = reply[144];
      maxAmpLB = reply[145];
      minAmpRB = reply[146];
      minAmpLB = reply[147];

      data[1] = reply[145]; //amps highbyte was 131; =>  was 134; min auger current


      //      for (i = 0; i < 8; i++) {
      //        bitWrite(data[2], i, reply[135 + i]); //merge din0-7 into 1 byte was 132
      //      }
      //      data[3] = 0;
      //      for (i = 0; i < 1; i++) {
      //        bitWrite(data[3], i, reply[143 + i]); //merge din8-12 into 1 byte was 140 --- only 1st byte still valid, following 4 bytes are new auger current min/max
      //      }
      data[4] = reply[148]; //dipswitches was 145
      //      data[5] = reply[149]; //dout0 was 146 -- ERROR: getting twice


      //ignore dout8,16,24
      data[6] = reply[153]; //errors lowbyte was 150
      data[7] = reply[154]; //errors highbyte was 151 // ERROR: Empty
      errv = data[6] + ((int)data[7] << 8);

      data[8] = reply[155]; //mymode was 152 -- ERROR: empty

//
//      minAmp = minAmpRB + ((int)minAmpLB << 8);//
//      maxAmp = maxAmpRB + ((int)maxAmpLB << 8);//

      minAmp = minAmpLB + ((int)minAmpRB << 8);//
      maxAmp = maxAmpLB + ((int)maxAmpRB << 8);//

      //      errLowv = (uint8_t)data[6];
      //      errHighv = (uint8_t)data[7];
      modev = (uint8_t)data[8];
      led1v = reply[150];
      led2v = reply[151];
      counter++;
    }
    else {
      data[0] = 255;
      data[1] = 255;
      data[2] = 0;
      counter++;
    }

    // Update array


    //    uint8_t ampsLow_TS[1][2] = {{minAmpLB, minAmpRB}}; // -1 indicates array is not full.
    //    uint8_t ampsHigh_TS[1][2] = {{maxAmpLB, maxAmpRB}};
    uint8_t ampsLow_TS[1][2] = {{minAmp}}; // -1 indicates array is not full.
    uint8_t ampsHigh_TS[1][2] = {{maxAmp}};

    //    uint8_t mdin07_TS[1][2] = {{counter, mdin07}};
    //    uint8_t mdin812_TS[1][2] = {{counter, mdin812}};
    uint8_t dipSwitches_TS[1][2] = {{(int)data[4]}};
    //    uint8_t dout_TS[1][2] = {{counter, dout}};
    //    uint8_t errLow_TS[1][2] = {{counter, errLowv}};
    //    uint8_t errHigh_TS[1][2] = {{counter, errHighv}};
    uint8_t err_TS[1][2] = {{errv}};
    uint8_t mode_TS[1][2] = {{counter, modev}};
    uint8_t led1_TS[1][2] = {{counter, led1v }};
    uint8_t led2_TS[1][2] = {{counter, led2v }};

    //ampsLow->setValue((uint8_t *)ampsHigh_TS, sizeof(ampsHigh_TS) / sizeof(ampsHigh_TS[0]) * 2);
    ampsLow->setValue(minAmp);
    ampsLow->notify();

    //ampsHigh->setValue((uint8_t *)ampsLow_TS, sizeof(ampsLow_TS) / sizeof(ampsLow_TS[0]) * 2);
    ampsHigh->setValue(minAmp);
    ampsHigh->notify();

    //    errLow->setValue((uint8_t *)errLow_TS, sizeof(errLow_TS) / sizeof(errLow_TS[0]) * 2);
    //    errLow->notify();
    //
    //    errHigh->setValue((uint8_t *)errHigh_TS, sizeof(errHigh_TS) / sizeof(errHigh_TS[0]) * 2);
    //    errHigh->notify();

    dipSwitches->setValue((uint8_t *)dipSwitches_TS, sizeof(dipSwitches_TS) / sizeof(dipSwitches_TS[0]) * 2);
    dipSwitches->notify();

    err->setValue((uint8_t *)err_TS, sizeof(err_TS) / sizeof(err_TS[0]) * 2);
    err->notify();

    mode->setValue((uint8_t *)mode_TS, sizeof(mode_TS) / sizeof(mode_TS[0]) * 2);
    mode->notify();

    led1->setValue((uint8_t *)led1_TS, sizeof(led1_TS) / sizeof(led1_TS[0]) * 2);
    led1->notify();

    led2->setValue((uint8_t *)led2_TS, sizeof(led2_TS) / sizeof(led2_TS[0]) * 2);
    led2->notify();



  }

  delay(1000);

}
