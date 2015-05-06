//
//  ViewController.swift
//  Droncon
//
//  Created by Chuan Ren on 5/6/15.
//  Copyright (c) 2015 Ren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var flyModeButton1: UIButton!
    @IBOutlet var flyModeButton2: UIButton!
    @IBOutlet var flyModeButton3: UIButton!
    @IBOutlet var flyModeButton4: UIButton!
    @IBOutlet var flyModeButton5: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBAction

    @IBAction func lockButtonTapped(sender: UIButton) {
        sender.selected = !sender.selected
    }

    @IBAction func homeButtonTapped(sender: UIButton) {
        sender.selected = !sender.selected
    }

    @IBAction func flyModeButtonTapped(sender: UIButton) {
        flyModeButton1.selected = false
        flyModeButton2.selected = false
        flyModeButton3.selected = false
        flyModeButton4.selected = false
        flyModeButton5.selected = false

        switch sender.tag {
        case 1:
            flyModeButton1.selected = true
        case 2:
            flyModeButton2.selected = true
        case 3:
            flyModeButton3.selected = true
        case 4:
            flyModeButton4.selected = true
        case 5:
            flyModeButton5.selected = true
        default:
            ""
        }
    }
}

