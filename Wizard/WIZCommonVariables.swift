//
//  WIZCommonVariables.swift
//  Wizard
//
//  Created by Глеб Токмаков on 02.12.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

func numberColor () -> NSColor {
  
  return NSColor.init(hue: 240.0/360.0, saturation: 1.0, brightness: 0.9, alpha: 1.0)
}

func stringColor () -> NSColor {
  
  return NSColor.init(hue: 0.0, saturation: 0.89, brightness: 0.87, alpha: 1.0)
}

func macroColor () -> NSColor {
  
  return NSColor.init(hue: 21.0/360.0, saturation: 0.68, brightness: 0.49, alpha: 1.0)
}

func commentColor () -> NSColor {
  
  return NSColor.init(hue: 0.333, saturation: 1.0, brightness: 0.56, alpha: 1.0)
}

func systemClassColor () -> NSColor {
  
  return NSColor.init(hue: 268.0/360.0, saturation: 0.75, brightness: 0.7, alpha: 1.0)
}

func keywordsColor () -> NSColor {
  
  return NSColor.init(hue: 309.0/360.0, saturation: 0.92, brightness: 0.76, alpha: 1.0)
}

func otherFunctionsColor () -> NSColor {
  
  return NSColor.init(hue: 260.0/360.0, saturation: 0.88, brightness: 0.53, alpha: 1.0)
}

func customClassesColor () -> NSColor {
  
  return NSColor.init(hue: 187.0/360.0, saturation: 0.46, brightness: 0.56, alpha: 1.0)
}
