//
//  WIZProjectHierarchyDirectoryInfo.swift
//  Wizard
//
//  Created by Глеб Токмаков on 27.11.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

class WIZProjectHierarchyDirectoryInfo: WIZProjectHierarchyModel {

  
  //................................................................................................
  // MARK: - Public Read-only Properties
  
  public private(set) var children = Array<WIZProjectHierarchyModel>()
  
  
  //................................................................................................
  // MARK: - Public Methods
  
  func readChildren (withExtentionRequerement extentionRequerement: [String]) {
    
    let fileManager = FileManager.default
    
    do {
      
      let contents = try fileManager.contentsOfDirectory(atPath: url.path)
      
      for stringURL in contents {
        
        if !check(path: stringURL, byExtentionRequerement: extentionRequerement) { continue }
        
        var isDirectory: ObjCBool = false
    
        let checkURL = url.appendingPathComponent(stringURL)
        
        if fileManager.fileExists(atPath: checkURL.path, isDirectory: &isDirectory) {
          
          if isDirectory.boolValue {
          
            let child = WIZProjectHierarchyDirectoryInfo(parent: self, url: checkURL)

            child.readChildren(withExtentionRequerement: extentionRequerement)
            
            children.append(child)
          }
          else {
            
            children.append(WIZProjectHierarchyModel(parent: self, url: checkURL))
          }
        }
      }
    } catch {
      
      return
    }
  }
  
  //................................................................................................
  // MARK: - Private Methods
  
  func check(path: String, byExtentionRequerement extentionRequerement: [String]) -> Bool {
    
    if !path.contains(".") { return true }
    
    let lastPath = path.components(separatedBy: ".").last!
    
    for extention in extentionRequerement {
    
      if lastPath == extention { return true }
    }
    
    return false
  }
}
