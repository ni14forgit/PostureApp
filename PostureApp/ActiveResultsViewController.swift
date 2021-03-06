//
//  ActiveResultsViewController.swift
//  PostureApp
//
//  Created by Nishant Iyengar on 2/28/21.
//  Copyright © 2021 Nishant Iyengar. All rights reserved.
//

import RealmSwift
import UIKit
import CoreBluetooth

class ActiveResultsViewController: UIViewController, CBPeripheralDelegate {
    
    var start = false;
//    var singlePeripheralSet = false;
    var minutes = 1;
    var activity: String?
    var isLeg = true;
    
    var backPath: UIBezierPath?
    var legPath: UIBezierPath?
    
    var currentLegValue = 0;
    var currentBackValue = 0;
    
    let OPTIMAL_SITTING_VALUE = 90
    let OPTIMAL_STANDING_VALUE = 90
    let OPTIMAL_SQUATTING_VALUE = 90
    let ERROR_RANGE = 3
    
    let LEG_PERIPHERAL_IDENTIFIER = "3FC529DC-8810-8548-B602-50EA21FBCA5B"
    let BACK_PERIPHERAL_IDENTIFIER = "73D2E184-726D-E51C-0300-8DA18D844DC5"
    
    private var centralManager: CBCentralManager!
    private var bluefruitPeripheral: CBPeripheral!
    
    private var bluefruitPeripheralBack: CBPeripheral!
    private var bluefruitPeripheralLeg: CBPeripheral!
    
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    private var peripheralArray: [CBPeripheral] = []
    private var rssiArray = [NSNumber]()
    private var timer = Timer()
    var databaseTimer: Timer?
    var switchTimer: Timer?
    
    var publicLineLength = 0.0
    
    @IBOutlet weak var cartPlane: UIView!
    
    
    @IBOutlet weak var LegImage: UIImageView?
    @IBOutlet weak var BackImage: UIImageView?
    @IBOutlet weak var LegValue: UILabel?
    @IBOutlet weak var BackValue: UILabel?
    @IBOutlet weak var reccommendationValue: UILabel?
    
    let realm = try! Realm()
    
    @IBAction func scanningAction(_ sender: Any) {

    print("button clicked")
    writeOutgoingValue(data: "start")
//    startScanning()
        
    }
    
    @IBAction func writeValueToArduino(_ sender: Any) {
        
        if (!start) {
            writeOutgoingValue(data: "start")
            start = true;
        } else {
            writeOutgoingValue(data: "stop")
            start = false;
        }
      }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // MAYBE DO SOME IF STATEMENT HERE TO ONLY CALL START IF NOT (BOTH DEVICES DISCOVERED)
        startScanning();
        
        
        keyboardNotifications()

        NotificationCenter.default.addObserver(self, selector: #selector(self.appendRxDataToTextView(notification:)), name: NSNotification.Name(rawValue: "Notify"), object: nil)
        
        
        
        // GRAPH SHOWING CODE
        
        let width = cartPlane.frame.size.width;
              let height = cartPlane.frame.size.height;
              let lineLength = (height/2)*(3/4);
        
//        publicHeight = height;
//        publicLineLength = lineLength
              
//               y-axis
              drawLineFromPointToPoint(startX: Int(width/2), toEndingX: Int(width/2), startingY: 0, toEndingY: Int(height), ofColor: UIColor.white, widthOfLine: 1.0, inView: cartPlane, alter: false)
              // x-axis
              drawLineFromPointToPoint(startX: 0, toEndingX: Int(width), startingY: Int(height/2), toEndingY: Int(height/2), ofColor: UIColor.white, widthOfLine: 1.0, inView: cartPlane, alter: false)
//              // 45 degree angle
              let x45 = lineLength*cos(45*3.14/180);
              let y45 = lineLength*sin(45*3.14/180);
              drawLineFromPointToPoint(startX: 0, toEndingX: Int(x45), startingY: 0, toEndingY: Int(y45), ofColor: UIColor.blue, widthOfLine: 5.0, inView: cartPlane)
              // 45 degree angle
              let x90 = lineLength*cos(90*3.14/180);
              let y90 = lineLength*sin(90*3.14/180);
              print(x90, y90)
              drawLineFromPointToPoint(startX: 0, toEndingX: Int(x90), startingY: 0, toEndingY: Int(y90), ofColor: UIColor.blue, widthOfLine: 5.0, inView: cartPlane)

              cartPlane.backgroundColor = UIColor.lightGray
              cartPlane.layer.cornerRadius = 10;
              cartPlane.layer.masksToBounds = true;
              self.view.addSubview(cartPlane)

    }
    
//    func drawLine(degree: Double, lineLength: Double, ofColor lineColor: UIColor = UIColor.blue, widthofLine lineWidth: CGFloat = 5.0, inView view: UIView) {
//            let x = lineLength*cos(degree*3.14/180);
//            let y = lineLength*sin(degree*3.14/180);
//            drawLineFromPointToPoint(startX: 0, toEndingX: Int(x), startingY: 0, toEndingY: Int(y), ofColor: lineColor, widthOfLine: lineWidth, inView: view);
//    }
    
