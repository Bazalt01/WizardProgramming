//
//  WIZCommonVariables.swift
//  Wizard
//
//  Created by Глеб Токмаков on 02.12.16.
//  Copyright © 2016 Master. All rights reserved.
//

import Cocoa

func numberColor () -> NSColor {
  
  return NSColor.init(hue: 240.0/360.0, saturation: 1.0, brightness: 1.0, alpha: 0.8)
}

func stringColor () -> NSColor {
  
  return NSColor.init(hue: 0.0, saturation: 0.89, brightness: 0.77, alpha: 0.85)
}

func macroColor () -> NSColor {
  
  return NSColor.init(hue: 21.0/360.0, saturation: 0.68, brightness: 0.39, alpha: 0.95)
}

func commentColor () -> NSColor {
  
  return NSColor.init(hue: 0.333, saturation: 1.0, brightness: 0.46, alpha: 0.85)
}

func systemClassColor () -> NSColor {
  
  return NSColor.init(hue: 268.0/360.0, saturation: 0.75, brightness: 0.6, alpha: 0.85)
}

func keywordsColor () -> NSColor {
  
  return NSColor.init(hue: 309.0/360.0, saturation: 0.92, brightness: 0.66, alpha: 0.85)
}

func otherFunctionsColor () -> NSColor {
  
  return NSColor.init(hue: 260.0/360.0, saturation: 0.88, brightness: 0.43, alpha: 0.85)
}
