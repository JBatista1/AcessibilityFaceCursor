//
//  MockVoiceActionSpy.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 09/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

@testable import AcessibilityFaceMouse
import Speech

class MockVoiceActionSpy: VoiceActionCommandProtocol, VoiceActionResponseProtocol {
  var commandDetectedSpy: Bool = false
  var permissionGrantedSpy: Bool = false
  var errorPermissionSpy: Bool = false
  var errorGenericSpy: Bool = false

  init() {}
  func commandDetected(withCommand command: VoiceCommand) {
    commandDetectedSpy = true
  }

  func permissionGranted() {
    permissionGrantedSpy = true
  }

  func errorPermission(status: SFSpeechRecognizerAuthorizationStatus) {
    errorPermissionSpy = true
  }

  func errorGeneric() {
    errorGenericSpy = true
  }
}
