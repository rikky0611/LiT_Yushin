//
//  ViewController.swift
//  test_yushin
//
//  Created by 荒川陸 on 2016/01/06.
//  Copyright © 2016年 com.litech. All rights reserved.
//

import UIKit


class ResultViewController: UIViewController{
    //appDelegate宣言
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    //ラベル宣言
    var resultLabel: UILabel!
    
    //ボタン宣言
    var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createResultLabel()
        createBackButton()
    }
    
    func createResultLabel(){
        resultLabel = UILabel()
        resultLabel.frame = CGRectMake(self.view.bounds.width/4, self.view.bounds.height/4, self.view.bounds.width/2, 80)
        resultLabel.backgroundColor = UIColor.greenColor()
        resultLabel.text = String(format:"音量は %.01f db",appDelegate.volume)
        resultLabel.textAlignment = NSTextAlignment.Center
        resultLabel.font = UIFont.systemFontOfSize(20)
        view.addSubview(resultLabel)
        
    }
    
    func createBackButton(){
        backButton = UIButton()
        backButton.frame = CGRectMake(self.view.bounds.width/4, self.view.bounds.height/4*3, self.view.bounds.width/2, 80)
        backButton.backgroundColor = UIColor.greenColor()
        backButton.setTitle("Tap to Back", forState: .Normal)
        backButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        backButton.addTarget(self, action: "backTapped", forControlEvents: .TouchUpInside)
        view.addSubview(backButton)
    }
    
    func backTapped(){
        let targetViewController = self.storyboard!.instantiateViewControllerWithIdentifier( "main" )
        self.presentViewController( targetViewController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

