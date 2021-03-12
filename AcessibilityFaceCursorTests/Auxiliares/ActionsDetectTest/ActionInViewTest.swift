//
//  ActionInViewTests.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 03/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import XCTest
import UIKit
@testable import AcessibilityFaceMouse

class ActionInViewTests: XCTestCase {

  var actionView: ActionInView!
  var mockViewControllerSut = MockTestViewController()
  var positionSut: MockPosition!

  override func setUpWithError() throws {
    positionSut = MockPosition(views: mockViewControllerSut.getViews())
    mockViewControllerSut.beginAppearanceTransition(true, animated: false)
    mockViewControllerSut.endAppearanceTransition()
    actionView = ActionInView(target: mockViewControllerSut, position: positionSut)
    mockViewControllerSut.viewDidLoad()
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  @objc func testSelector(){}

  //MARK: - ShotCut test Async

  func prepareTestGetViewForAction(withPoint point: CGPoint) {
    let viewsAction = mockViewControllerSut.getViewsActions()
    actionView.set(viewsAction: viewsAction)
    actionView.getViewForAction(withPoint: point)
  }

  //MARK: - Update Values Test

  func testGetTypeActionDefault() throws {
    let actualType = actionView.getType()
    XCTAssertEqual(TypeStartAction.tongue, actualType, "O tipo padrão foi modificado")
  }

  func testUpdateTypeActionDefault() throws {
    actionView.setTypeStartAction(withType: .eyeLeft)
    XCTAssertEqual(TypeStartAction.eyeLeft, actionView.getType(), "O tipo padrão não foi atualizado")
  }

  func testUpdateTypeStartAction() throws {
    let view = UIView()
    let viewsAction = ViewAction(view: view, selector: #selector(testSelector))
    actionView.set(viewsAction: [viewsAction])
    XCTAssertEqual(actionView.viewsAction.count, 1, "View Action não foi inserida ou existe mais de uma")
    XCTAssertEqual(actionView.viewsAction.first, viewsAction, "View Actions inserida não é a mesma que esta no objecto actionViews")

  }

  func testDefaultPositionNull() throws {
    actionView = ActionInView(target: mockViewControllerSut)
    XCTAssertNil(actionView.position, "Position deveria ser criada ao receber as views")
  }

  func testDefaultPositionNotNull() throws {
    actionView = ActionInView(target: mockViewControllerSut)
    actionView.set(viewsAction: mockViewControllerSut.getViewsActions())
    XCTAssertNotNil(actionView.position, "Position deveria ter sido criada")
  }

  // MARK: - GetViewAction Test

  func testGetViewForActionSucess() throws {
    let exp = expectation(description: "Call back position")
    prepareTestGetViewForAction(withPoint: CGPoint(x: 10, y: 120))
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 5)
    XCTAssertTrue(mockViewControllerSut.selectorCalledView,"Selector da view não foi chamada mesmo não estando na posição designada, verificar posição")
  }

  func testGetViewForActionError() throws {
    let exp = expectation(description: "Call back position")
    prepareTestGetViewForAction(withPoint: CGPoint(x: 500, y: 1120))
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 5)
    XCTAssertFalse(mockViewControllerSut.selectorCalledView, "Selector da view foi chamada mesmo não estando na posição designada, verificar posição")
  }

  // MARK: - TimerCooldown Test

