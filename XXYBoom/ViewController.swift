//
//  ViewController.swift
//  XXYBang~
//
//  Created by Xiaoxueyuan on 15/10/1.
//  Copyright (c) 2015年 Xiaoxueyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var yyImg: UIImageView!
    @IBOutlet weak var chromeImg: UIImageView!
    @IBOutlet weak var instrgamImg: UIImageView!
    @IBOutlet weak var firfoxImg: UIImageView!
    @IBOutlet weak var githubImg: UIImageView!
    @IBOutlet weak var sinaImg: UIImageView!
    @IBOutlet weak var clickButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func boomAction(sender: AnyObject) {
        (sender as! UIButton).enabled = false
        delay(0, task: {self.yyImg.boom()})
        delay(1, task: {self.chromeImg.boom()})
        delay(2, task: {self.instrgamImg.boom()})
        delay(3, task: {self.firfoxImg.boom()})
        delay(4, task: {self.githubImg.boom()})
        delay(5, task: {self.sinaImg.boom()})
        delay(6, task: {self.clickButton.boom()})
    }
    
    typealias Task = (cancel : Bool) -> ()
    
    func delay(time:NSTimeInterval, task:()->()) ->  Task? {
        
        func dispatch_later(block:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(time * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                block)
        }
        
        var closure: dispatch_block_t? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    dispatch_async(dispatch_get_main_queue(), internalClosure);
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(cancel: false)
            }
        }
        
        return result;
    }
    
    func cancel(task:Task?) {
        task?(cancel: true)
    }


}

