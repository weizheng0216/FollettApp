//
//  DataTableView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/4/22.
//  The data table template view that is used to store data for each value

import SwiftUI
import Tabler

struct DataPoint: Identifiable {
    // the id would be the x (double representing the date), and value would be the y (the value reading)
    var id: Double
    var value: Int
}

struct DataTableView: View {
    
    // unhandled raw data passed in by the BLEManager
    var rawData: [[Double]]
    var tableName: String
    var employeeArray:[Dictionary<String, AnyObject>] =  Array()
    
    init(rawData: [[Double]], tableName: String){
        self.rawData = rawData
        self.tableName = tableName
    }
    
    // take the raw data and convert to desire type
    func convertToDataPoint(rawData:[[Double]]) -> [DataPoint]{
        var tempData: [DataPoint] = []
        
        for(_, values) in rawData.enumerated() {
            tempData.append(DataPoint(id: values[0], value: Int(values[1])))
        }
        
        return tempData
    }
    
    private var gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 50), spacing: 0, alignment: .center),
        GridItem(.flexible(minimum: 50), spacing: 0, alignment: .center),
    ]

    private typealias Context = TablerContext<DataPoint>

    private func header(ctx: Binding<Context>) -> some View {
        // two column table
        LazyVGrid(columns: gridItems) {
            Text("Time")
            Text("Value")
        }
    }
    
    private func row(datapoint: DataPoint) -> some View {
        LazyVGrid(columns: gridItems) {
            // first column would be the date string that was converted by the passed over double
            Text(DateValueFormatter().stringForValue(datapoint.id, axis: nil))
            // second column would be the value reading
            Text(String(format: "%d", datapoint.value))
        }
    }
    
    func createCSV() {
        
        var dataArray:[Dictionary<String, AnyObject>] =  Array()
        
        for i in 0..<rawData.count {
            var dct = Dictionary<String, AnyObject>()
            dct.updateValue(DateValueFormatter().stringForValue(rawData[i][0], axis: nil) as AnyObject, forKey: "Time")
            dct.updateValue(rawData[i][1] as AnyObject, forKey: "Value")
            dataArray.append(dct)
       }
        
        var csvString = "\("Time"),\(tableName)\n\n"
        
        for dct in dataArray {
            csvString = csvString.appending("\(String(describing: dct["Time"]!)) ,\(String(describing: dct["Value"]!))\n")
        }
            
        
        do {
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(tableName).csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print(csvString)
        } catch {
            print("error creating file")
        }

    }

    var body: some View {
        ZStack {
            
            TablerList(header: header,
                       row: row,
                       results: convertToDataPoint(rawData: rawData))
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        createCSV()
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 70, height: 70)
                    })
                    .buttonStyle(PlainButtonStyle())
                    .background(Color.blue)
                    .cornerRadius(38.5)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                }
            }
        }
    }
}



