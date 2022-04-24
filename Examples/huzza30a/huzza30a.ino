/*
 *  6/2/2021
 *  huzza30
 *  sends condensed data 4x/second
 *  hopefully times out correctly now
 *  working on sending on change and ? splitting out amps
 *  prev. developed w/ v43 
 *  upgraded to v46 (48+?) for huzza30
 *  compiles with ide 2.0 finally
 */
 
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <WebSocketsClient.h>
//#include <ESP8266httpUpdate.h>
//#include <ESP8266HTTPClient.h>

const char* host = "ontheqt.glitch.me";

ESP8266WiFiMulti wifiMulti;
WebSocketsClient webSocket;

unsigned long mainMillis = millis();

void webSocketEvent(WStype_t type, uint8_t * payload, size_t length) {

  switch(type) {
    case WStype_DISCONNECTED:
      //USE_SERIAL.printf("[WSc] Disconnected!\n");
      break;
    case WStype_CONNECTED: {
      //USE_SERIAL.printf("[WSc] Connected to url: %s\n", payload);

      // send message to server when Connected
      //webSocket.sendTXT("Connected");
    }
      break;
    case WStype_TEXT: {
      //webSocket.sendTXT("updating");
       //t_httpUpdate_return ret = ESPhttpUpdate.update("http://ontheqt.glitch.com/esp.bin");
      // webSocket.sendTXT("message here");
    }
      break;
    case WStype_BIN:
      //USE_SERIAL.printf("[WSc] get binary length: %u\n", length);
      //hexdump(payload, length);

      // send data to server
      // webSocket.sendBIN(payload, length);
      break;
        case WStype_PING:
            // pong will be send automatically
            //USE_SERIAL.printf("[WSc] get ping\n");
            break;
        case WStype_PONG:
            // answer to a ping we send
            //USE_SERIAL.printf("[WSc] get pong\n");
            break;
    }

}



void setup() {
  pinMode(0, OUTPUT);
  delay(100);
  
  wifiMulti.addAP("FollettIoT", "");   
   
  while (wifiMulti.run() != WL_CONNECTED ) {  // Wait for the Wi-Fi to connect
    digitalWrite(0, !digitalRead(0));
    delay(250);
  }

  Serial.begin(14400); //ht5
  Serial.setTimeout(200); //ht5 
  digitalWrite(0, LOW);
  
  webSocket.begin(host, 80, "/"); // server address, port and URL
  webSocket.onEvent(webSocketEvent); // event handler
  // webSocket.setAuthorization("user", "Password"); //use HTTP Basic Authorization this is optional remove if not needed 
  webSocket.setReconnectInterval(5000); // try ever 5000 again if connection has failed
  //  webSocket.enableHeartbeat(15000, 3000, 2); // start heartbeat (optional), ping server every 15000 ms, expect pong from server within 3000 ms, consider connection disconnected if pong is not received 2 times
  
  mainMillis = millis(); //init start time
  
}
 

void loop() {

  webSocket.loop();

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
      data[0] = reply[133]; //amps lowbyte was 130
      data[1] = reply[134]; //amps highbyte was 131
      for (i=0; i<8; i++) {bitWrite(data[2], i, reply[135+i]);} //merge din0-7 into 1 byte was 132
      data[3]= 0;
      for (i=0; i<1; i++) {bitWrite(data[3], i, reply[143+i]);} //merge din8-12 into 1 byte was 140 --- only 1st byte still valid, following 4 bytes are new auger current min/max
      data[4] = reply[148]; //dipswitches was 145
      data[5] = reply[149]; //dout0 was 146
      //ignore dout8,16,24
      data[6] = reply[153]; //errors lowbyte was 150
      data[7] = reply[154]; //errors highbyte was 151
      data[8] = reply[155]; //mymode was 152
      webSocket.sendBIN(data, 9);
    }
    else {
      data[0]=255;
      data[1]=255;
      webSocket.sendBIN(data, 9);
      }
  }

  digitalWrite(0, HIGH); //led off
    
}

