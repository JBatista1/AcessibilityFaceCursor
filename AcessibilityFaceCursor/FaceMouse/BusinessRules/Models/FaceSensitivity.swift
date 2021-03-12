//
//  FaceSensitivity.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 28/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

public struct FaceSensitivity: Equatable {

  public var limitedTopX: CGFloat
  public var limitedBottonX: CGFloat
  public var limitedLeftY: CGFloat
  public var limitedRightY: CGFloat

  public init(limitedTopX: CGFloat, limitedBottonX: CGFloat, limitedLeftY: CGFloat, limitedRightY: CGFloat) {
    self.limitedTopX = limitedTopX
    self.limitedBottonX = limitedBottonX
    self.limitedLeftY = limitedLeftY
    self.limitedRightY = limitedRightY
  }

  public static func getDefault() -> FaceSensitivity {
    return FaceSensitivity(limitedTopX: ValuesConstants.limitedX,
                           limitedBottonX: -ValuesConstants.limitedX,
                           limitedLeftY: ValuesConstants.limitedY,
                           limitedRightY: -ValuesConstants.limitedY)
  }

  public func getLimitedX() -> CGFloat {
    return abs(limitedTopX) + abs(limitedBottonX)
  }
  
  public func getLimitedY() -> CGFloat {
    return abs(limitedLeftY) + abs(limitedRightY)
  }
  
}
