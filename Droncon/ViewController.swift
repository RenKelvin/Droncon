//
//  ViewController.swift
//  Droncon
//
//  Created by Chuan Ren on 5/6/15.
//  Copyright (c) 2015 Ren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var consoleTitleLabel: UILabel!
    @IBOutlet var consoleSubtitleLabel: UILabel!

    @IBOutlet var lights: RKIndicatorLight!

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
        let throllHandleButtonY0 = throllHandleButton.frame.origin.y
        let throllHandleButtonS0 = throllHandleButton.superview!.frame.height
        let throllMeterImageViewY0 = throllMeterImageView.frame.origin.y
        let throllMeterImageViewH0 = throllMeterImageView.frame.height
        self.throllHandleButton.draggable = true
        self.throllHandleButton.draggingBlock = { (button: RCDraggableButton!) -> Void in
            let dY = button.frame.origin.y - throllHandleButtonY0
            let rect1 = self.throllMeterImageView.frame
            let rect2 = CGRectMake(rect1.origin.x, throllMeterImageViewY0+dY, rect1.width, throllMeterImageViewH0-dY)
            self.throllMeterImageView.frame = rect2

            let per = Float(1 - (throllMeterImageViewY0+dY)/throllHandleButtonS0)
            SocketAdapter.sharedInstance.sendF(per)
        }

        self.wheelHandleButton.draggable = true
        self.wheelHandleButton.autoDocking = true
        self.wheelHandleButton.dockPoint = self.wheelHandleButton.center
        self.wheelHandleButton.limitedDistance = 84.0
        self.wheelHandleButton.dragEndedBlock = { (button: RCDraggableButton!) -> Void in
            let dx = button.center.x - button.dockPoint.x
            let dy = button.center.y - button.dockPoint.y
            NSLog("%f, %f, %f, %f, %f, %f", button.center.x, button.center.y, button.dockPoint.x, button.dockPoint.y, dx, dy)

            if (dx*dx >= dy*dy) {
                if (dx >= 0) {
                    SocketAdapter.sharedInstance.sendC(".")
                }
                else {
                    SocketAdapter.sharedInstance.sendC(",")
                }
            }
            else {
                if (dy >= 0) {
                    SocketAdapter.sharedInstance.sendC("D")
                }
                else {
                    SocketAdapter.sharedInstance.sendC("E")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -

    func updateConsoleTitle(title: String!) {
        self.consoleTitleLabel.text = title
    }

    func updateConsoleSubitle(subtitle: String!) {
        self.consoleSubtitleLabel.text = subtitle
    }

    // MARK: - IBAction Start

    @IBAction func linkButtonTapped(sender: UIButton) {
        sender.selected = !sender.selected
    }

    @IBAction func homeButtonTapped(sender: UIButton) {
        sender.selected = !sender.selected
    }

    // MARK: - IBAction Control

    @IBAction func yawLeftButtonTapped(sender: UIButton) {

    }

    @IBAction func yawRightButtonTapped(sender: UIButton) {

    }

    // MARK: - IBAction Fly Mode

    @IBAction func flyModeButtonTapped(sender: UIButton) {
        flyModeButton1.selected = false
        flyModeButton2.selected = false
        flyModeButton3.selected = false
        flyModeButton4.selected = false
        flyModeButton5.selected = false

        switch sender.tag {
        case 1:
            flyModeButton1.selected = true
            SocketAdapter.sharedInstance.sendC("Z")
        case 2:
            flyModeButton2.selected = true
            SocketAdapter.sharedInstance.sendC("X")
        case 3:
            flyModeButton3.selected = true
            SocketAdapter.sharedInstance.sendC("C")
        case 4:
            flyModeButton4.selected = true
        case 5:
            flyModeButton5.selected = true
        default:
            ""
        }
    }
    
}

