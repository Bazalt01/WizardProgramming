//
//  WIZCustomSpecialWordsFinder.swift
//  Wizard
//
//  Created by Глеб Токмаков on 09.12.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

class WIZCustomSpecialWordsFinder {
  
  func findCustomClasses (url: URL) -> [String] {
    
    var code = ""
    
    do {
    
      code = try String.init(contentsOf: url)
    }
    catch {
      
      return []
    }
    
    code = code.replacingOccurrences(of: "(", with: " ")
    code = code.replacingOccurrences(of: ")", with: " ")
    code = code.replacingOccurrences(of: "<", with: " ")
    code = code.replacingOccurrences(of: ">", with: " ")
    code = code.replacingOccurrences(of: ":", with: " ")
    
    var result = Array<String>()
    
    result.append(contentsOf: findWithKeywords(keyword: "@interface", code: code as NSString))
    
    result.append(contentsOf: findWithKeywords(keyword: "@protocol", code: code as NSString))
    
    return result
  }
  
  func findWithKeywords (keyword: String, code: NSString) -> [String] {
    
    var resultArray = Array<String>()
    
    var checkCode = code
    
    var range = checkCode.range(of: keyword)
  
    
    while range.length > 0 {
    
      let location = range.location + range.length
      
      if location > checkCode.length
      {
        return resultArray
      }
      
      checkCode = checkCode.substring(from: location) as NSString
      
      var startLocation = -1
      
      for index in 0..<checkCode.length {
        
        let symbolRange = NSMakeRange(index, 1)
        
        let symbol = checkCode.substring(with: symbolRange)
        
        if symbol != " " && startLocation < 0 {
        
          startLocation = index
        }
        else if symbol == " " && startLocation >= 0 {
        
          let resultRange = NSMakeRange(startLocation, index - startLocation)
          
          let result = checkCode.substring(with: resultRange)
          
          resultArray.append(result)
          
          checkCode = checkCode.substring(from: resultRange.location + resultRange.length) as NSString
          
          range = checkCode.range(of: keyword)
          
          break
        }
      }
    }
    
    return resultArray
  }
}
