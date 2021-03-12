//
//  ManagePointSensibilityTest.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 09/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import XCTest
import UIKit
@testable import AcessibilityFaceMouse

class ManagePointSensibilityTest: XCTestCase {

  var managerSut: ManagePointSensibility!
  var mockManageSpy: MockManagePointSensibilityDelegate!

  let arrayAxisX = [CGPoint(x: 0.12, y: 0),
                    CGPoint(x: 0.1212, y: 0),
                    CGPoint(x: 0.1199, y: 0),
                    CGPoint(x: 0.12, y: 0),
                    CGPoint(x: 0.1212, y: 0),
                    CGPoint(x: 0.1199, y: 0),
                    CGPoint(x: 0.12, y: 0),
                    CGPoint(x: 0.1212, y: 0),
                    CGPoint(x: 0.1199, y: 0),
                    CGPoint(x: 0.12, y: 0),
                    CGPoint(x: 0.1212, y: 0),
                    CGPoint(x: 0.1199, y: 0)]

  let arrayAxisY = [CGPoint(x: 0, y:  0.12),
                    CGPoint(x: 0, y: 0.1212),
                    CGPoint(x: 0, y: 0.1199),
                    CGPoint(x: 0, y:  0.12),
                    CGPoint(x: 0, y: 0.1212),
                    CGPoint(x: 0, y: 0.1199),
                    CGPoint(x: 0, y:  0.12),
                    CGPoint(x: 0, y: 0.1212),
                    CGPoint(x: 0, y: 0.1199),
                    CGPoint(x: 0, y:  0.12),
                    CGPoint(x: 0, y: 0.1212),
                    CGPoint(x: 0, y: 0.1199),]

  let arrayAxisXnegative = [CGPoint(x: -0.12, y: 0),
                            CGPoint(x: -0.1212, y: 0),
                            CGPoint(x: -0.1199, y: 0),
                            CGPoint(x: -0.12, y: 0),
                            CGPoint(x: -0.1212, y: 0),
                            CGPoint(x: -0.1199, y: 0),
                            CGPoint(x: -0.12, y: 0),
                            CGPoint(x: -0.1212, y: 0),
                            CGPoint(x: -0.1199, y: 0),
                            CGPoint(x: -0.12, y: 0),
                            CGPoint(x: -0.1212, y: 0),
                            CGPoint(x: -0.1199, y: 0)]

  let arrayAxisYNegative = [CGPoint(x: 0, y:  -0.12),
                            CGPoint(x: 0, y: -0.1212),
                            CGPoint(x: 0, y: -0.1199),
                            CGPoint(x: 0, y:  -0.12),
                            CGPoint(x: 0, y: -0.1212),
                            CGPoint(x: 0, y: -0.1199),
                            CGPoint(x: 0, y:  -0.12),
                            CGPoint(x: 0, y: -0.1212),
                            CGPoint(x: 0, y: -0.1199),
                            CGPoint(x: 0, y:  -0.12),
                            CGPoint(x: 0, y: -0.1212),
                            CGPoint(x: 0, y: -0.1199),]

  let arrayAxisNoiseY = [CGPoint(x: 0, y:  0.12),
                         CGPoint(x: 0, y: 0.112),
                         CGPoint(x: 0, y: 0.1199),
                         CGPoint(x: 0, y:  0.42),
                         CGPoint(x: 0, y: 0.1212),
                         CGPoint(x: 0, y: 0.399),
                         CGPoint(x: 0, y:  0.12),
                         CGPoint(x: 0, y: 0.1212),
                         CGPoint(x: 0, y: 0.1199),
                         CGPoint(x: 0, y:  0.12),
                         CGPoint(x: 0, y: 0.1212),
                         CGPoint(x: 0, y: 0.1199),]

  override func setUpWithError() throws {
    managerSut = ManagePointSensibility(numberAcceptedValues: 10, valueForStart: 2)
    mockManageSpy = MockManagePointSensibilityDelegate()
    managerSut.delegate = mockManageSpy
  }

  func testInsertValueToCompareSucessAxisX() throws {
    for point in arrayAxisX {
      managerSut.insertValueToCompare(thePoint: point , andDirection: .axisX)
    }

    let exp = expectation(description: "Call back position")
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 3)
    XCTAssertGreaterThan(mockManageSpy.captureFinishWithSpy, 0.0,"Deveria retornar o valor capturado no eixo X positivo")
  }

  func testInsertValueToCompareSucessAxisY() throws {
    for point in arrayAxisY {
      managerSut.insertValueToCompare(thePoint: point , andDirection: .axisY)
    }

    let exp = expectation(description: "Call back position")
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 3)
    XCTAssertGreaterThan(mockManageSpy.captureFinishWithSpy, 0.0,"Deveria retornar o valor capturado no eixo Y positivo")
  }

  func testInsertValueToCompareSucessAxisXNegative() throws {
    for point in arrayAxisXnegative {
      managerSut.insertValueToCompare(thePoint: point , andDirection: .axisX)
    }

    let exp = expectation(description: "Call back position")
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 3)
    XCTAssertLessThan(mockManageSpy.captureFinishWithSpy, 0.0, "Deveria retornar o valor capturado no eixo X negativo")
  }

  func testInsertValueToCompareSucessAxisYNegative() throws {
    for point in arrayAxisYNegative {
      managerSut.insertValueToCompare(thePoint: point , andDirection: .axisY)
    }

    let exp = expectation(description: "Call back position")
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 3)
    XCTAssertLessThan(mockManageSpy.captureFinishWithSpy, 0.0, "Deveria retornar o valor capturado no eixo Y negativo")
  }

  func testCalledStartCapture() throws {
    for index in 0...3 {
      managerSut.insertValueToCompare(thePoint: arrayAxisX[index] , andDirection: .axisY)
    }

    let exp = expectation(description: "Call back position")
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 3)
    XCTAssertTrue(mockManageSpy.capturaStartGetValueSpy)
  }

  func testInsertValuewithNoise() throws {
    for index in 0...3 {
      managerSut.insertValueToCompare(thePoint: arrayAxisNoiseY[index] , andDirection: .axisY)
    }

    let exp = expectation(description: "Call back position")
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 3)
    XCTAssertEqual(managerSut.valuesAceepted.count, 0, "Deveria vir vazio pois encontrou um ruido")
  }

  func testVerifyLastValue() throws {
    for index in 0...1 {
      managerSut.insertValueToCompare(thePoint: arrayAxisNoiseY[index] , andDirection: .axisY)
    }

    let exp = expectation(description: "Call back position")
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 3)
    XCTAssertNotEqual(managerSut.lastValue, 0, "Não deveria vir vazio, pois o primeiro ja foi inserido")
    XCTAssertFalse(managerSut.isInitial, "Não deveria vir false, pois o primeiro ja foi inserido")
  }
}


