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
struct CBUUIDs{

    static let ampsLow_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A1"
    static let ampsHigh_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A2"
    static let mergedin1UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A3"
    static let mergedin2_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A4"
    static let dipSwitches_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A5"
    static let dout0_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A6"
    static let errLow_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A7"
    static let errHigh_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A8"
    static let mode_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A9"
    
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    var myCentral: CBCentralManager!
    var myPeripheral: CBPeripheral!
    
    private var ampsLow_tx: CBCharacteristic!
    private var ampsLow_rx: CBCharacteristic!
    private var ampsHigh_tx: CBCharacteristic!
    private var ampsHigh_rx: CBCharacteristic!
    
    private var mergedin1_tx: CBCharacteristic!
    private var mergedin1_rx: CBCharacteristic!
    private var mergedin2_tx: CBCharacteristic!
    private var mergedin2_rx: CBCharacteristic!
    
    private var dipSwitches_tx: CBCharacteristic!
    private var dipSwitches_rx: CBCharacteristic!
    private var dout0_tx: CBCharacteristic!
    private var dout0_rx: CBCharacteristic!
    
    private var errLow_tx: CBCharacteristic!
    private var errLow_rx: CBCharacteristic!
    private var errHigh_tx: CBCharacteristic!
    private var errHigh_rx: CBCharacteristic!
    private var mode_tx: CBCharacteristic!
    private var mode_rx: CBCharacteristic!

    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    
    @Published var maxAmpData: [[Int]] = []
    @Published var minAmpData: [[Int]] = []
//    @ObservedObject var iceMachineState = IceMachineStatus()
    @Published var minEntries: [ChartDataEntry] = []
    @Published var maxEntries: [ChartDataEntry] = []
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
        print("\(characteristics[0])")
        print("\(characteristics[1])")
        print("\(characteristics[2])")
//        print("\(characteristics[3])")
//        print("\(characteristics[4])")
//        print("\(characteristics[5])")
//        print("\(characteristics[6])")
        

