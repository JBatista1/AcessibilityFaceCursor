//
//  UIViewsExtensionTest.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 10/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import XCTest
import UIKit
@testable import AcessibilityFaceMouse

class UIViewExtensionTest: XCTestCase {

  let window = UIWindow(frame: UIScreen.main.bounds)
  override func setUpWithError() throws {

  }

  // MARK: - FaceSensitivity test

  func testGetViewAcessibilitySuccess() throws {
    let view = UIView()
    let buttonAcessibility = UIButton()
    view.addSubview(buttonAcessibility)
    buttonAcessibility.accessibilityIdentifier = AccessibilityUIType.uiButton.identifier

    XCTAssertEqual(view.getViewAcessibility(WithType: .uiButton),buttonAcessibility, "Os identificadores tem que ser iguais")
  }

  func testGetViewAcessibilityErrorVoid() throws {
    let view = UIView()
    XCTAssertNil(view.getViewAcessibility(WithType: .uiButton), "Nenhum identificador deve ser localizado")
  }

  func testGetViewAcessibilityErrorIFElement() throws {
    let view = UIView()
    let buttonAcessibility = UIButton()
    view.addSubview(buttonAcessibility)
    XCTAssertNil(view.getViewAcessibility(WithType: .uiButton), "Nenhum identificador deve ser localizado")
  }

  func testReturnAbsoluteValueSucess() throws {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    let buttonAcessibility = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    view.addSubview(buttonAcessibility)
    let absoluteValue = buttonAcessibility.returnAbsoluteValue(basedInWindows: window)
    XCTAssertEqual(absoluteValue, CGRect(x: 0, y: 0, width: 200, height: 50), "O valor deve ser em relação a tela")
  }

  func testReturnAbsoluteValueErrorNotSuper() throws {
    let buttonAcessibility = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    let absoluteValue = buttonAcessibility.returnAbsoluteValue(basedInWindows: window)
    XCTAssertEqual(absoluteValue, CGRect(x: 0, y: 0, width: 0, height: 0), "O valor deve ser em relação a tela")
  }
  func testabsoluteValueToFrameErrorNotWindows() throws {
    let buttonAcessibility = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    let absoluteValue = buttonAcessibility.absoluteValueToFrame()
    XCTAssertEqual(absoluteValue, CGRect(x: 0, y: 0, width: 0, height: 0), "O valor deve ser em relação a tela")
  }

}
