#include <SPI.h>
#include <EEPROM.h>
#include <boards.h>
#include <RBL_nRF8001.h>
#include <Servo.h>

int motor_left[] = {4, 2};
int ena = 3; //pwm
int motor_right[] = {9, 10};
int enb = 5; //pwm
int servoPin = 6; //pwm
int pm;

Servo turnServo;

void setup() {
  SPI.setDataMode(SPI_MODE0);
  SPI.setBitOrder(LSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV16);
  SPI.begin();
  ble_set_name("RC Car");
  ble_set_pins(8,7);
  ble_begin();
  int i;
  pinMode(ena,OUTPUT);
  pinMode(enb,OUTPUT);
  for(i = 0; i < 2; i++)
   {
     pinMode(motor_left[i], OUTPUT);
     pinMode(motor_right[i], OUTPUT);
   }
  turnServo.attach(servoPin);
  Serial.begin(2000000);
  turnServo.write(30);
}

void loop() {
  while(ble_available()){
    byte flag;
    byte val;
    byte val2;  
    if(flag = ble_read()){
       val = ble_read();
       if (flag == 1)
    {
      drive_forward(val+146+pm);   
    }
    else if (flag == 2)
    {
      drive_backward(val+146+pm);   
    } 
    else if (flag == 3)
    {//left    
      turnServo.write(val);
    }
    else if (flag == 4)
    {//right
      turnServo.write(val);          
    }
    else if (flag == 5)
    { val2 = ble_read();
      drive_forward(val+146+pm);
      turnServo.write(val2);
    }
     else if (flag == 6)
    { 
      val2 = ble_read();
      drive_forward(val+146+pm);
      turnServo.write(val2);
    }
     else if (flag == 7)
    {
      val2 = ble_read();
      drive_backward(val+146+pm);
      turnServo.write(val2);
    }
     else if (flag == 8)
    { val2 = ble_read();
      drive_backward(val+146+pm);
      turnServo.write(val2);
    }
      else if (flag == 9)
    { 
      set_pwm(val);
    }
     else if (flag == 10)
    { 
      set_pwm(val);
    }
    }  
  }
  ble_do_events();
}

void drive_forward(int pwm)
  {
    analogWrite(ena, pwm);
    analogWrite(enb, pwm);
    digitalWrite(motor_left[1], HIGH); 
    digitalWrite(motor_left[0], LOW); 
    digitalWrite(motor_right[1], HIGH); 
    digitalWrite(motor_right[0], LOW);
  }

void drive_backward(int pwm)
  {
    analogWrite(ena, pwm);
    analogWrite(enb, pwm);
    digitalWrite(motor_left[1], LOW); 
    digitalWrite(motor_left[0], HIGH); 
    digitalWrite(motor_right[1], LOW); 
    digitalWrite(motor_right[0], HIGH);   
   }

void set_pwm(int pwm)
   {
    pm = pwm;
   }
   


