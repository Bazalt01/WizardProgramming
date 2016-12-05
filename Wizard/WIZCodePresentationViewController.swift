//
//  WIZCodePresentationViewController.swift
//  Wizard
//
//  Created by Глеб Токмаков on 27.11.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa


//--------------------------------------------------------------------------------------------------
// MARK: - WIZCodePresentationViewController Implementation

class WIZCodePresentationViewController: NSViewController {

  
  //................................................................................................
  // MARK: - Private Storyboard Properties
  
    @IBOutlet var textView: NSTextView!
  
  
  //................................................................................................
  // MARK: - Overrides
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
  }
  
  
  //................................................................................................
  // MARK: - Public Methods
  
  func openFile (file: WIZProjectHierarchyFile) {
    
    if file.content == nil {
      
      file.updateContent()
    }
    
    guard let content = file.formatterCode else {
    
      return
    }
    
    textView.textStorage?.setAttributedString(content)
  }
}
