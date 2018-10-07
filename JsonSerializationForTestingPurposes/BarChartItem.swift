//
//  BarChartItem.swift
//  JsonSerializationForTestingPurposes
//
//  Created by Milos Dimic on 10/7/18.
//  Copyright © 2018 Milos Dimic. All rights reserved.
//

import Foundation

final class BarChartItem: Decodable {
    
    // MARK: - Decodable
    
    enum CodingKeys: String, CodingKey {
        case normTime = "norm_time"
        case value = "value"
    }
    
    // MARK: - Properties
    
    var normTime: Double?
    var value: Double?
    
    // MARK: - Init methods
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        normTime = try? values.decode(Double.self, forKey: .normTime)
        value = try? values.decode(Double.self, forKey: .value)
    }
    
}
