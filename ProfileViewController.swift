//
//  ProfileViewController.swift
//  HelpMePlease
//
//  Created by Charles Konkol on 3/31/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit
import MobileCoreServices
//0) Add import for CoreData
import CoreData


class ProfileViewController: UIViewController, CLLocationManagerDelegate{
    //var manager:CLLocationManager!
    var IsMe:Bool!
 
     let locationManager = CLLocationManager()
    
    var MyLocation:String!
    @IBOutlet weak var txtfname: UITextField!
    
    @IBOutlet weak var btnYes: UISwitch!
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as AppDelegate).managedObjectContext
    //2) Add variable contactdb (used from UITableView
    var contactdb:NSManagedObject!
    
    @IBAction func btnSendForHelp(sender: UIButton) {
        
        var object = PFObject(className: "HelpLogs")
        
        object.setObject(Rfname, forKey: "Sfirstname")
        
        object.setObject(Rlname, forKey: "Slastname")
        
        object.setObject(Remail, forKey: "Semail")
        
        object.setObject(Rphone, forKey: "Sphone")
        
        object.setObject(txtfname.text, forKey: "Rfirstname")
        
        object.setObject(txtlname.text, forKey: "Rlastname")
        
        object.setObject(txtemail.text, forKey: "Remail")
        
        object.setObject(txtphone.text, forKey: "Rphone")
        
        object.setObject("request", forKey: "type")
        
        object.setObject(MyLocation, forKey: "Slocation")
        
        object.setObject("None", forKey: "Rlocation")
        
        object.setObject("None", forKey: "ID")
        
        object.save()
    
        ParseID = object.objectId
        
        //update
        println("ObjectID: \(ParseID)")
        var query = PFQuery(className:"HelpLogs")
        query.getObjectInBackgroundWithId(ParseID) {
            (HelpStatus: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println("Error: \(error)")
            } else {
                HelpStatus["ID"] = ParseID
                HelpStatus.saveInBackground()
                println("Success")
            }
        }

          self.txtmsg.text = "Waiting for Help"
        
        //  loadhome()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target:self, selector: Selector("checkforhelp"), userInfo: nil, repeats: true)
    }
    
    @IBAction func btnYes(sender: UISwitch) {
       if sender.on
       {
        IsMe=true
        }
    }
    func checkforhelp()
    {
  
        var helplogemail = PFQuery(className:"HelpLogs")
        helplogemail.whereKey("Remail", equalTo:Remail)
        
        
        var helplogstatus = PFQuery(className:"HelpLogs")
        helplogstatus.whereKey("type", equalTo:"request")
        
        // empty string array
        var query = PFQuery.orQueryWithSubqueries([helplogemail, helplogstatus])
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println("Successfully retrieved \(results.count) results")
                
                for FieldObjects in results {
                  self.txtmsg.text = FieldObjects.objectForKey("type") as String
                }
                
            }
           
        }
    }
    
    @IBAction func btnHelp(sender: UIButton) {
        //update
        println("ObjectID: \(ParseID)")
        var query = PFQuery(className:"HelpLogs")
        query.getObjectInBackgroundWithId("\(ParseID)") {
            (HelpStatus: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println("Error: \(error)")
            } else {
                HelpStatus["type"] = "complete"
                HelpStatus.saveInBackground()
                println("Success")
            }
        }
        self.txtmsg.text = "Completed"
        timer.invalidate()

    }
    
    @IBOutlet weak var txtmsg: UITextView!
    
    
    @IBOutlet weak var txtlname: UITextField!
    
    @IBOutlet weak var txtphone: UITextField!
    
    @IBOutlet weak var txtemail: UITextField!
    
    @IBAction func btnBack(sender: UIBarButtonItem) {
         self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func btnSave(sender: UIButton) {
        //4 Add Save Logic
        if (contactdb != nil)
        {
            
            contactdb.setValue(txtfname.text, forKey: "firstname")
            contactdb.setValue(txtlname.text, forKey: "lastname")
            contactdb.setValue(txtemail.text, forKey: "email")
             contactdb.setValue(txtphone.text, forKey: "phone")
           
            if  IsMe==true
            {
                var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                defaults.setObject(txtfname.text, forKey: "firstname")
                defaults.setObject(txtlname.text, forKey: "lastname")
                defaults.setObject(txtemail.text, forKey: "email")
                defaults.setObject(txtphone.text, forKey: "phone")
                
                defaults.synchronize()
            }

           
        }
        else
        {
            let entityDescription =
            NSEntityDescription.entityForName("Contacts",
                inManagedObjectContext: managedObjectContext!)
            
            let contactd = Contacts(entity: entityDescription!,
                insertIntoManagedObjectContext: managedObjectContext)
            
            contactd.firstname = txtfname.text
            contactd.lastname = txtlname.text
            contactd.phone = txtphone.text
             contactd.email = txtemail.text
            
            var object = PFObject(className: "Contacts")
            object.addObject(txtfname.text, forKey: "firstname")
            object.addObject(txtlname.text, forKey: "lastname")
            object.addObject(txtemail.text, forKey: "email")
            object.addObject(txtphone.text, forKey: "phone")
            
            
            object.save()
            
            //save preference
            
            if  IsMe==true
            {
                var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                defaults.setObject(txtfname.text, forKey: "firstname")
                defaults.setObject(txtlname.text, forKey: "lastname")
                defaults.setObject(txtemail.text, forKey: "email")
                defaults.setObject(txtphone.text, forKey: "phone")
                
                defaults.synchronize()
            }

        }
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            // status.text = err.localizedFailureReason
        } else {
            self.dismissViewControllerAnimated(false, completion: nil)
            
        }

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
       @IBOutlet weak var btnSave: UIButton!
    
  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getlocation()
        MyLocation = ""
        btnYes.setOn(false, animated: true)
        IsMe=false
        if (contactdb != nil)
        {
            var loadSwitch:Bool
            txtfname.text = contactdb.valueForKey("firstname") as String
            txtlname.text = contactdb.valueForKey("lastname") as String
            txtphone.text = contactdb.valueForKey("phone") as String
            txtemail.text = contactdb.valueForKey("email") as String
            btnSave.setTitle("Update", forState: UIControlState.Normal)
            //load preferences
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            if let userLNameNotNull = defaults.objectForKey("lastname") as? String {
                if userLNameNotNull==txtlname.text
                {
                    if let userFNameNotNull = defaults.objectForKey("firstname") as? String {
                        if userFNameNotNull==txtfname.text
                        {
                            btnYes.setOn(true, animated: true)
                        }
                        
                    }
                    
                }
                
                
            }
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
