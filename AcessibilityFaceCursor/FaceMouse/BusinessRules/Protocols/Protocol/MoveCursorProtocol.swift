//
//  MoveCursorProtocol.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 07/01/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

public protocol MoveCursorProtocol: AnyObject {
  func getNextPosition(withPoint point: CGPoint) -> CGPoint
  func set(faceSensitivity: FaceSensitivity)
}
