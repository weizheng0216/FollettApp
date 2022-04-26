// This example code is in the Public Domain (or CC0 licensed, at your option.)
// By Evandro Copercini - 2018
//
// This example creates a bridge between Serial and Classical Bluetooth (SPP)
// and also demonstrate that SerialBT have the same functionalities of a normal Serial

#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;
unsigned long mainMillis = millis(); // Used to track time between measurements

void setup()
{
  Serial.begin(9600);    // ht5; Baud Rate of Ice machine. Hard set.
  Serial.setTimeout(200); // ht5

  SerialBT.begin("Follett Dongle"); // Bluetooth device name
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
      for (int i = 0; i < 7; i++){
        SerialBT.write(data[i]);
      }
      Serial.print("\n");
      
    }
    else
    {
      data[0] = 255;
      data[1] = 255;

      //Send Bluetooth Error message: 
      SerialBT.write(97);
      SerialBT.write(10); 

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