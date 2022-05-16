# Calendr

* Calendr follows these requirements:
  * Use MVVM-C for data flow architecture
  * Use RXSwift for data bindings
  * Integrate it with the device Calendar
  * Must contain field validation

* Features
  * Allows users to login and register for authentication
  * Allows users to add, edit, and delete calendar events
  * Input field validation in login and register flows.

| Add Event | Edit | Delete | 
| -----------| -----------| -----------|
| <video src="https://user-images.githubusercontent.com/24359003/168533746-fc75f937-1259-4434-9615-ac29088808e7.mov" width="200"> |  <video src="https://user-images.githubusercontent.com/24359003/168534644-78141ef8-f279-4248-afc4-97ac370d073c.mov" width="200"> | <video src="https://user-images.githubusercontent.com/24359003/168534869-e1289b32-6872-4980-9237-0c08b36671e2.mov" width="200">
  
* Setup 
  * After checking-out, navigate to the project directory. 
  * Run 'pod install' from your terminal in the project directory. 
  * Add 'GoogleService-Info.plist' to the same directory as your Podfile.
  * In XCode, add 'GoogleService-Info.plist' to all project targets. 

# Note: 
If the device or simulator has not initialized the Calendar app, the default calendar does not exist. Open the Calendar app on the device or simulated device. Build and run the app again. 







