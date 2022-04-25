 char val; // Data received from the serial port
 int bzzPin1 = A0;
 int bzzPin2 = A1;
 int bzzPin3 = A2;
 
 int bzzPin4 = A3;
 int bzzPin5 = 4;
 int bzzPin6 = 3;

 int bzzPin7 = 2;
 int bzzPin8 = 8;
 int bzzPin9 = 7;



 //opsæt timer
 unsigned long onTime1=0;
 unsigned long onTime2=0;
 unsigned long onTime3=0;
 
 unsigned long onTime4=0;
 unsigned long onTime5=0;
 unsigned long onTime6=0;

 unsigned long onTime7=0;
 unsigned long onTime8=0;
 unsigned long onTime9=0;





 void setup() {
   pinMode(bzzPin1, OUTPUT); // Set pin as OUTPUT
   pinMode(bzzPin2, OUTPUT); // Set pin as OUTPUT
   pinMode(bzzPin3, OUTPUT); // Set pin as OUTPUT
   pinMode(bzzPin4, OUTPUT); // Set pin as OUTPUT
   pinMode(bzzPin5, OUTPUT); // Set pin as OUTPUT
   pinMode(bzzPin6, OUTPUT); // Set pin as OUTPUT
   pinMode(bzzPin7, OUTPUT); // Set pin as OUTPUT
   pinMode(bzzPin8, OUTPUT); // Set pin as OUTPUT
   pinMode(bzzPin9, OUTPUT); // Set pin as OUTPUT

   Serial.begin(9600); // Start serial communication at 9600 bps
   digitalWrite(bzzPin1, HIGH); // turn the LED on
   digitalWrite(bzzPin2, HIGH); // turn the LED on
   digitalWrite(bzzPin3, HIGH); // turn the LED on
   digitalWrite(bzzPin4, HIGH); // turn the LED oN
   digitalWrite(bzzPin5, HIGH); // turn the LED on
   digitalWrite(bzzPin6, HIGH); // turn the LED on
   digitalWrite(bzzPin7, HIGH); // turn the LED on
   digitalWrite(bzzPin8, HIGH); // turn the LED on
   digitalWrite(bzzPin9, HIGH); // turn the LED on


 }

 void loop() {
   if (Serial.available()) 
   { // If data is available to read,
     val = Serial.read(); // read it and store it in val
     Serial.write(val);
   if (val == '1') 
   { // If 1 was received
     digitalWrite(bzzPin1, LOW); // turn the LED on
     //gem tid fra miilliliilili i timer
     onTime1 = millis();
   }
   if (val == '2') 
   { // If 1 was received
     digitalWrite(bzzPin2, LOW); // turn the LED on
     //gem tid fra miilliliilili i timer
     onTime2 = millis();
   } 
   if (val == '3') 
   { // If 1 was received
     digitalWrite(bzzPin3, LOW); // turn the LED on
     //gem tid fra miilliliilili i timer
     onTime3 = millis();
   }
  
   if (val == '4') 
   { // If 1 was received
     digitalWrite(bzzPin4, LOW); // turn the LED on
     //gem tid fra miilliliilili i timer
     onTime4 = millis();
   }

   if (val == '5') 
   { // If 1 was received
     digitalWrite(bzzPin5, LOW); // turn the LED on
     //gem tid fra miilliliilili i timer
     onTime5 = millis();
   }
   
   if (val == '6') 
   { // If 1 was received
     digitalWrite(bzzPin6, LOW); // turn the LED on
     //gem tid fra miilliliilili i timer
     onTime6 = millis();
   }
   
   if (val == '7') 
   { // If 1 was received
     digitalWrite(bzzPin7, LOW); // turn the LED on
     //gem tid fra miilliliilili i timer
     onTime7 = millis();
   }
   
   if (val == '8') 
   { // If 1 was received
     digitalWrite(bzzPin8, LOW); // turn the LED on
     //gem tid fra miilliliilili i timer
     onTime8 = millis();
   }
   
   if (val == '9') 
   { // If 1 was received
     digitalWrite(bzzPin9, LOW); // turn the LED on
     //gem tid fra miilliliilili i timer
     onTime9 = millis();
   }
   
  delay(10); // Wait 10 milliseconds for next reading
 }
   if(millis()>onTime1+500) {
    digitalWrite(bzzPin1, HIGH); // turn the LED on
   } 
   if(millis()>onTime2+500) {
    digitalWrite(bzzPin2, HIGH); // turn the LED on
   }
    if(millis()>onTime3+500) {
    digitalWrite(bzzPin3, HIGH); // turn the LED on
   }

    if(millis()>onTime4+500) {
    digitalWrite(bzzPin4, HIGH); // turn the LED on
   }

   if(millis()>onTime5+500) {
    digitalWrite(bzzPin5, HIGH); // turn the LED on
   }
   if(millis()>onTime6+500) {
    digitalWrite(bzzPin6, HIGH); // turn the LED on
   }
 
   if(millis()>onTime7+500) {
    digitalWrite(bzzPin7, HIGH); // turn the LED on
   }
   
   if(millis()>onTime8+500) {
    digitalWrite(bzzPin8, HIGH); // turn the LED on
   }
      
   if(millis()>onTime9+500) {
    digitalWrite(bzzPin9, HIGH); // turn the LED on
   }

}
