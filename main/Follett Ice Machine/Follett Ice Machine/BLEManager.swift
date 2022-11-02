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

    static let mode_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A1"
    static let ampsLow_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A2"
    static let ampsHigh_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A3"
    static let dipSwitch_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A4"
    static let errHigh_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A5"
    static let led1_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A6"
    static let led2_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A7"
    
//    static let mergedin1UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26B1"
//    static let mergedin2_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A4"
//    static let dipSwitches_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A5"
//    static let dout0_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A6"
    
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    var myCentral: CBCentralManager!
    var myPeripheral: CBPeripheral!
    
    private var ampsLow_tx: CBCharacteristic!
    private var ampsLow_rx: CBCharacteristic!
    private var ampsHigh_tx: CBCharacteristic!
    private var ampsHigh_rx: CBCharacteristic!
    
//    private var mergedin1_tx: CBCharacteristic!
//    private var mergedin1_rx: CBCharacteristic!
//    private var mergedin2_tx: CBCharacteristic!
//    private var mergedin2_rx: CBCharacteristic!
    
//    private var dipSwitches_tx: CBCharacteristic!
//    private var dipSwitches_rx: CBCharacteristic!
//    private var dout0_tx: CBCharacteristic!
//    private var dout0_rx: CBCharacteristic!
    
    private var dipSwitch_tx: CBCharacteristic!
    private var dipSwitch_rx: CBCharacteristic!
    private var errHigh_tx: CBCharacteristic!
    private var errHigh_rx: CBCharacteristic!
    private var mode_tx: CBCharacteristic!
    private var mode_rx: CBCharacteristic!
    private var led1_tx: CBCharacteristic!
    private var led1_rx: CBCharacteristic!
    private var led2_tx: CBCharacteristic!
    private var led2_rx: CBCharacteristic!

    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    
    @Published var maxAmpData: [[Double]] = []
    @Published var minAmpData: [[Double]] = []
    @Published var modeData: [[Double]] = []
    @Published var errHighData: [[Double]] = []
    @Published var dipSwitchData: [[Double]] = []
    @Published var led1Data: [[Double]] = []
    @Published var led2Data: [[Double]] = []
    
