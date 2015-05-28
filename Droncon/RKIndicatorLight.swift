//
//  RKIndicatorLight.swift
//  Droncon
//
//  Created by Chuan Ren on 5/27/15.
//  Copyright (c) 2015 Ren. All rights reserved.
//

import UIKit

class RKIndicatorLight: UIView {

    @IBOutlet var l1: UIImageView!
    @IBOutlet var l2: UIImageView!
    @IBOutlet var l3: UIImageView!
    @IBOutlet var l4: UIImageView!

    func turnRed() {
        l1.image = UIImage(named: "Red_Light")
        l2.image = UIImage(named: "Red_Light")
        l3.image = UIImage(named: "Red_Light")
        l4.image = UIImage(named: "Red_Light")
    }

    func turnYellow() {
        l1.image = UIImage(named: "Yellow_Light")
        l2.image = UIImage(named: "Yellow_Light")
        l3.image = UIImage(named: "Yellow_Light")
        l4.image = UIImage(named: "Yellow_Light")
    }

    func turnGreen() {
        l1.image = UIImage(named: "Green_Light")
        l2.image = UIImage(named: "Green_Light")
        l3.image = UIImage(named: "Green_Light")
        l4.image = UIImage(named: "Green_Light")
    }
    
}