    func drawLine(degree: Double, ofColor lineColor: UIColor = UIColor.blue, widthofLine lineWidth: CGFloat = 5.0, inView view: UIView, path: UIBezierPath? = nil) {
            let lineLength = Double((view.frame.height/2)*(3/4));
            let x = lineLength*cos(degree*3.14/180);
            let y = lineLength*sin(degree*3.14/180);
        drawLineFromPointToPoint(startX: 0, toEndingX: Int(x), startingY: 0, toEndingY: Int(y), ofColor: lineColor, widthOfLine: lineWidth, inView: view, path: path);
        }
    
    
    func drawLineFromPointToPoint(startX: Int, toEndingX endX: Int, startingY startY: Int, toEndingY endY: Int, ofColor lineColor: UIColor, widthOfLine lineWidth: CGFloat, inView view: UIView, alter: Bool = true, path: UIBezierPath? = nil) {
           
           let viewWidth = view.frame.size.width;
           let viewHeight = view.frame.size.height;
           let newStartX = alter ? Int(viewWidth)/2-startX : startX;
           let newEndX = alter ? Int(viewWidth)/2+endX : endX;
           let newStartY = alter ? Int(viewHeight)/2-startY : startY;
           let newEndY = alter ? Int(viewWidth)/2-endY : endY;
           
           print(newStartX, "\n");
           print(newEndX, "\n");
           print(newStartY, "\n");
           print(newEndY, "\n");
        
        
//           path = nil
            
           path?.move(to: CGPoint(x: newStartX, y: newStartY))
           path?.addLine(to: CGPoint(x: newEndX, y: newEndY))
           

           let shapeLayer = CAShapeLayer()
           shapeLayer.path = path?.cgPath
           shapeLayer.strokeColor = lineColor.cgColor
           shapeLayer.lineWidth = lineWidth

           view.layer.addSublayer(shapeLayer)

       }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        centralManager = CBCentralManager(delegate: self, queue: nil)
//        startScanning();
        
//        if (!start) {
//            writeOutgoingValue(data: "start")
//            start = true;
//        } else {
//            writeOutgoingValue(data: "stop")
//            start = false;
//        }
        
        
//        databaseTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        switchTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runSwitchBluetoothCode), userInfo: nil, repeats: true)
        
    }
    


    
    
