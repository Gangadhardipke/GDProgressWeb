//
//  ViewController.swift
//  GDwebManager
//
//  Created by Apple2 on 26/08/16.
//  Copyright © 2016 Gangadhar Dipke. All rights reserved.
//

import UIKit
import QuartzCore



class ViewController: UIViewController {

    // Creating object for GDWebManager class
    let GDWM = GDwebManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Show progress Bar
    
        
        
        GDWM.showProgressBar(Title:"Loading...")
        
        // Passing parameter to convert it in string
        
        let name = "userMobileNo=7058678107&passWord=12345678&userToken=1221"
        
        //  Calling the Web Services Method
        
        GDWM.CallAPI(flag: "login.php?", parameter: name, delegate: self, onSuccess:#selector(SusseccCall) , onFailure: #selector(FailCall))
        
        //  the flag are the remaining url
        // SuccessCall and FailCall are Method
        // always set delegate as you ViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SusseccCall(dict : NSDictionary) {
        
        // Hide progress Bar
        GDWM.HideProgressBar()
        print("geting success callback : %@",dict)
    }
    func FailCall (dict : NSDictionary){
        
        // Hide progress Bar
        GDWM.HideProgressBar()
        
        print("geting success callback  : %@",dict)
    }
}

