//
//  Direction.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 01/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

public enum Direction: String {
  case top = "Cima"
  case botton = "Baixo"
  case left = "Esquerda"
  case right = "Direita"

  public var image: UIImage {
    switch self {
    case .top:
      return Asset.arrowTop.image
    case .botton:
      return Asset.arrowBotton.image
    case .left:
      return Asset.arrowLeft.image
    case .right:
      return Asset.arrowRight.image
    }
  }
  public var direction: DirectiorFaceMoviment {
    switch self {
    case .top, .botton:
      return .axisY
    case .left, .right:
      return .axisY
    }
  }
}
