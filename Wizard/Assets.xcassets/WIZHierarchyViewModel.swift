//
//  WIZHierarchyViewModel.swift
//  Wizard
//
//  Created by Глеб Токмаков on 27.11.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa


class WIZHierarchyViewModel {

  //................................................................................................
  // MARK: - Public Methods
  
  public private(set) var rootOfProject : WIZProjectHierarchyDirectoryInfo
  
  
  //................................................................................................
  // MARK: - Inits
  
  init(rootOfProject: WIZProjectHierarchyDirectoryInfo) {
    
    self.rootOfProject = rootOfProject
    
    rootOfProject.readChildren(withExtentionRequerement: ["h", "m"])
  }
  
  
  //................................................................................................
  // MARK: - Public Methods
  
  func readRootOfProject () {
    
    
  }
}