        for characteristic in characteristics {
            
            if (characteristic.uuid.uuidString == CBUUIDs.ampsLow_UUID)  {
                ampsLow_rx = characteristic
                ampsLow_tx = characteristic
                peripheral.setNotifyValue(true, for: ampsLow_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.ampsHigh_UUID)  {
                ampsHigh_rx = characteristic
                ampsHigh_tx = characteristic
                peripheral.setNotifyValue(true, for: ampsHigh_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.mergedin1UUID) {
                mergedin1_rx = characteristic
                mergedin1_tx = characteristic
                peripheral.setNotifyValue(true, for: mergedin1_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.mergedin2_UUID) {
                mergedin2_rx = characteristic
                mergedin2_tx = characteristic
                peripheral.setNotifyValue(true, for: mergedin2_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.dipSwitches_UUID) {
                dipSwitches_rx = characteristic
                dipSwitches_tx = characteristic
                peripheral.setNotifyValue(true, for: dipSwitches_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.dout0_UUID) {
                dout0_rx = characteristic
                dout0_tx = characteristic
                peripheral.setNotifyValue(true, for: dout0_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.errLow_UUID) {
                errLow_rx = characteristic
                errLow_tx = characteristic
                peripheral.setNotifyValue(true, for: errLow_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.errHigh_UUID) {
                errLow_rx = characteristic
                errLow_tx = characteristic
                peripheral.setNotifyValue(true, for: errHigh_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.mode_UUID) {
                mode_rx = characteristic
                mode_tx = characteristic
                peripheral.setNotifyValue(true, for: mode_rx!)
                peripheral.readValue(for: characteristic)
            }
    
//            if characteristic.uuid.isEqual(CBUUIDs.BLE_Characteristic_uuid_Tx){

//                ampsLow_tx = characteristics[0]
//                ampsHigh_tx = characteristics[1]
                
//                print("TX Characteristic: \(txCharacteristic.uuid)")
//            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        

        guard let characteristicValue = characteristic.value else {
            // no data transmitted, handle if needed
            print("error")
            return
        }
        
        print("This is \(characteristicValue.count)")
        print("\(characteristic.uuid)")
        print("\(characteristicValue)")
//        var temp: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0];
        if(characteristic.uuid.uuidString == CBUUIDs.ampsLow_UUID){
            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
                self.minEntries.append(ChartDataEntry(x: Double(characteristicValue[i]), y: Double(characteristicValue[i+1]), data: "Min Amp data"))
                if (self.minAmpData.count > 50){
                    self.minAmpData = self.minAmpData.suffix(20)
                }
                self.minAmpData.append([Int(characteristicValue[i]), Int(characteristicValue[i+1])])
            }
            
        } else if (characteristic.uuid.uuidString == CBUUIDs.ampsHigh_UUID){
            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
                self.maxEntries.append(ChartDataEntry(x: Double(characteristicValue[i]), y: Double(characteristicValue[i+1]), data: "Max Amp data"))
                
                if (self.maxAmpData.count > 50){
                    self.maxAmpData = self.maxAmpData.suffix(20)
                }
                self.maxAmpData.append([Int(characteristicValue[i]), Int(characteristicValue[i+1])])
            }
        } else if (characteristic.uuid.uuidString == CBUUIDs.dipSwitches_UUID){
            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
//                let power: UInt8 = 1
//                let low_bin: UInt8 = 2
//                let ice: UInt8 = 4
//                let sleep: UInt8 = 8
//                let delay: UInt8 = 16
//                let low_water: UInt8 = 32
//                let maintenance: UInt8 = 64
//                let service: UInt8 = 128
                status.statusArray = [0,0,0,0,0,0,0,0,0,0,0,0]
                var masks: [UInt8] = [1,2,4,8,16,32,64,128]
                
                let val = UInt8(characteristicValue[i])
                
                
                for i in 0...7 {
                    if (val&masks[i] >= 1){
                        status.statusArray[i] = 1
                    }
                }
                
//                CLEAN_MASK = 0x01,
//                EXTRA_OUT_MASK = 0x02, // positive
//                RESERVED_MASK = 0x04,
//                PM_MASK = 0x08,
//                DRIP_TRAY_MASK = 0x10,
//                WATER_LEAK_MASK = 0x20,
//                HI_PRESSURE_MASK = 0x40,
//                HI_AMP_MASK = 0x80,
                
//                var masks2: [UInt8] = [16,32,64,128]
//
//                let val = UInt8(characteristicValue[i])
//
//                for i in 0...3 {
//                    if (val&masks[i] >= 1){
//                        status.statusArray[i+8] = 1
//                    }
//                }
                
//                let x: UInt8 = 8
//                print(Double(characteristicValue[i]))
//                print(UInt8(characteristicValue[i]))
//                print(UInt8(characteristicValue[i]).bin)
//                print((UInt8(characteristicValue[i]) & x).bin)
//                print((UInt8(characteristicValue[i]) & x)>1)
//                self.maxEntries.append(ChartDataEntry(x: Double(characteristicValue[i]), y: Double(characteristicValue[i+1]), data: "Max Amp data"))
//                self.maxAmpData.append([Int(characteristicValue[i]), Int(characteristicValue[i+1])])
            }
        }
        else {

//            for i in stride(from: 0, through: characteristicValue.count - 1, by: 1) {
//                temp[i] = Int(characteristicValue[i]);
//                status.statusArray = temp;
//
//            }
        }
        
        
        
        
    }
    
    func writeOutgoingValue(data: String){
          
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        
        if let myPeripheral = myPeripheral {
              
            if let txCharacteristic = ampsLow_tx {
                myPeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func startScanning() {
        print("startScanning")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
     }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    
    func connect(peripheralName: String){
        
        if let peripheralToConnect = peripherals.first(where: {$0.name == peripheralName}) {
            self.myCentral.connect(peripheralToConnect.cbPerpheral, options: nil)
            peripheralToConnect.cbPerpheral.readValue(for: ampsLow_rx)
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

extension UInt8 {
    var bin: String {
        String(self, radix: 2).leftPad(with: "0", length: 8)
    }
}

fileprivate extension String {
    
    func leftPad(with character: Character, length: UInt) -> String {
        let maxLength = Int(length) - count
        guard maxLength > 0 else {
            return self
        }
        return String(repeating: String(character), count: maxLength) + self
    }
}
