//
//  WIZMainViewController.swift
//  Wizard
//
//  Created by Глеб Токмаков on 26.11.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

let kWIZSearchViewControllerIdentifier = "WIZSearchViewController"

class WIZMainViewController: NSViewController {

  
  //................................................................................................
  // MARK: - Private Properties
  
  var dictionaryFileUrlsOfProject = [NSURL]()
  
  
  //------------------------------------------------------------------------------------------------
  // MARK: - Private
  
  private var rootOfProject : WIZProjectHierarhyDirectoryInfo?
		
  
  var _viewModel : WIZMainVeiwModel? {
      
    set (newViewModel) {
          
    }
      
    get {
      
      return self._viewModel
    }
  }
  
  
  //................................................................................................
  // MARK: - Overrides
  
  override func viewDidLoad () {
      
    super.viewDidLoad ()
  }
  
  //................................................................................................
  // MARK: - Internal Methods
  
  func openProject () {
    
    let openDialog: NSOpenPanel = NSOpenPanel()
    openDialog.canChooseDirectories = true
    openDialog.runModal()
    
    guard let projectURL = openDialog.url else {
      return
    }
    
    readProject(projectURL: projectURL)
  }
  
  func readProject (projectURL: URL) {
  
    rootOfProject = WIZProjectHierarhyDirectoryInfo(parent: nil, url: projectURL)
    
    
  }
  
  
  
  //................................................................................................
  // MARK: - Actions
  
  @IBAction func actionSearch(_ sender: Any) {
    
    let controller = self.storyboard?.instantiateController( withIdentifier: kWIZSearchViewControllerIdentifier)
    
    self.presentViewControllerAsSheet(controller as! NSViewController)
  }
}
