//
//  WIZCustomSpecialWordsFinderObjectiveC.swift
//  Wizard
//
//  Created by Глеб Токмаков on 10.12.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa


//--------------------------------------------------------------------------------------------------
// MARK: - WIZCustomSpecialWordsFinderObjectiveC

class WIZCustomSpecialWordsFinderObjectiveC: WIZCustomSpecialWordsFinder {

  override func findCustomClasses (url: URL) -> [String] {
    
    var code = ""
    
    do {
      
      code = try String.init(contentsOf: url)
    }
    catch {
      
      return []
    }
    
    let isInternal = url.pathExtension == "m"
    
    var result = Array<String>()
    var interfaces = Array<WIZObjectiveCClassModel>()
    
    let interfacesCode = getAllInterfacesCode(code: code as NSString)
    
    for interfaceCode in interfacesCode {
      
      if let interface = analyzeInterface(code: interfaceCode) {
    
        interface.isInternal = isInternal
        
        result.append(interface.parentClass)
        
        if let protocols = interface.protocols {
          
          result.append(contentsOf: protocols)
        }
        
        interfaces.append(interface)
      }
    }
    
    return result
  }
  
  override func findWithKeywords (keyword: String, code: NSString) -> [String] {
    
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
//  
//  override func findParameters (string: NSString) -> [(range: NSRange, color: NSColor)] {
//    
//    var code = string
//    
//    let specialSymbols = [":", "/", "\\", "\'", "\"", ";", "[", "]", "{", "}", "|", "*", "(", ")", "&", "^", "%", "$", "!", "=", "-", "+", "?", "<", ">", ",", "\n", "\t"]
//    
//    for symbol in specialSymbols {
//      
//      code = code.replacingOccurrences(of: symbol, with: " ") as NSString
//    }
//    
//    return [(range: NSRange(), color: NSColor())]
//  }
  
  
  //................................................................................................
  // MARK: - Internal Methods
  
  func getAllInterfacesCode (code: NSString) -> [NSString] {
    
    var result = Array<NSString>()
    
    var checkCode = code
    checkCode = checkCode.replacingOccurrences(of: ":", with: " ") as NSString
    
    var range = checkCode.range(of: "@interface")
    
    while range.length > 0 {
      
      checkCode = checkCode.substring(from: range.location + range.length) as NSString
      
      let endRange = checkCode.range(of: "@end")
      
      if endRange.length > 0 {
      
        let foundCode = checkCode.substring(with: NSMakeRange(0, endRange.location))
        
        result.append(foundCode as NSString)
        
        checkCode = checkCode.substring(from: endRange.length + endRange.location) as NSString
        
        range =  checkCode.range(of: "@interface")
      }
      
      else { return result}
    }
    
    return result
  }
  
  func analyzeInterface (code: NSString) -> WIZObjectiveCClassModel? {
    
    guard let className = findClassName(code: code) else {
    
      return nil
    }
    
    let protocols = findProtocols(code: code)
    
    let parameters = findParameters(code: code)
    
    return WIZObjectiveCClassModel(parameters: parameters, parentClass: className, protocols: protocols)
  }
  
  func findClassName (code: NSString) -> String? {
    
    let count = code.length
    
    var startLocation : Int?
    
    for index in 0..<count {
      
      let symbol = code.substring(with: NSMakeRange(index, 1))
      
      if symbol != " " && startLocation == nil {
        
        startLocation = index
      }
      else if symbol == " " && startLocation != nil {
      
        return code.substring(with: NSMakeRange(startLocation!, index - startLocation!))
      }
    }
    
    return nil
  }
  
  func findProtocols(code: NSString) -> [String]? {
    
    let limitLocationOfProtocolRange = code.range(of: "@")
    
    if limitLocationOfProtocolRange.length == 0 {
    
      return nil
    }
    
    var checkCode = code.substring(to: limitLocationOfProtocolRange.location) as NSString
    
    let beginRange = checkCode.range(of: "<")
    let endRange = checkCode.range(of: ">")
    
    if beginRange.length == 0 || endRange.length == 0 {
      
      return nil
    }
    
    let location = beginRange.location + beginRange.length
    let length = endRange.location - location
    
    checkCode = checkCode.substring(with: NSMakeRange(location, length)) as NSString
    
    let uncorrectSymbol = ["\n", "\t", " "]
    
    for symbol in uncorrectSymbol {
      
      checkCode = checkCode.replacingOccurrences(of: symbol, with: "") as NSString
    }
    
    return checkCode.components(separatedBy: ",")
  }
  
  func findParameters (code: NSString) -> [WIZParametersModel] {
    
    var parametersCode = Array<WIZParametersModel>()
    
    var checkCode = code
    
    var propertyKeyRange = checkCode.range(of: "@property")
    
    
    while propertyKeyRange.length > 0 {
      
      let beginPropertyKeysRange = checkCode.range(of: "(")
      let endPropertyKeysRange = checkCode.range(of: ")")
      
      var internals = Array<String>()
      
      if beginPropertyKeysRange.length > 0 && endPropertyKeysRange.length > 0 {
        
        let location = beginPropertyKeysRange.length + beginPropertyKeysRange.location
        let length = endPropertyKeysRange.location - location
        
        let internalsCode = checkCode.substring(with: NSMakeRange(location, length))
        
        internals = findInternals(fromCode: internalsCode as NSString)
        
        checkCode = checkCode.substring(from: endPropertyKeysRange.location + endPropertyKeysRange.length) as NSString
      }
        
      else {
        
        checkCode = checkCode.substring(from: propertyKeyRange.location + propertyKeyRange.length) as NSString
      }
      
      
      let endPropertyRange = checkCode.range(of: ";")
      
      let foundCode = checkCode.substring(with: NSMakeRange(0, endPropertyRange.location))
      
      
      if let parameterClassAndName = findParameterWithClassAndName(fromCode: foundCode as NSString) {
        
        let parameter = WIZParametersModel(name: parameterClassAndName.name, type: parameterClassAndName.type, internals: internals)
        
        parametersCode.append(parameter)
      }
    

      checkCode = checkCode.substring(from: endPropertyRange.length + endPropertyRange.location) as NSString
      
      propertyKeyRange = checkCode.range(of: "@property")
    }
    
    return parametersCode
  }
  
  func findInternals(fromCode code: NSString) -> [String] {
    
    var checkCode = code
    
    let uncorrectSymbol = ["\n", "\t", " "]
    
    for symbol in uncorrectSymbol {
      
      checkCode = checkCode.replacingOccurrences(of: symbol, with: "") as NSString
    }
    
    return checkCode.components(separatedBy: ",")
  }
  
  func findParameterWithClassAndName (fromCode code: NSString) -> (name: String, type: String)? {
    
    var checkCode = code
    
    checkCode = checkCode.replacingOccurrences(of: "*", with: " ") as NSString
    
    let count = checkCode.length
    
    
    var propertyClassName : String?
    
    var propertyName : String?
    
    
    var startSymbolLocation : Int?
    
    
    for index in 0..<count {
      
      let symbolRange = NSMakeRange(index, 1)
      let symbol = checkCode.substring(with: symbolRange)
      
      var foundWord : String?
      
      if symbol != " " && startSymbolLocation == nil {
      
        startSymbolLocation = index
      }
      else if symbol == " " && startSymbolLocation != nil {
      
        foundWord = checkCode.substring(with: NSMakeRange(startSymbolLocation!, index - startSymbolLocation!))
      }
      else if index == count - 1 && startSymbolLocation != nil {
        
        foundWord = checkCode.substring(from: startSymbolLocation!)
      }
      
      guard let word = foundWord else {
        
        continue
      }
      
      startSymbolLocation = nil
      
      if propertyClassName == nil {
        
        propertyClassName = word
      }
      else if propertyName == nil {
      
        propertyName = word
        
        break
      }
    }
    
    guard let className = propertyClassName, let name = propertyName else {
      
      return nil
    }
    
    return (name: name, type: className)
  }
}
