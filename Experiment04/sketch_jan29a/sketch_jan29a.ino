#include<SoftwareSerial.h>

bool on = false;
void setup() {
  Serial.begin(9600);
  // pinMode(0,INPUT);
  
  pinMode(3, OUTPUT);
}
void loop() {
  if(Serial.available()>0)
  {
    Serial.print("Received: ");
    Serial.println((char)Serial.read());
    on = !on;
    Serial.println(on);
    if(on)
    {
      digitalWrite(3, HIGH);
    }
    else
    {
      digitalWrite(3, LOW);
    }
  }
}