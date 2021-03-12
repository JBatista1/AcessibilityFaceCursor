//
//  VoiceActionResponseProtocol.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 02/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import Speech

public protocol VoiceActionResponseProtocol: AnyObject {
  func permissionGranted()
  func errorPermission(status: SFSpeechRecognizerAuthorizationStatus)
  func errorGeneric()
}
