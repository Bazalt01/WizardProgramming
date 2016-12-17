//
//  WIZProjectHierarchyFile.swift
//  Wizard
//
//  Created by Глеб Токмаков on 02.12.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa


//--------------------------------------------------------------------------------------------------
// MARK: - WIZProjectHierarchyFile Implementation

class WIZProjectHierarchyFile: WIZProjectHierarchyModel {

  
  //................................................................................................
  // MARK: - Public Read-only Properties
  
  public private(set) var content : String?
  
  public private(set) var formatterCode : NSAttributedString?
  
  public private(set) var classes : [WIZAbstractClassModel]?
  
  
  //................................................................................................
  // MARK: - Public Methods
  
  func updateContent () {
    
    do {
      let string = try String(contentsOf: url, encoding: String.Encoding.utf8)
      
      content = string      
      
      let formatter = WIZSyntaxPatternFormatter()
      
      formatterCode = formatter.formatterStringToReadableCode(string: string)
    }
    catch {
      print("File \(url.description) isn't read")
    }
  }
}


//--------------------------------------------------------------------------------------------------
// MARK: - WIZParametersModel

class WIZParametersModel {
  
  var name : String
  
  var type : String
  
  var internals: [String]

  
  //................................................................................................
  // MARK: - Inits
  
  init(name: String, type: String, internals: [String]) {
    
    self.name = name
    
    self.type = type
    
    self.internals = internals
  }
}


//--------------------------------------------------------------------------------------------------
// MARK: - WIZClassModel

class WIZAbstractClassModel {
  
  var parameters: [WIZParametersModel]
  
  var parentClass: String
  
  var protocols: [String]?
  
  
  //................................................................................................
  // MARK: - Inits
  
  init(parameters: [WIZParametersModel], parentClass: String, protocols: [String]?) {
    
    self.parameters = parameters
    
    self.parentClass = parentClass
    
    self.protocols = protocols
  }
  
  convenience init(parameters: [WIZParametersModel], parentClass: String) {
    
    self.init(parameters: parameters, parentClass: parentClass, protocols: nil)
  }
}

class WIZObjectiveCClassModel: WIZAbstractClassModel {
  
  var isInternal = false
}



