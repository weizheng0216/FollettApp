// This example references the EEPROM library


#include <EEPROM.h>

/* Reference: https://www.youtube.com/watch?v=MxL1PqS2JR0
   >>Limitations<<
    | There is a limit to how much we can write to the flash
    | memory since it degrades over time. It has a maximum
    | of 100,000 writes. This is something to consider for long-term.
    | usage.

   To write data to the flash memory:
   EEPROM.write(address, value)
   EEPROM.commit();

   To read data from the flash memory:
   EEPROM.read(address);

*/

#define EEPROM_SIZE 1 //Change 1 to 5 for number of data things we need. 

// Variables
int data = 0;
int counter = 0; 


void setup() {

  Serial.begin(115200);
  Serial.println("Starting R/W process...");

  //Initialize EEPROM with predefined size
  //EEPROM.begin(EEPROM_SIZE);
}


void loop() {

  Serial.println(data);  

  counter++; 

  data = counter; 

  EEPROM.write(0, data); 
  EEPROM.commit(); 
  delay(1*60*1000); // Delay write every minute.   
  

}
