//
//  FloatingButton.swift
//  Notes
//
//  Created by iim jobs on 27/02/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit

class FloatingButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.*/
    override func draw(_ rect: CGRect) {
        layer.backgroundColor = UIColor.black.cgColor
        layer.cornerRadius = frame.height / 2
    }
    
}
