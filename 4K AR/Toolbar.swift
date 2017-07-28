//
//  Toolbar.swift
//  4K AR
//
//  Created by Flip on 7/19/17.
//  Copyright © 2017 Flip. All rights reserved.
//

import UIKit
import Foundation

class Toolbar: UIToolbar {
    
    // The block selector
    let blockTypeSelector = UISegmentedControl(items: [
        UIImage(named: "cube-0-selector")!,
        UIImage(named: "cube-1-selector")!,
        UIImage(named: "cube-2-selector")!,
        UIImage(named: "cube-3-selector")!,
    ])
    
    init(viewWidth: CGFloat, viewHeight: CGFloat) {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: viewHeight - 50), size: CGSize(width: viewWidth, height: 50)))
        
        // Initialize the block selector with the first option selected
        blockTypeSelector.selectedSegmentIndex = 0
        
        // Add the selector to the toolbar
        self.setItems([
            UIBarButtonItem(customView: blockTypeSelector),
        ], animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

