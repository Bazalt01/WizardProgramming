//
//  WIZSpecialWords.swift
//  Wizard
//
//  Created by Глеб Токмаков on 06.12.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

class WIZSpecialWords {

  static let sharedInstance: WIZSpecialWords = {
    
    let instance = WIZSpecialWords()
    
    return instance
  }()
  
  
  //................................................................................................
  // MARK: - Public Properties
  
  private(set) var specialWords = Dictionary<String, NSColor>()
  
  
  //................................................................................................
  // MARK: - Inits
  
  init () {
    
    readSpecialWords()
  }
  
  func readSpecialWords () {
    
    guard let containingURL = Bundle.main.resourceURL else {
      
      return
    }
    
    var baseClasses : String?
    var otherFunctions : String?
    var macros : String?
    var keywords : String?
    var otherConstants : String?
    var otherTypeNames : String?
    
    do {
      baseClasses = try String(contentsOf: containingURL.appendingPathComponent("baseClasses.txt"))
    }
    catch {
      return
    }
    
    do {
      otherFunctions = try String(contentsOf: containingURL.appendingPathComponent("otherFunctions.txt"))
    }
    catch {
      return
    }
    
    do {
      macros = try String(contentsOf: containingURL.appendingPathComponent("macros.txt"))
    }
    catch {
      return
    }
    
    do {
      keywords = try String(contentsOf: containingURL.appendingPathComponent("keywords.txt"))
    }
    catch {
      return
    }
    
    do {
      otherConstants = try String(contentsOf: containingURL.appendingPathComponent("otherConstants.txt"))
    }
    catch {
      return
    }
    
    do {
      otherTypeNames = try String(contentsOf: containingURL.appendingPathComponent("otherTypeNames.txt"))
    }
    catch {
      return
    }
    
    baseClasses    = baseClasses!.replacingOccurrences(of: "\n", with: "");
    otherFunctions = otherFunctions!.replacingOccurrences(of: "\n", with: "");
    macros         = macros!.replacingOccurrences(of: "\n", with: "");
    keywords       = keywords!.replacingOccurrences(of: "\n", with: "");
    otherConstants = otherConstants!.replacingOccurrences(of: "\n", with: "");
    otherTypeNames = otherTypeNames!.replacingOccurrences(of: "\n", with: "");
    
    
    guard let baseClassesArray = baseClasses?.components(separatedBy: ",") else {
      
      return
    }
    
    guard let otherFunctionsArray = otherFunctions?.components(separatedBy: ",") else {
      
      return
    }
    
    guard let macrosArray = macros?.components(separatedBy: ",") else {
      
      return
    }
    
    guard let keywordsArray = keywords?.components(separatedBy: ",") else {
      
      return
    }
    
    guard let otherConstantsArray = otherConstants?.components(separatedBy: ",") else {
      
      return
    }
    
    guard let otherTypeNamesArray = otherTypeNames?.components(separatedBy: ",") else {
      
      return
    }
    
    
    for word in baseClassesArray {
      
      specialWords[word] = systemClassColor()
    }
    
    for word in otherFunctionsArray {
      
      specialWords[word] = otherFunctionsColor()
    }
    
    for word in macrosArray {
      
      specialWords[word] = macroColor()
    }
    
    for word in keywordsArray {
      
      specialWords[word] = keywordsColor()
    }
    
    for word in otherConstantsArray {
      
      specialWords[word] = otherFunctionsColor()
    }
    
    for word in otherTypeNamesArray {
      
      specialWords[word] = systemClassColor()
    }
  }
  
  func addSpecialWords (words: [String], color: NSColor) {
  
    for word in words {
      
      if specialWords[word] == nil {
      
        specialWords[word] = color
      }
    }
  }
}
