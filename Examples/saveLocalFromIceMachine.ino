
 

#include <Preferences.h>
Preferences preferences; 

unsigned long mainMillis = millis();

unsigned int hi_amp; 

void setup() {
  
  delay(100);

  // Start a storage space called follett in read/write mode. 
  preferences.begin("follett", false); // false - R/W mode; true - only read mode
  // After we begin the namespace, either it exists on the ESP32 or it doesn't 
  // Now we can add put additional keys onto this namespace for saving. 

  

  Serial.begin(14400); //ht5 - was 14400 of ice machine

  Serial2.begin(115200);  // baud rate of printout serial
 
  Serial.setTimeout(200); //ht5 
//  digitalWrite(0, LOW);
  digitalWrite(17, LOW); // turns on serial1 output pin. 
  
  mainMillis = millis(); //init start time
}

void loop() {

  int x; 

  if (millis()-mainMillis>=250){

    mainMillis = millis(); 
    digitalWrite(0, LOW); //led on
   
    byte request[] = {
      90, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 152, 171
    };
    byte reply[170]; //was 167
    byte data[9];
    byte i;
    bool flag=false;
    
    Serial.write(request,105); //was 102
    
    unsigned long currentMillis = millis();
    while(!Serial.available()){
        if (millis()-currentMillis>=500) {
            flag=true;
            break;
        }
        delay(0);
    }

    Serial.readBytes(reply, 170); // was 167

    if (!flag) {
      //condense data
      //data[0] = reply[133]; //amps lowbyte was 130
      //data[1] = reply[134]; //amps highbyte was 131
      data[0] = reply[144]; //amps lowbyte was 130; => was 133; max auger current 
      data[1] = reply[145]; //amps highbyte was 131; =>  was 134; min auger current 
      for (i=0; i<8; i++) {bitWrite(data[2], i, reply[135+i]);} //merge din0-7 into 1 byte was 132
      data[3]= 0;
      for (i=0; i<1; i++) {bitWrite(data[3], i, reply[143+i]);} //merge din8-12 into 1 byte was 140 --- only 1st byte still valid, following 4 bytes are new auger current min/max
      data[4] = reply[148]; //dipswitches was 145
      data[5] = reply[149]; //dout0 was 146
      //ignore dout8,16,24
      data[6] = reply[153]; //errors lowbyte was 150
      data[7] = reply[154]; //errors highbyte was 151
      data[8] = reply[155]; //mymode was 152

      x = (int) data[2]; 
      
    }
    else {
      data[0]=255;
      data[1]=255;
      data[2]=0;

      // save local error codes
      }
  }
    Serial2.println(x);

    delay(1000);
    
}
