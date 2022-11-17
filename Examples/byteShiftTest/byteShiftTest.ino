void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
//
//  byte maxAmpLB = 0;
//  byte maxAmpRB = 200;
//  unsigned int maxAmp = (int) maxAmpRB | ((int)maxAmpLB << 8);//
//  Serial.println(maxAmp, DEC); // expect 200

 
  byte maxAmpLB = 4;
  byte maxAmpRB = 4;
  unsigned int maxAmp = maxAmpRB | ((int)maxAmpLB << 8);// works, LB first! not RB. 
  Serial.println(maxAmp, DEC); // expect 456


}
