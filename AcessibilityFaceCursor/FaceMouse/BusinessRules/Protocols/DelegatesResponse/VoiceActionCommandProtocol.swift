//
//  VoiceActionCommandProtocol.swift
//  AcessibilityFaceMouse
//
//  Created by Joao Batista on 06/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//


public protocol VoiceActionCommandProtocol: AnyObject {
  func commandDetected(withCommand command: VoiceCommand)
}
