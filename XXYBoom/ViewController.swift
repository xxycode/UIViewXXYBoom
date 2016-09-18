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

    @IBAction func boomAction(_ sender: AnyObject) {
        //view.boom()
        (sender as! UIButton).isEnabled = false
        delay(0) {
            self.yyImg.boom()
        }
        delay(1) {
            self.chromeImg.boom()
        }
        delay(2) {
            self.instrgamImg.boom()
        }
        delay(3) {
            self.firfoxImg.boom()
        }
        delay(4) {
            self.githubImg.boom()
        }
        delay(5) {
            self.sinaImg.boom()
        }
        delay(6) {
            self.clickButton.boom()
        }
    }
    
    @IBAction func resetAction(_ sender: AnyObject) {
        clickButton.isEnabled = true
//        clickButton.removeFromSuperview()
//        yyImg.removeFromSuperview()
//        chromeImg.removeFromSuperview()
//        instrgamImg.removeFromSuperview()
//        firfoxImg.removeFromSuperview()
//        githubImg.removeFromSuperview()
//        sinaImg.removeFromSuperview()
        clickButton.reset()
        yyImg.reset()
        chromeImg.reset()
        instrgamImg.reset()
        firfoxImg.reset()
        githubImg.reset()
        sinaImg.reset()
    }
    typealias Task = (_ cancel : Bool) -> ()
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func cancel(_ task:Task?) {
        task?(true)
    }


}

