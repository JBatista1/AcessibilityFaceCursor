//
//  ActionVoiceCommands.swift
//  AcessibilityFaceMouse
//
//  Created by Joao Batista on 03/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import Foundation

public struct ActionVoiceCommands: Equatable {

  var action: String
  var backNavigation: String
  var scrollNext: String
  var scrollBack: String

  public init(action: String, backNavigation: String, scrollNext: String, scrollBack: String) {
    self.action = action
    self.backNavigation = backNavigation
    self.scrollNext = scrollNext
    self.scrollBack = scrollBack
  }


  internal static func getDefault() -> ActionVoiceCommands {
    return ActionVoiceCommands(action: ValuesConstants.actionTap, backNavigation: ValuesConstants.actionBack, scrollNext: ValuesConstants.actionScrollNext, scrollBack: ValuesConstants.actionScrollBack)
  }
  
  internal func getCommandsString() -> [String] {
    return [action.lowercased(), backNavigation.lowercased(), scrollNext.lowercased(), scrollBack.lowercased()]
  }

  internal func getCommandoEnum(withText text: String) -> VoiceCommand {
    switch text.lowercased() {
    case action.lowercased():
      return .action
    case backNavigation.lowercased():
      return .backNavigation
    case scrollNext.lowercased():
      return .scrollNext
    case scrollBack.lowercased():
      return .scrollBack
    default:
      return .unknown
    }
  }
}
