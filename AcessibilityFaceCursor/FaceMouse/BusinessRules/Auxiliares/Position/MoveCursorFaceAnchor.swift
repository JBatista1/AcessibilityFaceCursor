//
//  MoveCursorFaceAnchor.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 11/01/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

final class MoveCursorFaceAnchor {

  // MARK: - Private Property

  private typealias PercentagemAxis = (percentagemX: Int, percentagemY: Int)
  private var lastPercentagem = PercentagemAxis(0, 0)
  private var lastPosition = CGPoint.zero
  private var totalPercentage: CGFloat = 100
  private (set) var faceSensitivity: FaceSensitivity = FaceSensitivity.getDefault()

  // MARK: - Life Cicle

  init(faceSensitivity: FaceSensitivity? = nil) {
    if let sensitivity = faceSensitivity {
      self.faceSensitivity = sensitivity
    }
  }

  public func set(faceSensitivity: FaceSensitivity) {
    self.faceSensitivity = faceSensitivity
  }

  // MARK: - Private Method

  private func verifyDirectionMove(withCoordinate coordinate: CGFloat) -> MovimentDirection {
    if coordinate > 0 {
      return .positive
    } else {
      return .negative
    }
  }

  private func getPercentage(withFacePosition position: CGFloat, andLimitedAxis limited: CGFloat) -> Int {
    if position < limited {
      return Int(((position * totalPercentage))/limited)
    } else {
      return Int(((limited * totalPercentage))/limited)
    }
  }

  private func getNewPosition(withPercentage percentage: Int, MovimentDirection direction: MovimentDirection, andMaxValue maxValue: CGFloat) -> CGFloat {
    let valueMoviment = (CGFloat(percentage)*maxValue)/100
    switch direction {
    case .positive:
      return maxValue + valueMoviment
    case .negative:
      return maxValue - valueMoviment
    }
  }
}

// MARK: - Extensions

extension MoveCursorFaceAnchor: MoveCursorProtocol {

  func getNextPosition(withPoint point: CGPoint) -> CGPoint {

    var newPositionCursor = CGPoint.zero

    var percentagemX = 0
    var percentagemY = 0

    let directionX = verifyDirectionMove(withCoordinate: point.x)

    switch directionX {
    case .positive:
      percentagemX = getPercentage(withFacePosition: point.x, andLimitedAxis: faceSensitivity.getLimitedX())
    case .negative:
      percentagemX = getPercentage(withFacePosition: -point.x, andLimitedAxis: faceSensitivity.getLimitedX())
    }

    let directionY = verifyDirectionMove(withCoordinate: point.y)
    switch directionY {
    case .positive:
      percentagemY = getPercentage(withFacePosition: point.y, andLimitedAxis: faceSensitivity.getLimitedY())
    case .negative:
      percentagemY = getPercentage(withFacePosition: -point.y, andLimitedAxis: faceSensitivity.getLimitedY())
    }

    newPositionCursor.x = getNewPosition(withPercentage: percentagemX, MovimentDirection: directionX, andMaxValue: Screen.center.x)

    newPositionCursor.y = getNewPosition(withPercentage: percentagemY, MovimentDirection: directionY, andMaxValue: Screen.center.y)

    lastPercentagem = (percentagemX, percentagemY)
    lastPosition = newPositionCursor

    return newPositionCursor
  }
}
