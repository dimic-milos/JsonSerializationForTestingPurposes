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
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("START")
        print(barChartItemFastWay?.value ?? "", barChartItemFastWay?.normTime ?? "")
        print(barChartItemTheRightWay?.value ?? "", barChartItemTheRightWay?.normTime ?? "")
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


}


