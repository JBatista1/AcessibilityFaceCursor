//
//  CGFloatExtension.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 14/01/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

extension CGFloat {

  func truncate(withDecimalplaces places: Int = 4) -> CGFloat {
    if places <= 0 || places > ValuesConstants.maxPlacesCGFloat { return self }
    
    let base = CGFloat(pow(Double(10), Double(places)))
    let truncateValue = Int(self * base)
    return CGFloat(CGFloat(truncateValue) / base)
  }
}
