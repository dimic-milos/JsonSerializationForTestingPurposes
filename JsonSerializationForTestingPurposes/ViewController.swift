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
        print(barChartItemFastWay?.value ?? "", barChartItemFastWay?.normTime ?? "", barChartItemFastWay?.legal?.first?.contractNumber ?? "", barChartItemFastWay?.legal?.first?.agreed ?? "")
        print(barChartItemTheRightWay?.value ?? "", barChartItemTheRightWay?.normTime ?? "", barChartItemTheRightWay?.legal?.first?.contractNumber ?? "", barChartItemTheRightWay?.legal?.first?.agreed ?? "")
        print(barChartItemTheBestWay?.value ?? "", barChartItemTheBestWay?.normTime ?? "", barChartItemTheBestWay?.legal?.first?.contractNumber ?? "", barChartItemTheBestWay?.legal?.first?.agreed ?? "")
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
        let legal = Legal(agreed: true, contractNumber: 33)
        return try? BarChartItem.create(with: BarChartItem.Test.init(value: 0.7, normTime: 0.8, legal: [legal]))
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
        var legal: [Legal]?
        
        // MARK: Init
        
        init(value: Double? = nil, normTime: Double? = nil, legal: [Legal]? = nil) {
            self.value = value
            self.normTime = normTime
            self.legal = legal
        }
        
        // MARK: Public methods
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(value, forKey: .value)
            try container.encode(normTime, forKey: .normTime)
            try container.encode(legal, forKey: .legal)
        }
        
        // MARK: Codable
        
        enum CodingKeys: String, CodingKey {
            case normTime = "norm_time"
            case value
            case legal = "legal_info"
        }
    }
}
