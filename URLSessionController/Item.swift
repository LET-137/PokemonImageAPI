//
//  Item.swift
//  URLSessionController
//
//  Created by 津本拓也 on 2024/08/29.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
