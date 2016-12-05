//
//  WIZMainViewController.swift
//  Wizard
//
//  Created by Глеб Токмаков on 26.11.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

let kWIZSearchViewControllerIdentifier = "WIZSearchViewController"
let kWIZHierarchyViewControllerIdentifier = "WIZHierarchyViewController"

class WIZMainViewController: NSViewController {

  
  //................................................................................................
  // MARK: - Private Properties
  
  var dictionaryFileUrlsOfProject = [NSURL]()
  
  
  //------------------------------------------------------------------------------------------------
  // MARK: - Private
  
  private var rootOfProject : WIZProjectHierarchyDirectoryInfo?
		
  
  var _viewModel : WIZMainVeiwModel? {
      
    set (newViewModel) {
          
    }
      
    get {
      
      return self._viewModel
    }
  }
  
  private var hierarchyViewController : WIZHierarchyViewController?
  
  
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
  
    rootOfProject = WIZProjectHierarchyDirectoryInfo(parent: nil, url: projectURL)
    
    let hierarchyViewModel = WIZHierarchyViewModel(rootOfProject: rootOfProject!)
    
    for viewController in self.childViewControllers {
    
      if viewController is WIZHierarchyViewController {
      
        (viewController as! WIZHierarchyViewController).setViewModel(viewModel: hierarchyViewModel)
      }
    }
  }
  
  
  //................................................................................................
  // MARK: - Actions
  
  @IBAction func actionOpenProject(_ sender: Any) {
    
    openProject()
  }
  
  @IBAction func actionSearch(_ sender: Any) {

    let controller = self.storyboard?.instantiateController( withIdentifier: kWIZSearchViewControllerIdentifier)
    
    self.presentViewControllerAsSheet(controller as! NSViewController)
  }
}
