//
//  GDWebManager.swift
//  GDwebManager
//
//  Created by Apple2 on 26/08/16.
//  Copyright © 2016 Gangadhar Dipke. All rights reserved.
//

import Foundation
import UIKit
class GDwebManager: NSObject {
 
let Mainurl : NSString = "Main URL string"
var Alert: UIAlertView!

func isConnectedToNetwork()->Bool{
    
    var Status:Bool = false
    let url = NSURL(string: "http://www.apple.com")
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "HEAD"
    request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
    request.timeoutInterval = 10.0
    
    var response: NSURLResponse?
    do{
        try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }else{
                Status = false
                showAlert("title name", message: "Not connect to Internet")
            }
        }
    }catch{
        print("error")
        //Hide ProggessBar
        HideProgressBar()
        
        // Show Error Msg
        showAlert("title name", message: "Oops, something went wrong! Try again, please!")
    }
    
    
    return Status
}
func showProgressBar(Title title:NSString)-> Void {
  //  Init Alertview
    Alert = UIAlertView(title:nil, message:nil, delegate: nil, cancelButtonTitle:nil);
    
    // Creating UIView
    let GDPView : UIView = UIView.init(frame: CGRectMake(10, 0, 200, 50))
    
      // Creating UIActivityIndicatorView
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 0, 50, 50)) as UIActivityIndicatorView
  
          // Creating UILable
    
    let Loadlbl : UILabel = UILabel.init(frame: CGRectMake(60, 5, 120, 40))
    Loadlbl.text = title as String
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    loadingIndicator.startAnimating()
        GDPView.addSubview(loadingIndicator)
     GDPView.addSubview(Loadlbl)
    //Adding view to AlertView
    Alert.setValue(GDPView, forKey: "accessoryView")
  
  
    Alert.show();
}
func HideProgressBar() {
    //Hide or dismiss alert from view
    Alert.dismissWithClickedButtonIndex(0, animated: true)
}
func CallAPI(flag flag: NSString, parameter: NSString, delegate: AnyObject, onSuccess:Selector, onFailure:Selector ) -> Void {
    if isConnectedToNetwork() == true  {
        print("connected to internet")
        
        let url:NSURL = NSURL(string: String(format: "http://gps.encureit.com/gpsWS/%@", flag))!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        request.HTTPBody = parameter.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            do{
                
                let json:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [String:AnyObject]
                print(json)
                if json .valueForKey("Success") as! Bool == true{
                    
                    delegate .performSelectorOnMainThread(onSuccess, withObject: json, waitUntilDone: true)
                    print("success");
                }else{
                    print("Fail to get success");
                    delegate .performSelectorOnMainThread(onFailure, withObject: json, waitUntilDone: true)
                    
                }
            }
            catch{
                print("Fail to get success");
            }
        }
        
        task.resume()
    }else{
        // Hide progress Bar
        HideProgressBar()
        
        print("Oops, something went wrong! Try again, please!")
    }
    
}
func showAlert(title:NSString , message : NSString)-> Void {
    Alert = UIAlertView(title:title as String, message:message as String, delegate: nil, cancelButtonTitle:"Cancel");
    Alert.show();
}

}