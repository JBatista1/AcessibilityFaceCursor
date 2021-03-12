//
//  VoiceActionTest.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 09/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import XCTest
import UIKit
import Speech
@testable import AcessibilityFaceMouse

class VoiceActionTest: XCTestCase {

  var voiceAction: VoiceAction!
  var delegateVoiceSpy = MockVoiceActionSpy()

  override func setUpWithError() throws {
    voiceAction = VoiceAction()
    voiceAction.delegate = delegateVoiceSpy
    voiceAction.delegateResponseCommand = delegateVoiceSpy
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  // MARK: - Update Values Test

  func testVerifyDefaultLocation() throws {
    let defaultValue = voiceAction.speechReconizer?.locale.identifier
    XCTAssertEqual(defaultValue , "pt-BR")
  }

  func testUpdateLocation() throws {
    voiceAction.set(locale: Locale(identifier: "en-CA"))
    let defaultValue = voiceAction.speechReconizer?.locale.identifier
    XCTAssertEqual(defaultValue , "en-CA")
  }

  func testVerifyDefaultActionVoiceCommands() throws {
    let defaultValue = voiceAction.actionVoiceCommands
    XCTAssertEqual(defaultValue, ActionVoiceCommands.getDefault())
  }

  func testUpdateActionVoiceCommands() throws {
    let actionCommand = ActionVoiceCommands(action: "ok", backNavigation: "back", scrollNext: "next", scrollBack: "back")
    voiceAction.set(TheActionWord: actionCommand)
    let defaultValue = voiceAction.actionVoiceCommands
    XCTAssertEqual(actionCommand ,defaultValue)
  }

  // MARK: - Audio test

  func testCheckPermissions() throws {
    let exp = expectation(description: "Call back position")
    voiceAction.checkPermissions()
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
      exp.fulfill()
    })
    waitForExpectations(timeout: 3)
    XCTAssertTrue(delegateVoiceSpy.errorPermissionSpy)
  }
// Esses testes não passam no Travis CI
//  func testInitialAudioEngine() throws {
//    voiceAction.initialRecording()
//    XCTAssertTrue(voiceAction.audioEngine.isRunning, "audioEngine não foi criado")
//  }

//  func testInitialAudioEngineGenericError() throws {
//    let exp = expectation(description: "Call back position")
//    voiceAction.initialRecording()
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//      exp.fulfill()
//    })
//    waitForExpectations(timeout: 3)
//    XCTAssertTrue(delegateVoiceSpy.errorGenericSpy, "Error gerado quando a resposta e vazia ou não autorizado")
//  }

//  func testStopAudioEngine() throws {
//    let exp = expectation(description: "Call back position")
//    voiceAction.initialRecording()
//    voiceAction.stop()
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//      exp.fulfill()
//    })
//    waitForExpectations(timeout: 3)
//    XCTAssertFalse(voiceAction.audioEngine.isRunning, "audioEngine não foi parado")
//  }
//
//  func testStartAudioEngine() throws {
//    let exp = expectation(description: "Call back position")
//    voiceAction.initialRecording()
//    voiceAction.stop()
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//      self.voiceAction.start()
//      exp.fulfill()
//    })
//    waitForExpectations(timeout: 3)
//    XCTAssertTrue(voiceAction.audioEngine.isRunning, "audioEngine deveria ter iniciado")
//  }
  
  func testStartAudioEngineNotStart() throws {
    let exp = expectation(description: "Call back position")
    self.voiceAction.start()
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {

      exp.fulfill()
    })
    waitForExpectations(timeout: 3)
    XCTAssertFalse(voiceAction.audioEngine.isRunning, "audioEngine deveria ter iniciado")
  }
}
