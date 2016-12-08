//
//  WIZSyntaxPatternFormatter.swift
//  Wizard
//
//  Created by Глеб Токмаков on 02.12.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

typealias Couple = (first: String, second: String, color: NSColor)


//--------------------------------------------------------------------------------------------------
// MARK: - WIZSyntaxPatternFormatter Implementation

class WIZSyntaxPatternFormatter {
  
  
  //................................................................................................
  // MARK: - Private Properties

  var allUsedRanges = [NSRange]()
  
  
  //................................................................................................
  // MARK: - Public Methods
  
  func formatterStringToReadableCode (string: String) -> NSAttributedString {
  
    var result = NSAttributedString (string: string)
    
    let coupleList = [(first: "/*",            second: "*/", color: commentColor()),
                      (first: "//",            second: "\n", color: commentColor()),
                      (first: "@\"",           second: "\"", color: stringColor()),
                      (first: "\"",            second: "\"", color: stringColor()),
                      (first: "#import <",     second: ">",  color: macroColor()),
                      (first: "#pragma mark",  second: "\n", color: macroColor()),
                      (first: "#if",           second: "\n", color: macroColor()),
                      (first: "#endif",        second: "\n", color: macroColor()),
                      (first: "\'",            second: "\'", color: numberColor())]

    
    result = findAndSetColor(forCode: result, coupleList: coupleList)
    
    
    result = findSpecialWords(forCode: result)
    
    let font = NSFont.systemFont(ofSize: 13.0)
    
    let resultMutable = NSMutableAttributedString(attributedString: result)
    
    resultMutable.addAttributes([NSFontAttributeName : font], range: NSMakeRange(0, result.string.characters.count))
    
    return resultMutable
  }
  
  func findSpecialWords(forCode code: NSAttributedString) -> NSAttributedString {
    
    let clearResult = clearFromSpecialSymbols (forCode: code)
    
    let result = NSMutableAttributedString (attributedString: code)
    
    let code = clearResult.string as NSString
    
    let count = code.length
    
  
    var startLocation = -1
    
    var isNumber = false;
    
    for index in 0..<count {
      
      let range = NSMakeRange(index, 1)
      
      if !checkRange(checkRange: range) {
      
        let substring = code.substring(with: range)
      
        
        if checkIsNumber(string: substring, range: range, code: code) && startLocation < 0 {
        
          startLocation = index
          
          isNumber = true
        }
        
        else if substring != " " && startLocation < 0 {
        
          startLocation = index
        }
        
        else if substring == " " && startLocation >= 0 {
          
          let checkRange = NSMakeRange(startLocation, index - startLocation)
          
          startLocation = -1
          
          if isNumber {
            
            isNumber = false
            
            result.setAttributes([NSForegroundColorAttributeName : numberColor()], range: checkRange)
          }
          else {
          
            let checkString = code.substring(with: checkRange)
            
            guard let color = WIZSpecialWords.sharedInstance.specialWords[checkString] else {

              continue
            }
            
            result.setAttributes([NSForegroundColorAttributeName : color], range: checkRange)
          }
        }
      }
    }
    
    return result
  }
  
  func clearFromSpecialSymbols (forCode code: NSAttributedString) -> NSAttributedString {
    
    let result = NSMutableAttributedString (attributedString: code)
    
    var code = result.string
    
    let specialSymbols = [":", "/", "\\", "\'", "\"", ";", "[", "]", "{", "}", "|", "*", "(", ")", "&", "^", "%", "$", "!", "=", "-", "+", "?", "<", ">", ",", "\n", "\t"]
    
    for symbol in specialSymbols {
      
      code = code.replacingOccurrences(of: symbol, with: " ")
    }
    
    return NSAttributedString(string: code)
  }
  
  func findAndSetColor (forCode code: NSAttributedString, coupleList: [Couple]) -> NSAttributedString {
    
    let result = NSMutableAttributedString (attributedString: code)
    
    let string = result.string as NSString
    
    var location = 0
    
    var rangeAndColor = findRange(forStringBetween: string, coupleList: coupleList)
    
    
    while let foundRangeAndColor = rangeAndColor {
      
      let resultRange = NSMakeRange(location + foundRangeAndColor.range.location, foundRangeAndColor.range.length)
      
      if !checkRange(checkRange: resultRange) {
      
        result.setAttributes([NSForegroundColorAttributeName : foundRangeAndColor.color], range: resultRange)
        
        allUsedRanges.append(resultRange)
      }
      
      location += foundRangeAndColor.range.length + foundRangeAndColor.range.location
      
      let lenght = result.length - location
      
      let subrange = NSMakeRange(location, lenght)
      
      let substring = string.substring(with: subrange) as NSString
      
      
      rangeAndColor = findRange(forStringBetween: substring, coupleList: coupleList)
    }
    
    return result
  }
  
  func findRange (forStringBetween string: NSString, coupleList: [Couple]) -> (range: NSRange, color: NSColor)? {
    
    var checkString = string.copy() as! NSString
    
    
    var startPartRange : NSRange?
    
    var minLocation = Int.max
    
    var actualSymbol : String?
    
    var color : NSColor?
    
    
    for couple in coupleList {
    
      let range = checkString.range(of: couple.first)
      
      if range.length != 0 && minLocation > range.location {
      
        minLocation = range.location
        
        actualSymbol = couple.second
        
        color = couple.color
        
        startPartRange = range
      }
    }
    
    if startPartRange == nil || startPartRange!.length == 0 {
      
      return nil
    }
    
    let nextLocation = startPartRange!.location + startPartRange!.length
    
    checkString = checkString.substring(from: nextLocation) as NSString
    
    let endPartRange = checkString.range(of: actualSymbol!)
    
    if endPartRange.length == 0 {
    
      return nil
    }
    
    let range = NSMakeRange(startPartRange!.location, endPartRange.location + endPartRange.length + startPartRange!.length)
    
    return (range: range, color: color!)
  }
  
  func checkRange(checkRange: NSRange) -> Bool {
    
    for range in allUsedRanges {
      
      if NSLocationInRange(checkRange.location, range) {
        
        return true
      }
    }
    
    return false
  }
  
  
  
  func checkIsNumber (string: String, range: NSRange, code: NSString) -> Bool {
  
    if Int(string) != nil {
    
      return true
    }
    
    if string != "@" {
    
      return false
    }
    
    let nextRange = NSMakeRange(range.location + 1, 1)
    
    let substring = code.substring(with: nextRange)
    
    if Int(substring) != nil {
    
      return true
    }
    
    return false
  }
}
