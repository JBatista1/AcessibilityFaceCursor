//
//  ManagePointSensibility.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 28/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

class ManagePointSensibility {

  private let tolerance: CGFloat
  private let numberAcceptedValues: Int
  private (set) var valuesAceepted: [CGFloat] = []
  private let startValue: Int

  private (set) var lastValue: CGFloat = 0.0
  private (set) var isInitial: Bool = true
  private var isStart: Bool = false
  weak var delegate: ManagerPointSesibilittyProtocol?

  internal init(tolerance: CGFloat = ValuesConstants.tolerance,
                numberAcceptedValues: Int = ValuesConstants.numberAcceptedValues,
                valueForStart: Int = ValuesConstants.valueForStart) {
    self.tolerance = tolerance
    self.numberAcceptedValues = numberAcceptedValues
    self.startValue = valueForStart
  }

  func insertValueToCompare(thePoint point: CGPoint, andDirection direction: DirectiorFaceMoviment) {
    let valueAxis = getValue(withThePoint: point, andDirection: direction)
    if verifyIsStartCapture(withValueLimited: startValue) {
      calledStartCapture()
      captureStart(withValue: valueAxis)
    } else {
      captureNotStart(withValue: valueAxis)
    }
    lastValue = valueAxis
  }

  private func captureNotStart(withValue value: CGFloat) {
    getInitialPosition(withValue: value)
    updateArray(withValue: value)
  }

  private func captureStart(withValue value: CGFloat) {
    updateArray(withValue: value)
    if verifyIsStartCapture(withValueLimited: numberAcceptedValues) {
      delegate?.captureFinishWith(theValue: getAverage())
      resetProprety()
    }
  }

  private func resetProprety() {
    valuesAceepted = []
    isStart = false
    isInitial = true
  }
  
  private func calledStartCapture() {
    if !isStart {
      delegate?.capturaStartGetValue()
      isStart = true
    }
  }
  private func getInitialPosition(withValue value: CGFloat) {
    if isInitial {
      lastValue = value
      isInitial = false
    } 
  }

  private func getValue(withThePoint point: CGPoint, andDirection direction: DirectiorFaceMoviment) -> CGFloat {
    switch direction {
    case .axisX:
      return point.x
    case .axisY:
      return point.y
    }
  }

  private func makeADifference(withValue value: CGFloat) -> Bool {
    return (abs(value) - abs(lastValue)) < tolerance
  }

  private func updateArray(withValue value: CGFloat) {
    if makeADifference(withValue: value) {
      valuesAceepted.append(value)
    } else {
      valuesAceepted = []
    }
  }

  private func verifyIsStartCapture(withValueLimited value: Int) -> Bool {
    return  valuesAceepted.count >= value
  }

  private func getAverage() -> CGFloat {
    return valuesAceepted.reduce(0, +) / CGFloat(valuesAceepted.count)
  }
}
