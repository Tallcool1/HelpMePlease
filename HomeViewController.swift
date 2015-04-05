//
//  HomeViewController.swift
//  HelpMePlease
//
//  Created by Charles Konkol on 3/31/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit
import CoreData

import UIKit
import Parse
import ParseUI


class HomeViewController: UIViewController {

    
    
    @IBAction func btnGiveHelp(sender: UIButton) {
        
        
    }
    
    @IBOutlet weak var btnGive: UIButton!
    
    @IBOutlet weak var btnHelp: UIButton!
    func home(){
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("nav") as NavViewController
       self.presentViewController(vc, animated: true, completion: nil)

    }
    func checkforparse()
    {
        
        if  (accepted==0 && email != nil)
        {
            println(email)
            var helplogemail = PFQuery(className:"HelpLogs")
            helplogemail.whereKey("email", equalTo:email)
            
            
            var helplogstatus = PFQuery(className:"HelpLogs")
            helplogstatus.whereKey("type", equalTo:"sender")
            
            // empty string array
            var query = PFQuery.orQueryWithSubqueries([helplogemail, helplogstatus])
            query.findObjectsInBackgroundWithBlock {
                (results: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    println("Successfully retrieved \(results.count) people")
                    for object in results {
                        
                        //  self.objectIds = object.objectId
                        if let staffObjects = object as? [PFObject] {
                            for staff in staffObjects {
                                // Use staff as a standard PFObject now. e.g.
                                let loc = staff.objectForKey("location") as String
                                println(loc)
                            }
                        }
                        
                        // self.getfields()
                        accepted=1
                        
                        
                    }
                    
                    
                    
                    
                }
                else
                {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
            }
        }
    }

    
    func loadhome()
    {

 
        //load profile
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let userFNameNotNull = defaults.objectForKey("firstname") as? String {
            fname = defaults.objectForKey("firstname") as? String
        }
        if let userLNameNotNull = defaults.objectForKey("lastname") as? String {
            lname = defaults.objectForKey("lastname") as? String
        }
        if let userEmailNotNull = defaults.objectForKey("email") as? String {
            email = defaults.objectForKey("email") as? String
        }
        if let userPhoneNotNull = defaults.objectForKey("phone") as? String {
            phone = defaults.objectForKey("phone") as? String
        }

        
        if let userFNameNotNull = defaults.objectForKey("firstname") as? String {
            if let userLNameNotNull = defaults.objectForKey("lastname") as? String {
                var fn = fname
                var ln = lname
                username.text = "Welcome: " + fn! + " " + ln!
                
                checkforhelp()
                btnHelp.layer.cornerRadius = 5
                btnHelp.layer.borderWidth = 1
                btnHelp.layer.borderColor = UIColor.blackColor().CGColor
                
                
                             
              //  loadhome()

                timer = NSTimer.scheduledTimerWithTimeInterval(60, target:self, selector: Selector("checkforhelp"), userInfo: nil, repeats: true)
            }
        }
        else
        {
            var alertView = UIAlertView();
            alertView.addButtonWithTitle("Ok");
            alertView.title = "Profile Needed";
            alertView.message = "Please add your Profile";
            alertView.show();
            
             timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("home"), userInfo: nil, repeats: false)
        
        }
                
    }
        @IBAction func btnHelp(sender: UIButton) {
           
    }
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var txtmsg: UITextView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
       loadhome()
        
       
        
      
        // Do any additional setup after loading the view.
    }
    var objectIds:NSString?
    var competitionArray:NSMutableArray?
    func checkforhelp()
    {
        
       
             println(email)
             self.competitionArray = NSMutableArray()
                      var helplogemail = PFQuery(className:"HelpLogs")
            helplogemail.whereKey("email", equalTo:email)
            
            
            var helplogstatus = PFQuery(className:"HelpLogs")
            helplogstatus.whereKey("type", equalTo:"sender")
          
            // empty string array
            var query = PFQuery.orQueryWithSubqueries([helplogemail, helplogstatus])
            query.findObjectsInBackgroundWithBlock {
                (results: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                     println("Successfully retrieved \(results.count) people")
                   
                        self.checkforparse()
                      // self.objectIds = result.objectId
                        if let staffObjects = results as? [PFObject] {
                            for staff in staffObjects {
                                // Use staff as a standard PFObject now. e.g.
                                //let loc = staff.objectForKey("location") as String
                            self.competitionArray!.addObject(staff.objectForKey("location")!)
                                println(self.competitionArray![0])

                                sendlocation = "\(self.competitionArray![0])"
                                sendlocation = sendlocation!
                                
                                println(sendlocation)
                                
                                
                                
                                sendlocation = sendlocation?.stringByReplacingOccurrencesOfString("(\n ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                
                                sendlocation = sendlocation?.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                
                                
                                sendlocation = sendlocation?.stringByReplacingOccurrencesOfString(") ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                
                                sendlocation = sendlocation?.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                
                                sendlocation = sendlocation?.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                
                                 sendlocation = sendlocation?.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                
                                
                                println(sendlocation)
    
                   
                                self.txtmsg.text = sendlocation

                            
                            }
                        }
                    
                                                                   accepted=1
              
                }
                else
                {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
            }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
