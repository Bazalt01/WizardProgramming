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
