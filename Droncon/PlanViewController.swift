//
//  PlanViewController.swift
//  Droncon
//
//  Created by Chuan Ren on 5/16/15.
//  Copyright (c) 2015 Ren. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController, ACEDrawingViewDelegate {

    @IBOutlet var canvas: ACEDrawingView!

    @IBOutlet var modeButton1: UIButton!
    @IBOutlet var modeButton2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.canvas.delegate = self
        self.canvas.lineColor = UIColor.whiteColor()
        self.canvas.lineWidth = 4.0
        self.canvas.lineAlpha = 0.9
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func clearTapped(sender: UIButton) {
        self.canvas.clear()
    }

    @IBAction func planTapped(sender: UIButton) {
        self.canvas.drawTool = ACEDrawingToolTypePen
        modeButton1.selected = true
        modeButton2.selected = false
    }

    @IBAction func fencingTapped(sender: UIButton) {
        self.canvas.drawTool = ACEDrawingToolTypeRectagleStroke
        modeButton1.selected = false
        modeButton2.selected = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

    // MARK: - ACEDrawingViewDelegate

    func drawingView(view: ACEDrawingView, willBeginDrawUsingTool tool: ACEDrawingTool) {

    }

    func drawingView(view: ACEDrawingView, didEndDrawUsingTool tool: ACEDrawingTool) {
        
    }
    
}
