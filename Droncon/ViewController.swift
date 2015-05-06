//
//  ViewController.swift
//  Droncon
//
//  Created by Chuan Ren on 5/6/15.
//  Copyright (c) 2015 Ren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var throllHandleButton: RCDraggableButton!
    @IBOutlet var throllMeterImageView: UIImageView!

    @IBOutlet var wheelHandleButton: RCDraggableButton!

    @IBOutlet var flyModeButton1: UIButton!
    @IBOutlet var flyModeButton2: UIButton!
    @IBOutlet var flyModeButton3: UIButton!
    @IBOutlet var flyModeButton4: UIButton!
    @IBOutlet var flyModeButton5: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Init view controls
        self.throllHandleButton.draggable = true
        let throllHandleButtonY0 = throllHandleButton.frame.origin.y
        let throllMeterImageViewY0 = throllMeterImageView.frame.origin.y
        let throllMeterImageViewH0 = throllMeterImageView.frame.height
        self.throllHandleButton.draggingBlock = { (button: RCDraggableButton!) -> Void in
            let dY = button.frame.origin.y - throllHandleButtonY0
            let rect1 = self.throllMeterImageView.frame
            let rect2 = CGRectMake(rect1.origin.x, throllMeterImageViewY0+dY, rect1.width, throllMeterImageViewH0-dY)
            self.throllMeterImageView.frame = rect2
        }

        self.wheelHandleButton.draggable = true
        self.wheelHandleButton.autoDocking = true
        self.wheelHandleButton.dockPoint = self.wheelHandleButton.center
        self.wheelHandleButton.limitedDistance = 84.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBAction

    @IBAction func yawLeftButtonTapped(sender: UIButton) {

    }

    @IBAction func yawRightButtonTapped(sender: UIButton) {

    }

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