//    @ObservedObject var iceMachineState = IceMachineStatus()
    @Published var minEntries: [ChartDataEntry] = []
    @Published var maxEntries: [ChartDataEntry] = []
    @Published var modeEntries: [ChartDataEntry] = []
    @Published var errorEntries: [BarChartDataEntry] = []
    var status = IceMachineStatus.shared
    var dpStatus = DipSwitchStatus.dswitch
    var counter = 0

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
        print("\(characteristics[3])")
        print("\(characteristics[4])")
        print("\(characteristics[5])")
        print("\(characteristics[6])")
        
        

        for characteristic in characteristics {
            
            if (characteristic.uuid.uuidString == CBUUIDs.mode_UUID) {
                mode_rx = characteristic
                mode_tx = characteristic
                peripheral.setNotifyValue(true, for: mode_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.ampsLow_UUID)  {
                ampsLow_rx = characteristic
                ampsLow_tx = characteristic
                peripheral.setNotifyValue(true, for: ampsLow_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.ampsHigh_UUID)  {
                ampsHigh_rx = characteristic
                ampsHigh_tx = characteristic
                peripheral.setNotifyValue(true, for: ampsHigh_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.dipSwitch_UUID) {
                dipSwitch_rx = characteristic
                dipSwitch_tx = characteristic
                peripheral.setNotifyValue(true, for: dipSwitch_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.errHigh_UUID) {
                errHigh_rx = characteristic
                errHigh_tx = characteristic
                peripheral.setNotifyValue(true, for: errHigh_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.led1_UUID) {
                led1_rx = characteristic
                led1_tx = characteristic
                peripheral.setNotifyValue(true, for: led1_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.led2_UUID) {
                led2_rx = characteristic
                led2_tx = characteristic
                peripheral.setNotifyValue(true, for: led2_rx!)
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        

        guard let characteristicValue = characteristic.value else {
            // no data transmitted, handle if needed
            print("error")
            return
        }
        
//        print("This is \(characteristicValue.count)")
//        print("\(characteristic.uuid)")
//        print("\(characteristicValue)")
        
        if (characteristic.uuid.uuidString == CBUUIDs.mode_UUID){
            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
                counter = Int(characteristicValue[i])
                self.modeEntries.append(ChartDataEntry(x: Double(characteristicValue[i]), y: Double(characteristicValue[i+1]), data: "Mode data"))
                self.modeData.append([Double(characteristicValue[i]), Double(characteristicValue[i+1])])
            }
        } else if(characteristic.uuid.uuidString == CBUUIDs.ampsLow_UUID){
            let time = Date().timeIntervalSince1970
//                let value = [UInt8](characteristic.value!)
            self.minEntries.append(ChartDataEntry(x: Double(time), y: Double(characteristicValue[0]), data: "Min Amp data"))
//                print(characteristicValue[0])
//                print(characteristicValue[1])
            
            if (self.minAmpData.count > 50){
                self.minAmpData = self.minAmpData.suffix(20)
            }
            self.minAmpData.append([Double(time), Double(characteristicValue[0])])
            
        } else if (characteristic.uuid.uuidString == CBUUIDs.ampsHigh_UUID){
            let time = Date().timeIntervalSince1970
        //                let value = [UInt8](characteristic.value!)
            self.maxEntries.append(ChartDataEntry(x: Double(time), y: Double(characteristicValue[0]), data: "Max Amp data"))
            
            if (self.maxAmpData.count > 50){
                self.maxAmpData = self.maxAmpData.suffix(20)
            }

            self.maxAmpData.append([Double(time), Double(characteristicValue[0])])
            
        } else if (characteristic.uuid.uuidString == CBUUIDs.led1_UUID){
            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
                status.statusArray = [1,0,0,0,0,0,0,0,0,0,0,0]
                let masks: [UInt8] = [1,2,4,8,16,32,64,128]
                
                let val = UInt8(characteristicValue[i+1])
                let time = Date().timeIntervalSince1970
                
                for i in 1...7 {
                    if (val&masks[i] >= 1){
                        status.statusArray[i] = 1
                    }
                }
                self.led1Data.append([Double(time), Double(characteristicValue[i+1])])
            }
        } else if (characteristic.uuid.uuidString == CBUUIDs.led2_UUID){
            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
                let masks: [UInt8] = [128,64,32,16]
                let val = UInt8(characteristicValue[i+1])
                let time = Date().timeIntervalSince1970
                if (val&1 >= 1){
                    status.statusArray[6] = 1
                }
                
                for i in 0...3 {
                    if (val&masks[i] >= 1){
                        status.statusArray[i+8] = 1
                    }
                }
                self.led2Data.append([Double(time), Double(characteristicValue[i+1])])
            }

        } else if (characteristic.uuid.uuidString == CBUUIDs.errHigh_UUID){
            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
                let val = UInt16(characteristicValue[i])
                var errState = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                let masks: [UInt16] = [1,2,4,8,16,32,64,128,256,512,32768]
                let time = Date().timeIntervalSince1970
                
                for i in 0...10{
                    if (val&masks[i] >= 1){
                        errState[i] = 1.0
                    }
                }
                
                self.errorEntries.append(BarChartDataEntry(x: Double(time), yValues: errState, data: "Error data"))
                self.errHighData.append([Double(time), Double(characteristicValue[i+1])])
            }
        } else if (characteristic.uuid.uuidString == CBUUIDs.dipSwitch_UUID){
            
            dpStatus.isOn = [false, false, false, false, false, false, false, false]
            let masks: [UInt8] = [1,2,4,8,16,32,64,128]
            let time = Date().timeIntervalSince1970
            let val = UInt8(characteristicValue[0])

            for i in 0...7 {
                if (val&masks[i] >= 1){
                    dpStatus.isOn[i] = true
                }
            }
            
            self.dipSwitchData.append([Double(time), Double(characteristicValue[0])])

        } else {

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