//    func retrieve() {
//        let pastMeasurements = realm.objects(MeasurementTwo.self)
//    }
    
    @objc func appendRxDataToTextView(notification: Notification) -> Void{
//      consoleTextView.text.append("\n[Recv]: \(notification.object!) \n")
        print("\n[Recv]: \(notification.object!) \n")
    }

    func appendTxDataToTextView(){
//      consoleTextView.text.append("\n[Sent]: \(String(consoleTextField.text!)) \n")
//        print("\n[Sent]: \(String(consoleTextField.text!)) \n")
    }
    
    func keyboardNotifications() {
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

      NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)

      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    

    deinit {
      NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
      NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {

      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

        let keyboardHeight = keyboardSize.height
        print(keyboardHeight)
        view.frame.origin.y = (-keyboardHeight + 50)
      }
    }

    @objc func keyboardDidHide(notification: Notification) {
      view.frame.origin.y = 0
    }

    
    func connectToDevice() -> Void {
      centralManager?.connect(bluefruitPeripheral!, options: nil)
  }

    func disconnectFromDevice() -> Void {
      if bluefruitPeripheral != nil {
        centralManager?.cancelPeripheralConnection(bluefruitPeripheral!)
      }
  }
    
    func disconnectFromLegConnectToBack() -> Void {
      if bluefruitPeripheral != nil {
        centralManager?.cancelPeripheralConnection(bluefruitPeripheral!)
      }
        bluefruitPeripheral = bluefruitPeripheralBack
      centralManager?.connect(bluefruitPeripheral!, options: nil)
        
  }
    
    func disconnectFromBackConnectToLeg() -> Void {
      if bluefruitPeripheral != nil {
        centralManager?.cancelPeripheralConnection(bluefruitPeripheral!)
      }
        bluefruitPeripheral = bluefruitPeripheralLeg
      centralManager?.connect(bluefruitPeripheral!, options: nil)
  }

    func removeArrayData() -> Void {
      centralManager.cancelPeripheralConnection(bluefruitPeripheral)
           rssiArray.removeAll()
           peripheralArray.removeAll()
       }
    
    @objc func runTimedCode() {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        print(formattedDate)
//        let measurement = MeasurementTwo()
//        measurement.timestamp = formattedDate
//        measurement.measurement = 5;
        
//        let finalPostureMeasurement = FinalPostureMeasurement()
//        finalPostureMeasurement.timestamp = formattedDate
//        finalPostureMeasurement.measurement = currentLegValue;
//        finalPostureMeasurement.activity = activity!;
//
//
//        realm.beginWrite()
////        realm.add(measurement)
//        realm.add(finalPostureMeasurement)
//        try! realm.commitWrite()
//        print("write")

        
//         update minutes
        minutes += 1;
        print(minutes)
        
    }
    
    @objc func runSwitchBluetoothCode() {
        
        startScanning()
        if (!start) {
            writeOutgoingValue(data: "start")
            start = true;
        }
        
//        else {
//            writeOutgoingValue(data: "stop")
//            start = false;
//        }
        
        print("switchBluetooth was called")
        
        if bluefruitPeripheral.identifier.uuidString == LEG_PERIPHERAL_IDENTIFIER {
            if let bluefruitPeripheralBack = bluefruitPeripheralBack {
                print("calling connecting to back")
                disconnectFromLegConnectToBack()
//                writeOutgoingValue(data: "start")
                isLeg = false;
            }
            
        } else if bluefruitPeripheral.identifier.uuidString == BACK_PERIPHERAL_IDENTIFIER {
            print("reached here")
            if let bluefruitPeripheralLeg = bluefruitPeripheralLeg {
                print("calling connecting to leg")
                disconnectFromBackConnectToLeg()
//                writeOutgoingValue(data: "start")
                isLeg = true;
            }
        }
        
//        if (!start) {
//            writeOutgoingValue(data: "start")
//            start = true;
//        }
        
//        writeOutgoingValue(data: "start")
        
//        else {
//            writeOutgoingValue(data: "stop")
//            start = false;
//        }
            
    }

    func startScanning() -> Void {
        // Remove prior data
        peripheralArray.removeAll()
        rssiArray.removeAll()
        // Start Scanning
        centralManager?.scanForPeripherals(withServices: [CBUUIDs.BLEService_UUID])
//        scanningLabel.text = "Scanning..."
//        scanningButton.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false) {_ in
            self.stopScanning()
        }
    }
    
    func stopTimer() -> Void {
      // Stops Timer
      self.timer.invalidate()
    }

    func stopScanning() -> Void {
//        scanningLabel.text = ""
//        scanningButton.isEnabled = true
        centralManager?.stopScan()
    }
    
    /* i think has to do when you click on a row of a BLE device **/
    func delayedConnection() -> Void {

    BlePeripheral.connectedPeripheral = bluefruitPeripheral

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      //Once connected, move to new view controller to manager incoming and outgoing data
      let storyboard = UIStoryboard(name: "Main", bundle: nil)

      let detailViewController = storyboard.instantiateViewController(withIdentifier: "ConsoleViewController") as! ConsoleViewController

//      self.navigationController?.pushViewController(detailViewController, animated: true)
    })
  }
    
    func writeOutgoingValue(data: String){
        
        print("sending value to Arduino \n")
          
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        
        if let bluefruitPeripheral = bluefruitPeripheral {
              
          if let txCharacteristic = txCharacteristic {
                  
            bluefruitPeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
              }
          }
      }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

      guard let services = peripheral.services else { return }
      for service in services {
        peripheral.discoverCharacteristics(nil, for: service)
      }
      BlePeripheral.connectedService = services[0]
    }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

    guard let characteristics = service.characteristics else {
        return
    }

    print("Found \(characteristics.count) characteristics.")

    for characteristic in characteristics {

      if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Rx)  {

        rxCharacteristic = characteristic

        BlePeripheral.connectedRXChar = rxCharacteristic

        peripheral.setNotifyValue(true, for: rxCharacteristic!)
        peripheral.readValue(for: characteristic)

        print("RX Characteristic: \(rxCharacteristic.uuid)")
      }

      if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Tx){
        txCharacteristic = characteristic
        BlePeripheral.connectedTXChar = txCharacteristic
        print("TX Characteristic: \(txCharacteristic.uuid)")
      }
    }
    delayedConnection()
 }

    
 


  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

    var characteristicASCIIValue = NSString()
    
    if(peripheral.identifier.uuidString == LEG_PERIPHERAL_IDENTIFIER){
        print("LEG value updated!")
    } else if (peripheral.identifier.uuidString == BACK_PERIPHERAL_IDENTIFIER) {
        print("BACK value updated!")
    }
    
    guard characteristic == rxCharacteristic,

          let characteristicValue = characteristic.value,
          let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }

      characteristicASCIIValue = ASCIIstring
    print("Value Recieved: \((characteristicASCIIValue as String))")
    
    let trimmedString = characteristicASCIIValue.trimmingCharacters(in: .whitespaces)
