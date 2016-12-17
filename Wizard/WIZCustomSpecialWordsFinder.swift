//
//  WIZCustomSpecialWordsFinder.swift
//  Wizard
//
//  Created by Глеб Токмаков on 09.12.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa


enum LanguageType : String {

  case ObjectiveC
}


//--------------------------------------------------------------------------------------------------
// MARK: - WIZCustomSpecialWordsFinderProtocol Definition

protocol WIZCustomSpecialWordsFinderProtocol {
  
  func findCustomClasses (url: URL) -> [String]
  
  func findWithKeywords (keyword: String, code: NSString) -> [String]
  
//  func findParameters (string: NSString) -> [(range: NSRange, color: NSColor)]
}


//--------------------------------------------------------------------------------------------------
// MARK: - WIZCustomSpecialWordsFinder Abstract Class

class WIZCustomSpecialWordsFinder: WIZCustomSpecialWordsFinderProtocol {
  
  func findCustomClasses (url: URL) -> [String] {
  
    preconditionFailure("This method must be overridden")
  }
  
  func findWithKeywords (keyword: String, code: NSString) -> [String] {
  
    preconditionFailure("This method must be overridden")
  }
  
  func findParameters (string: NSString) -> [(range: NSRange, color: NSColor)] {
  
    preconditionFailure("This method must be overridden")
  }
}


//--------------------------------------------------------------------------------------------------
// MARK: - WIZLanguageFinderAssembly Implementation

class WIZLanguageFinderAssembly {
  
  class func createFinder (forLanguage languageType: LanguageType) -> WIZCustomSpecialWordsFinder {
  
    switch languageType {
      
    case .ObjectiveC:
      
      return WIZCustomSpecialWordsFinderObjectiveC()
      
    default:
      
      return WIZCustomSpecialWordsFinder()
    }
  }
}
