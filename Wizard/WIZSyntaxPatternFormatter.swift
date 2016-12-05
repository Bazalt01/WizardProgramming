//
//  WIZSyntaxPatternFormatter.swift
//  Wizard
//
//  Created by Глеб Токмаков on 02.12.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

//--------------------------------------------------------------------------------------------------
// MARK: - WIZSyntaxPatternFormatter Implementation

class WIZSyntaxPatternFormatter {
  
  
  //................................................................................................
  // MARK: - Private Properties
  
  var spesialWords : [(word: String, color: NSColor)]
  
  
  //................................................................................................
  // MARK: - Inits
  
  init(spesialWords: [(word: String, color: NSColor)]) {
    
    self.spesialWords = spesialWords
  }
  
  //................................................................................................
  // MARK: - Public Methods
  
  func formatterStringToReadableCode (string: String) -> NSAttributedString {
  
    var result = NSAttributedString (string: string)
    
//    for spesialWord in spesialWords {
//      
//      let lenght = string.characters.count
//      
//      let range = string.range(of: spesialWord.word)
//      
//      print(range)
//    }
    
    
    result = findAndSetStringValue (code: result)
    
    result = findAndSetComments (code: result)
    
    return result
  }
  
  func findAndSetComments (code: NSAttributedString) -> NSAttributedString {
    
    let result = NSMutableAttributedString (attributedString: code)
    
    let string = result.string as NSString
    
    var location = 0
    
    var range = findRange(forStringBetween: string, startString: "/*", endString: "*/")
    
    let commentColor = NSColor.init(hue: 0.3, saturation: 0.8, brightness: 0.7, alpha: 1.0)
    
    
    while let foundRange = range {
      
      let resultRange = NSMakeRange(location + foundRange.location, foundRange.length)
      
      result.setAttributes([NSForegroundColorAttributeName : commentColor], range: resultRange)
      
      location += foundRange.length + foundRange.location
      
      let lenght = result.length - location
      
      let subrange = NSMakeRange(location, lenght)
      
      let substring = string.substring(with: subrange) as NSString
      
      range = findRange(forStringBetween: substring, startString: "/*", endString: "*/")
    }
    
    return result
  }
  
  func findAndSetStringValue (code: NSAttributedString) -> NSAttributedString {
    
    let result = NSMutableAttributedString (attributedString: code)
    
    let string = result.string as NSString
    
    var location = 0
    
    var range = findRange(forStringBetween: string, startString: "\"", endString: "\"")
    
    let commentColor = NSColor.init(hue: 0.0, saturation: 0.8, brightness: 0.7, alpha: 1.0)
    
    
    while let foundRange = range {
      
      let resultRange = NSMakeRange(location + foundRange.location, foundRange.length)
      
      result.setAttributes([NSForegroundColorAttributeName : commentColor], range: resultRange)
      
      location += foundRange.length + foundRange.location
      
      let lenght = result.length - location
      
      let subrange = NSMakeRange(location, lenght)
      
      let substring = string.substring(with: subrange) as NSString
      
      range = findRange(forStringBetween: substring, startString: "\"", endString: "\"")
    }
    
    return result
  }
  
  func findRange (forStringBetween string: NSString, startString: String, endString: String) -> NSRange? {
    
    var checkString = string.copy() as! NSString
    
    let startPartRange = checkString.range(of: startString)
    
    if startPartRange.length == 0 {
      
      return nil
    }
    
    let nextLocation = startPartRange.location + startPartRange.length
    
    checkString = checkString.substring(from: nextLocation) as NSString
    
    let endPartRange = checkString.range(of: endString)
    
    if endPartRange.length == 0 {
    
      return nil
    }
    
    return NSMakeRange(startPartRange.location, endPartRange.location + endPartRange.length + startPartRange.length)
  }
}
