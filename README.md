#RCCar
##Overview
A remote control car using RedBearLab's BLE Shield was designed and an iOS app with 3D Touch support which serves as the remote was written to control it. It is a simple project that uses the library provided by RedBearLab and arduino board to control the drive of the car.

##Components Used
1. Arduino Uno
2. RedBearLab's BLE Shield - [Link](http://redbearlab.com/bleshield/)
3. iOS Device (Running iOS 7.0+)
4. L298n Motor Driver
5. 12V Li-Po
6. 12V DC Motors
7. 5V Regulator
8. 5V Servo
9. Chassis, Wheels and Turning Mechanism

##Usage
1. Copy the files in library folder to arduino's library folder and then compile the code and upload it to arduino board.
2. Open `BlueRC.xcworkspace` file found in bleRC folder in Xcode and sideload the app on your iOS device.

##Demo
![Model](/Images/RCCar_Demo.gif?raw=true "Optional Title")

##App ScreenShot
![App](/AppScreenShots/1.PNG?raw=true "Optional Title")

##References
1. [RedBearLab's BLE Shield Arduino Library](https://github.com/RedBearLab/BLEShield)
2. [RedBearLab's BLE iOS SDK](https://github.com/RedBearLab/iOS)
3. [Joystick Interface Tutorial](https://www.cocoacontrols.com/controls/jscontroller)
