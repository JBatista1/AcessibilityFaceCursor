//
//  VoiceActionProtocol.swift
//  AcessibilityFaceMouse
//
//  Created by Joao Batista on 06/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import Foundation
public protocol VoiceActionProtocol: AnyObject {
  var delegateResponseCommand: VoiceActionCommandProtocol? { get set}
  var delegate: VoiceActionResponseProtocol? { get set}
  
  func start()
  func set(locale: Locale)
  func set(TheActionWord actionVoiceCommands: ActionVoiceCommands)
  func stop()
  func checkPermissions()
  func initialRecording()
}
