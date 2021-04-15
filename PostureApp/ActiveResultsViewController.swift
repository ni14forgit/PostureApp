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
    
    var minutes = 1;
    
    var activity: String?
    
    private var centralManager: CBCentralManager!
    private var bluefruitPeripheral: CBPeripheral!
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    private var peripheralArray: [CBPeripheral] = []
    private var rssiArray = [NSNumber]()
    private var timer = Timer()
    var databaseTimer: Timer?
    
    
    @IBOutlet weak var LegImage: UIImageView?
    @IBOutlet weak var BackImage: UIImageView?
    @IBOutlet weak var LegValue: UILabel?
    @IBOutlet weak var BackValue: UILabel?
    @IBOutlet weak var reccommendationValue: UILabel?
    
    let realm = try! Realm()
    
    @IBAction func scanningAction(_ sender: Any) {
    startScanning()
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
        startScanning();
        
        keyboardNotifications()

        NotificationCenter.default.addObserver(self, selector: #selector(self.appendRxDataToTextView(notification:)), name: NSNotification.Name(rawValue: "Notify"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        databaseTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseTimer?.invalidate()
        
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        print(formattedDate)
        let numminutes = NumMinutes()
        numminutes.timestamp = formattedDate
        numminutes.minutes = minutes;
        realm.beginWrite()
        realm.add(numminutes)
        try! realm.commitWrite()
        print("VIEW WILL DISAPPERA")
        
        print(minutes)
        
        minutes = 1;
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
        let measurement = MeasurementTwo()
        measurement.timestamp = formattedDate
        measurement.measurement = 5;
        realm.beginWrite()
        realm.add(measurement)
        try! realm.commitWrite()
        print("write")
        
        
        // update minutes
        minutes += 1;
        print(minutes)
        
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

      self.navigationController?.pushViewController(detailViewController, animated: true)
    })
  }
    
    func writeOutgoingValue(data: String){
        
        print("sending value to Arduino \n")
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

    guard characteristic == rxCharacteristic,

          let characteristicValue = characteristic.value,
          let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }

      characteristicASCIIValue = ASCIIstring
    print("Value Recieved: \((characteristicASCIIValue as String))")
    
    
    
    
    
//        let array = characteristicASCIIValue.components(separatedBy: ",")
    
//        if array.count == 3 {
//        var NumberArray = [Double]();
//        var valsToReturn = [Double]();
//        for val in array {
//            NumberArray.append(Double(val) ?? 0.0);
//        }
//
//        print(NumberArray)
//
//
//        let Ax = NumberArray[0];
//        let Ay = NumberArray[1];
//        let Az = NumberArray[2];
//
//        valsToReturn.append(calculateROW(Ax: Ax, Ay: Ay, Az: Az));
//        valsToReturn.append(calculatePHI(Ax: Ax, Ay: Ay, Az: Az));
//        valsToReturn.append(calculateOMEGA(Ax: Ax, Ay: Ay, Az: Az));
//
//        print(valsToReturn);
//
//        }
    
//        print(Double(characteristicASCIIValue) ?? 0.0)
    
    let trimmedString = characteristicASCIIValue.trimmingCharacters(in: .whitespaces)
//    print(Double(trimmedString)!);
    LegValue?.text = trimmedString;
    
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

class NumMinutes: Object {
    @objc dynamic var minutes = 0
    @objc dynamic var timestamp = ""
}



//class PostureMeasurementOne: Object {
//
//    @objc dynamic var measurement = 0
//    @objc dynamic var timestamp = ""
//}