  func testGetViewForActionIsInCooldown() throws {
    let exp = expectation(description: "Call back position")
    prepareTestGetViewForAction(withPoint: CGPoint(x: 10, y: 120))
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 2)
    XCTAssertTrue(actionView.isCooldown, "Função de Timer não foi acionado para action valida")
  }

  func testGetViewForActionNotISCooldown() throws {
    prepareTestGetViewForAction(withPoint: CGPoint(x: 10, y: 120))
    XCTAssertFalse(actionView.isCooldown, "Função de Timer foi acionado para action invalida")
  }

  func testGetViewForActionIsCooldownInNotViewValid() throws {
    let exp = expectation(description: "Call back position")
    prepareTestGetViewForAction(withPoint: CGPoint(x: 500, y: 2000))
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 2)
    XCTAssertFalse(actionView.isCooldown, "View foi ativada em uma action não válida")
  }

  // MARK: - Verify Actions Test

  func testVerifyActionEyeRightActionSuccess() throws {
    actionView.setTypeStartAction(withType: .eyeRight)

    XCTAssertTrue(actionView.verifyAction(withValueEyeRight: 0.6, theEyeLeft: 0.4, andTongueValue: 0.1), "A Action deveria ser acionada para Olho Direito")
  }

  func testVerifyActionEyeRightActionError() throws {
    actionView.setTypeStartAction(withType: .eyeRight)

    XCTAssertFalse(actionView.verifyAction(withValueEyeRight: 0.4, theEyeLeft: 0.4, andTongueValue: 0.1), "A Action não deveria ser acionada para Olho Esquerdo")
  }

  func testVerifyActionEyeLeftActionSuccess() throws {
    actionView.setTypeStartAction(withType: .eyeLeft)

    XCTAssertTrue(actionView.verifyAction(withValueEyeRight: 0.4, theEyeLeft: 0.6, andTongueValue: 0.1), "A Action deveria ser acionada para Olho Esquerdo")
  }

  func testVerifyActionEyeLeftActionError() throws {
    actionView.setTypeStartAction(withType: .eyeLeft)

    XCTAssertFalse(actionView.verifyAction(withValueEyeRight: 0.4, theEyeLeft: 0.4, andTongueValue: 0.1), "A Action não deveria ser acionada para Olho Esquerdo")
  }

  func testVerifyActionTongueActionSuccess() throws {
    actionView.setTypeStartAction(withType: .eyeLeft)

    XCTAssertTrue(actionView.verifyAction(withValueEyeRight: 0.4, theEyeLeft: 0.6, andTongueValue: 0.3), "A Action deveria ser acionada para Língua")
  }

  func testVerifyActionTongueActionError() throws {
    actionView.setTypeStartAction(withType: .tongue)

    XCTAssertFalse(actionView.verifyAction(withValueEyeRight: 0.4, theEyeLeft: 0.4, andTongueValue: 0.1), "A Action não deveria ser acionada para Língua")
  }

  func testVerifyActionVoice() throws {
    actionView.setTypeStartAction(withType: .voice)

    XCTAssertFalse(actionView.verifyAction(withValueEyeRight: 0.4, theEyeLeft: 0.4, andTongueValue: 0.1), "A Action não deveria ser acionada para voz")
  }

  // MARK: - Types Return

  func testVerifySpecialTargetButton() throws {
    let exp = expectation(description: "Call back position")
    prepareTestGetViewForAction(withPoint: CGPoint(x: 500, y: 2000))
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 2)
    XCTAssertEqual(mockViewControllerSut.mockButton.accessibilityIdentifier, AccessibilityUIType.uiButton.identifier)
  }

  func testVerifySpecialTargetUIImageView() throws {
    let exp = expectation(description: "Call back position")
    prepareTestGetViewForAction(withPoint: CGPoint(x: 4, y: 802))
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 2)
    XCTAssertEqual(mockViewControllerSut.mockUiimageViews.accessibilityIdentifier, AccessibilityUIType.uiImageView.identifier)
  }

  func testVerifySpecialTargetTableView() throws {
    let exp = expectation(description: "Call back position")
    prepareTestGetViewForAction(withPoint: CGPoint(x: 4, y: 1002))
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 2)
    XCTAssertEqual(mockViewControllerSut.mockUITableView.accessibilityIdentifier, AccessibilityUIType.uiTableView.identifier)
  }

  func testVerifySpecialTargetCollectionView() throws {
    let exp = expectation(description: "Call back position")
    prepareTestGetViewForAction(withPoint: CGPoint(x: 4, y: 1202))
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 2)
    XCTAssertEqual(mockViewControllerSut.mockUICollectionView.accessibilityIdentifier, AccessibilityUIType.uiCollectionView.identifier)
  }

  // MARK: - Types Return Selector

  func testVerifySpecialTargetUITabBar() throws {
    let exp = expectation(description: "Call back position")
    prepareTestGetViewForAction(withPoint: CGPoint(x: 0, y: 20))
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 4)
    XCTAssertEqual(mockViewControllerSut.selectedIndex, 0)
  }
}