//    print(Double(trimmedString)!);
    if (isLeg) {
        LegValue?.text = trimmedString;
        currentLegValue = Int(trimmedString) ?? 70
        let legValueToDraw = Double(trimmedString) ?? 0.0
        legPath = nil
        drawLine(degree:legValueToDraw, inView: cartPlane, path: legPath)
    } else {
        BackValue?.text = trimmedString;
        currentBackValue = Int(trimmedString) ?? 70
        let backValueToDraw = Double(trimmedString) ?? 0.0
        backPath = nil
        drawLine(degree:backValueToDraw, inView: cartPlane, path: backPath)
    }
    
    NotificationCenter.default.post(name:NSNotification.Name(rawValue: "Notify"), object: "\((characteristicASCIIValue as String))")
  }

  func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        peripheral.readRSSI()
    }

  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
      guard error == nil else {
          print("Error discovering services: error")
          return
      }
    print("Function: \(#function),Line: \(#line)")
      print("Message sent")
  }


  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
      print("*******************************************************")
    print("Function: \(#function),Line: \(#line)")
      if (error != nil) {
          print("Error changing notification state:\(String(describing: error?.localizedDescription))")

      } else {
          print("Characteristic's value subscribed")
      }

      if (characteristic.isNotifying) {
          print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
      }
  }
    
}

extension ActiveResultsViewController: CBCentralManagerDelegate {
    
  

    // MARK: - Check
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

      switch central.state {
        case .poweredOff:
            print("Is Powered Off.")

            let alertVC = UIAlertController(title: "Bluetooth Required", message: "Check your Bluetooth Settings", preferredStyle: UIAlertController.Style.alert)

            let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            })

            alertVC.addAction(action)

            self.present(alertVC, animated: true, completion: nil)

        case .poweredOn:
            print("Is Powered On.")
            startScanning()
        case .unsupported:
            print("Is Unsupported.")
        case .unauthorized:
        print("Is Unauthorized.")
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        @unknown default:
          print("Error")
        }
    }

    // MARK: - Discover
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
      print("Function: \(#function),Line: \(#line)")
        
        
      print("setting bluefruit Peripheral")
      bluefruitPeripheral = peripheral
        
        print(peripheral.identifier.uuidString)
        if (peripheral.identifier.uuidString == LEG_PERIPHERAL_IDENTIFIER){
            print("LEG connected")
            bluefruitPeripheralLeg = peripheral
        } else {
            print("BACK connected")
            bluefruitPeripheralBack = peripheral
        }
        

      if peripheralArray.contains(peripheral) {
          print("Duplicate Found.")
      } else {
        peripheralArray.append(peripheral)
        rssiArray.append(RSSI)
      }

//          peripheralFoundLabel.text = "Peripherals Found: \(peripheralArray.count)"

      bluefruitPeripheral.delegate = self

      print("Peripheral Discovered: \(peripheral)")
        
        connectToDevice()
//          self.tableView.reloadData()
    }

    // MARK: - Connect
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        stopScanning()
        bluefruitPeripheral.discoverServices([CBUUIDs.BLEService_UUID])
    }
}




// MARK: - UITableViewDataSource
// The methods adopted bythe object you use to manage data and provide cells for a table view.
extension ActiveResultsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peripheralArray.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let cell = tableView.dequeueReusableCell(withIdentifier: "BlueCell") as! TableViewCell

      let peripheralFound = self.peripheralArray[indexPath.row]

      let rssiFound = self.rssiArray[indexPath.row]

        if peripheralFound == nil {
            cell.peripheralLabel.text = "Unknown"
        }else {
            cell.peripheralLabel.text = peripheralFound.name
            cell.rssiLabel.text = "RSSI: \(rssiFound)"
        }
        return cell
    }
}

class MeasurementTwo: Object {
    
    @objc dynamic var measurement = 0
    @objc dynamic var timestamp = ""
}

class FinalPostureMeasurement: Object {
    
    @objc dynamic var measurement = 0
    @objc dynamic var timestamp = ""
    @objc dynamic var activity = ""
}


class NumMinutes: Object {
    @objc dynamic var minutes = 0
    @objc dynamic var timestamp = ""
}



//class PostureMeasurementOne: Object {
//
//    @objc dynamic var measurement = 0
//    @objc dynamic var timestamp = ""
//}


