//
//  ActionVoiceCommandsTests.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 11/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import XCTest
import UIKit
@testable import AcessibilityFaceMouse

class ActionVoiceCommandsTests: XCTestCase {



  // MARK: - FaceSensitivity test

  func testGetDefault() throws {
    let actionVoiceCommands = ActionVoiceCommands.getDefault()
    XCTAssertEqual(actionVoiceCommands.action, ValuesConstants.actionTap, "O valor deveria ser igual ao default")
    XCTAssertEqual(actionVoiceCommands.backNavigation, ValuesConstants.actionBack,"O valor deveria ser igual ao default")
    XCTAssertEqual(actionVoiceCommands.scrollNext, ValuesConstants.actionScrollNext,"O valor deveria ser igual ao default")
    XCTAssertEqual(actionVoiceCommands.scrollBack, ValuesConstants.actionScrollBack,"O valor deveria ser igual ao default")
  }

  func testGetCommandsStringDefault() throws {
    let action = "GO"
    let backNavigation = "BACK"
    let scrollNext = "NEXT"
    let scrollBack = "BACK"
    let arrayTest = [action.lowercased(),
                     backNavigation.lowercased(),
                     scrollNext.lowercased(),
                     scrollBack.lowercased()]

    let actionVoiceCommands = ActionVoiceCommands(action:action, backNavigation: backNavigation, scrollNext: scrollNext, scrollBack: scrollBack)

    XCTAssertEqual(actionVoiceCommands.getCommandsString(), arrayTest, "Os textos deveriam vir em letra minuscula")
  }

  func testGetCommandoEnum() throws {
    let actionVoiceCommands = ActionVoiceCommands.getDefault()

    XCTAssertEqual(actionVoiceCommands.getCommandoEnum(withText: ValuesConstants.actionTap), VoiceCommand.action, "Os cases deveriam ser iguais")
    XCTAssertEqual(actionVoiceCommands.getCommandoEnum(withText: ValuesConstants.actionBack), VoiceCommand.backNavigation, "Os cases deveriam ser iguais")
    XCTAssertEqual(actionVoiceCommands.getCommandoEnum(withText: ValuesConstants.actionScrollNext), VoiceCommand.scrollNext, "Os cases deveriam ser iguais")
    XCTAssertEqual(actionVoiceCommands.getCommandoEnum(withText: ValuesConstants.actionScrollBack), VoiceCommand.scrollBack, "Os cases deveriam ser iguais")
  }

}
