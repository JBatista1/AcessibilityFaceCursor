//
//  TableViewSelectedProtocol.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 25/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import Foundation

public protocol CellViewSelectedProtocol: AnyObject {
  func cellSelected(withIndex index: IndexPath)
}
