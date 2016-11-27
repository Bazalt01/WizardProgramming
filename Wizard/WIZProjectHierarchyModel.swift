//
//  WIZProjectHierarchyModel.swift
//  Wizard
//
//  Created by Глеб Токмаков on 26.11.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

class WIZProjectHierarchyModel {

  //................................................................................................
  // MARK: - Public Read-only Properties
  
  public private(set) var parent : WIZProjectHierarchyModel?
  public private(set) var url : URL
  
  
  //................................................................................................
  // MARK: - Inits
  
  init (parent: WIZProjectHierarchyModel?, url: URL) {
    
    self.parent = parent
    self.url    = url
  }
}
