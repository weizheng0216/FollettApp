//
//  BLEManager.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/28/22.
//

import Foundation

import CoreBluetooth
import Charts

struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
    let cbPerpheral: CBPeripheral
}
//
//struct CBUUIDs{
//
//    static let kBLEService_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
//    static let kBLE_Characteristic_uuid_Tx = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
//    static let kBLE_Characteristic_uuid_Rx = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"
//
//    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
//    static let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx)//(Property = Write without response)
//    static let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)// (Property = Read/Notify)
//
//}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    var myCentral: CBCentralManager!
    var myPeripheral: CBPeripheral!
    
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!

    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    
    @Published var maxAmpData: [[Int]] = []
//    @Published var minAmpData: [[Int]] = []
//    @ObservedObject var iceMachineState = IceMachineStatus()
    @Published var entries: [ChartDataEntry] = []
    var status = IceMachineStatus.shared
    

    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        var peripheralName: String!

        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        } else {
            peripheralName = "Unknown"
            return
        }
        
        let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue, cbPerpheral: peripheral)
        
        for existing in peripherals {
            if existing.name == peripheral.name {
                return
            }
        }
        
        print(newPeripheral)
        peripherals.append(newPeripheral)
        peripherals.sort(by: { $0.rssi > $1.rssi} )
        
        // to do, make it into the scan view
        if peripheralName == "Follett Ice Machine" {
            print(true)
            self.stopScanning()
            self.myPeripheral = peripheral
            self.myPeripheral.delegate = self
            self.myCentral.connect(myPeripheral, options: nil)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // to do, throw error when connect to nonesp32
        self.myPeripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
        print("Discovered Services: \(services)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
           
        guard let characteristics = service.characteristics else {
              return
        }
            
        print("Found \(characteristics.count) characteristics.")
//        print("\(characteristics[0])")
//        print("\(characteristics[1])")

        for characteristic in characteristics {
        
//            if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Rx)  {

                rxCharacteristic = characteristic

                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)

                print("RX Characteristic: \(rxCharacteristic.uuid)")
//            }
    
//            if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Tx){

                txCharacteristic = characteristic

                print("TX Characteristic: \(txCharacteristic.uuid)")
//            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
//        var characteristicASCIIValue = NSString()
//        guard characteristic == rxCharacteristic,
//
//        let characteristicValue = characteristic.value,
//        let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }

//        characteristicASCIIValue = ASCIIstring

//        hello = (characteristicASCIIValue as String)
        
//        ampData = hello.components(separatedBy: ", ").map { Int($0)!}


//        print("Value Recieved: \(hello)")
        
        
        
        guard let characteristicValue = characteristic.value else {
            // no data transmitted, handle if needed
            return
        }
        
//        let test = characteristicValue
        
        for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
            self.entries.append(ChartDataEntry(x: Double(characteristicValue[i]), y: Double(characteristicValue[i+1]), data: "My data"))
            self.maxAmpData.append([Int(characteristicValue[i]), Int(characteristicValue[i+1])])
        }
        
        
    }
    
    func writeOutgoingValue(data: String){
          
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        
        if let myPeripheral = myPeripheral {
              
            if let txCharacteristic = txCharacteristic {
                myPeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func startScanning() {
        print("startScanning")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    
        status.statusArray = [0,0,0,1,0,0,1,0,0,0,1,0]
     }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    
    func connect(peripheralName: String){
        
        if let peripheralToConnect = peripherals.first(where: {$0.name == peripheralName}) {
            self.myCentral.connect(peripheralToConnect.cbPerpheral, options: nil)
            peripheralToConnect.cbPerpheral.readValue(for: rxCharacteristic)
        }
    }
    
    func disconnect () {
        if myPeripheral != nil {
            myCentral?.cancelPeripheralConnection(myPeripheral!)
        }
    }
    
    
    
    @objc func fireTimer() {
        peripherals.removeAll()
    }

}

extension BLEManager: CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("Peripheral Is Powered On.")
        case .unsupported:
            print("Peripheral Is Unsupported.")
        case .unauthorized:
        print("Peripheral Is Unauthorized.")
        case .unknown:
            print("Peripheral Unknown")
        case .resetting:
            print("Peripheral Resetting")
        case .poweredOff:
          print("Peripheral Is Powered Off.")
        @unknown default:
          print("Error")
        }
    }
}
