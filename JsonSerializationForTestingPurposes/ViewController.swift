//
//  ViewController.swift
//  JsonSerializationForTestingPurposes
//
//  Created by Milos Dimic on 10/7/18.
//  Copyright © 2018 Milos Dimic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    lazy var barChartItemFastWay = getBarChartItemFastWay()
    lazy var barChartItemTheRightWay = getBarChartItemTheRightWay()
    lazy var barChartItemTheBestWay = getBarChartItemTheBestWay()
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("START")
        print(barChartItemFastWay?.value ?? "", barChartItemFastWay?.normTime ?? "")
        print(barChartItemTheRightWay?.value ?? "", barChartItemTheRightWay?.normTime ?? "")
        print(barChartItemTheBestWay?.value ?? "")
        print("END")
    }
    
    // MARK: Private methods
    
    private func getBarChartItemFastWay() -> BarChartItem? {
        let json = ["value" : 39.2, "norm_time" : 11.35]
        let data = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        return try? JSONDecoder().decode(BarChartItem.self, from: data)
    }
    
    private func getBarChartItemTheRightWay() -> BarChartItem? {
        let filePath = Bundle(for: type(of: self)).path(forResource: "BarChartItemJson", ofType: "txt")!
        let jsonString = try! String(contentsOfFile: filePath, encoding: .utf8)
        let data = Data(jsonString.utf8)
        
        do {
            let baby = try JSONDecoder().decode(BarChartItem.self, from: data)
            return baby
        }
        catch {
            print("ERROR: \(error)")
            return nil
        }
    }
    
    private func getBarChartItemTheBestWay() -> BarChartItem? {
       return try? BarChartItem.create(with: BarChartItem.Test.init(value: 1.2345))
    }
}

extension BarChartItem {
    
    // MARK: Class methods
    
    static func create(with testModel: Test) throws -> BarChartItem {
        let data = try JSONEncoder().encode(testModel)
        return try JSONDecoder().decode(BarChartItem.self, from: data)
    }
}

extension BarChartItem {
    
    struct Test: Encodable {
        
        // MARK: Properties
        
        let value: Double?
        let normTime: Double?
        
        // MARK: Init
        
        init(value: Double? = nil, normTime: Double? = nil) {
            self.value = value
            self.normTime = normTime
        }
        
        // MARK: Public methods
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(value, forKey: .value)
            try container.encode(normTime, forKey: .normTime)
        }
        
        // MARK: Codable
        
        enum CodingKeys: CodingKey {
            case value
            case normTime
        }
    }
}
