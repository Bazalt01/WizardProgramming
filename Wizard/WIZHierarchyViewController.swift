//
//  WIZHierarchyViewController.swift
//  Wizard
//
//  Created by Глеб Токмаков on 27.11.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa


//--------------------------------------------------------------------------------------------------
// MARK: - Locals

let kFileCellReuseIdentifier = "fileCellReuseIdentifier"
let kDirectoryCellReuseIdentifier = "directoryCellReuseIdentifier"


//--------------------------------------------------------------------------------------------------
// MARK: - WIZHierarchyViewController

class WIZHierarchyViewController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {

  
  //................................................................................................
  // MARK: - Private Storyboard Properties

  @IBOutlet weak var outlineView: NSOutlineView!
  
  //................................................................................................
  // MARK: - Private Properties
  
  private var viewModel : WIZHierarchyViewModel?
  
  
  //................................................................................................
  // MARK: - Public Methods
  
  func setViewModel (viewModel: WIZHierarchyViewModel) {
    
    self.viewModel = viewModel
    
    outlineView.reloadData()
  }
  
  
  
  
  //................................................................................................
  // MARK: - Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
    
  }
  
  
  //................................................................................................
  // MARK: - NSTableViewDelegate Implementation
  
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
  
    var view : NSTableCellView?
    
    if item is WIZProjectHierarchyDirectoryInfo {
    
      view = outlineView.make(withIdentifier: kDirectoryCellReuseIdentifier, owner: self) as? NSTableCellView
    }
    else {
      
      view = outlineView.make(withIdentifier: kFileCellReuseIdentifier, owner: self) as! NSTableCellView?
    }
    
    guard let existView = view else {
      
      return view
    }
    
    guard let textField = existView.textField else {
      
      return view
    }
    
    let element = item as! WIZProjectHierarchyModel
    
    textField.stringValue = element.url.lastPathComponent
    
    
    return view
  }
  
  
  //................................................................................................
  // MARK: - NSTableViewDataSource Implementation
  

  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    
    guard let vm = self.viewModel else {
      return 0
    }
    
    guard let currentItem = item else {
      
      return vm.rootOfProject.children.count
    }
    
    if currentItem is WIZProjectHierarchyDirectoryInfo {
      
      let directory = currentItem as! WIZProjectHierarchyDirectoryInfo
      
      return directory.children.count
    }
    
    return 0
  }
  
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    
    guard let vm = self.viewModel else {
      return 0
    }
    
    guard let currentItem = item else {
      
      return vm.rootOfProject.children[index]
    }
    
    if currentItem is WIZProjectHierarchyDirectoryInfo {
      
      let directory = currentItem as! WIZProjectHierarchyDirectoryInfo
      
      return directory.children[index]
    }
    
    return 0
  }
  
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    
    if item is WIZProjectHierarchyDirectoryInfo {
      
      let directory = item as! WIZProjectHierarchyDirectoryInfo
      
      if directory.children.count > 0 {
      
        return true
      }
    }
    
    return false
  }
}
