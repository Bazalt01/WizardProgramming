//
//  WIZMainViewController.swift
//  Wizard
//
//  Created by Глеб Токмаков on 26.11.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa


//--------------------------------------------------------------------------------------------------
// MARK: - Locals

let kWIZSearchViewControllerIdentifier = "WIZSearchViewController"
let kWIZHierarchyViewControllerIdentifier = "WIZHierarchyViewController"

let kProjectDirectory = "projectDirectory"


//--------------------------------------------------------------------------------------------------
// MARK: - WIZMainViewController Implementation

class WIZMainViewController: NSViewController, WIZHierarchyViewControllerDelegate {

  
  //................................................................................................
  // MARK: - Private Properties
  
  var dictionaryFileUrlsOfProject = [NSURL]()
  
  
  //................................................................................................
  // MARK: - Private Properties
  
  private var rootOfProject : WIZProjectHierarchyDirectoryInfo?
  
  private weak var hierarchyController : WIZHierarchyViewController?
  
  private weak var codePresentationController : WIZCodePresentationViewController?
		
  
  
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
  
  override func viewDidAppear() {
    
    for viewController in self.childViewControllers {
      
      if viewController is WIZHierarchyViewController {
        
        hierarchyController = viewController as? WIZHierarchyViewController
        
        hierarchyController!.delegate = self
      }
        
      else if viewController is WIZCodePresentationViewController {
        
        codePresentationController = viewController as? WIZCodePresentationViewController
      }
    }
    
    let defaults = UserDefaults.standard
    
    if let projectURL = defaults.url(forKey: kProjectDirectory) {
      
      readProject(projectURL: projectURL)
    }
  }
  
  
  //................................................................................................
  // MARK: - Internal Methods
  
  func openProject () {
    
    let defaults = UserDefaults.standard
    
    
    let openDialog: NSOpenPanel = NSOpenPanel()
    
    openDialog.canChooseDirectories = true
    
    openDialog.runModal()
    
    
    guard let projectURL = openDialog.url else {
    
      return
    }
    
    readProject(projectURL: projectURL)
    
    defaults.set(projectURL, forKey: kProjectDirectory)
  }
  
  func readProject (projectURL: URL) {
  
    rootOfProject = WIZProjectHierarchyDirectoryInfo(parent: nil, url: projectURL)
    
    let hierarchyViewModel = WIZHierarchyViewModel(rootOfProject: rootOfProject!)
    
    guard let hc = hierarchyController else {
      
      return
    }
    
    hc.setViewModel(viewModel: hierarchyViewModel)
  }
  
  
  //................................................................................................
  // MARK: - WIZHierarchyViewControllerDelegate Implementation
  
  func hierarchyController (sender: WIZHierarchyViewController, didSelectFile file: WIZProjectHierarchyFile) {
  
    if let cpc = codePresentationController {
    
      cpc.openFile(file: file)
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
