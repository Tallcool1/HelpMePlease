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


class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var MyLocation:String!
    var objectIds:NSString?
    var competitionArray:NSMutableArray?
    
    @IBAction func btnGiveHelp(sender: UIButton) {
        //update
        println("ObjectID: \(ParseID)")
        var query = PFQuery(className:"HelpLogs")
        query.getObjectInBackgroundWithId("\(ParseID)") {
            (HelpStatus: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println("Error: \(error)")
            } else {
                HelpStatus["type"] = "accepted"
                HelpStatus["Rlocation"] = self.MyLocation
               HelpStatus.saveInBackground()
                 println("Success")
            }
        }
        self.txtmsg.text = "No Requests At This Time"
        
       
    }
    
    @IBOutlet weak var btnGive: UIButton!
    
    @IBOutlet weak var btnHelp: UIButton!
    func home(){
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("pagenav") as NavViewController
       self.presentViewController(vc, animated: true, completion: nil)

    }
    func checkforparse()
    {
        
        if  (accepted==0 && Remail != nil)
        {
            println(Remail)
            var helplogemail = PFQuery(className:"HelpLogs")
            helplogemail.whereKey("email", equalTo:Remail)
            
            
            var helplogstatus = PFQuery(className:"HelpLogs")
            helplogstatus.whereKey("type", equalTo:"request")
            
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

         self.txtmsg.text = "None"
        //load profile
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if let userFNameNotNull = defaults.objectForKey("firstname") as? String {
            Rfname = defaults.objectForKey("firstname") as? String
        }
        if let userLNameNotNull = defaults.objectForKey("lastname") as? String {
            Rlname = defaults.objectForKey("lastname") as? String
        }
        if let userEmailNotNull = defaults.objectForKey("email") as? String {
            Remail = defaults.objectForKey("email") as? String
        }
        if let userPhoneNotNull = defaults.objectForKey("phone") as? String {
            Rphone = defaults.objectForKey("phone") as? String
        }

        
        if let userFNameNotNull = defaults.objectForKey("firstname") as? String {
            if let userLNameNotNull = defaults.objectForKey("lastname") as? String {
                var fn = Rfname
                var ln = Rlname
                username.text = "Welcome: " + fn! + " " + ln!
                
                checkforhelp()
                btnHelp.layer.cornerRadius = 5
                btnHelp.layer.borderWidth = 1
                btnHelp.layer.borderColor = UIColor.blackColor().CGColor
                
                
                             
              //  loadhome()

                timer = NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: Selector("checkforhelp"), userInfo: nil, repeats: true)
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getlocation()
        MyLocation = ""
          loadhome()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
   
        
       
        
      
        // Do any additional setup after loading the view.
    }
  func CleanParse(fieldname: String) -> String
  {
     var getfield: String?
    getfield = fieldname
    getfield =  getfield!
    getfield = getfield?.stringByReplacingOccurrencesOfString("(\n ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    getfield = getfield?.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    getfield = getfield?.stringByReplacingOccurrencesOfString(") ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    getfield = getfield?.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    getfield = getfield?.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    getfield = getfield?.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    
    return getfield!
    
    
    }
   func cleanfields()
   {
    //  println(CleanParse("\(self.competitionArray![0])"))
        Ssendlocation = CleanParse("\(self.competitionArray![0])")
     // println(CleanParse("\(self.competitionArray![1])"))
        Sfname = CleanParse("\(self.competitionArray![1])")
     // println(CleanParse("\(self.competitionArray![2])"))
        Slname = CleanParse("\(self.competitionArray![2])")
     // println(CleanParse("\(self.competitionArray![3])"))
        Semail = CleanParse("\(self.competitionArray![3])")
     // println(CleanParse("\(self.competitionArray![4])"))
        Sphone = CleanParse("\(self.competitionArray![4])")
        ParseID = CleanParse("\(self.competitionArray![5])")
    println(ParseID)

     self.txtmsg.text = "\(Sfname) \(Slname) is requesting help" //Ssendlocation
      accepted=1
    }

    func checkforhelp()
    {
             println(Remail)
         self.txtmsg.text = "None"
             self.competitionArray = NSMutableArray()
        
            
            
            var helplogstatus = PFQuery(className:"HelpLogs")
            helplogstatus.whereKey("type", equalTo:"request")
        
        //var helplogemail = PFQuery(className:"HelpLogs")
        helplogstatus.whereKey("Remail", equalTo:Remail)
        
            // empty string array
            var query = PFQuery.orQueryWithSubqueries([helplogstatus])
            query.findObjectsInBackgroundWithBlock {
                (results: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                     println("Successfully retrieved \(results.count) results")
                   
                 for FieldObjects in results {
                    self.competitionArray!.addObject(FieldObjects.objectForKey("Slocation")!)
                    self.competitionArray!.addObject(FieldObjects.objectForKey("Sfirstname")!)
                    self.competitionArray!.addObject(FieldObjects.objectForKey("Slastname")!)
                    self.competitionArray!.addObject(FieldObjects.objectForKey("Semail")!)
                    self.competitionArray!.addObject(FieldObjects.objectForKey("Sphone")!)
                    self.competitionArray!.addObject(FieldObjects.objectForKey("ID")!)
                    }
                  self.cleanfields()
                }
              
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        var location:CLLocation = locations[locations.count - 1] as CLLocation
        var alts = manager.location.altitude
        if MyLocation == ""
        {
            MyLocation =  "\(locValue.latitude) , \(locValue.longitude)"
        }
        println("locations = \(locValue.latitude) , \(locValue.longitude)")
        
        
    }
    func getlocation()
    {
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }        // Do any additi
    }

}
