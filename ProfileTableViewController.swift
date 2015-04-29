//
//  ProfileTableViewController.swift
//  HelpMePlease
//
//  Created by Charles Konkol on 3/31/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//
import CoreData
import Foundation
import UIKit

class ProfileTableViewController: UITableViewController {
  var contactArray = [NSManagedObject]()
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    //4) Add func loaddb to load database and refresh table
    func loaddb()
    {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        
        let fetchRequest = NSFetchRequest(entityName:"Contacts")
        
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            contactArray = results
            tableView.reloadData()
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return contactArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //7) Uncomment & Change to below to load rows
        let cell =
        tableView.dequeueReusableCellWithIdentifier("Cell")
            as UITableViewCell
        
        let person = contactArray[indexPath.row]
        var fn = person.valueForKey("firstname") as String?
        var ln = person.valueForKey("lastname") as String?
        cell.textLabel?.text = fn! + " " + ln!
        cell.detailTextLabel?.text = person.valueForKey("phone") as String?
        
        return cell
    }
    
    //8) Add to show row clicked
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println("You selected cell #\(indexPath.row)")
    }
    
    
    //9) Uncomment
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    //10) Uncomment
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //11 Change to delete swiped row
        if editingStyle == .Delete {
            let appDelegate =
            UIApplication.sharedApplication().delegate as AppDelegate
            let context = appDelegate.managedObjectContext!
            context.deleteObject(contactArray[indexPath.row])
            var error: NSError? = nil
            if !context.save(&error) {
                println("Unresolved error \(error)")
                abort()
            }
            else
            {
                loaddb()
            }
        }
        
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //12) Uncomment & Change to go to proper record on proper Viewcontroller
        if segue.identifier == "Profile" {
            if let destination = segue.destinationViewController as?
                ProfileViewController {
                    if let SelectIndex = tableView.indexPathForSelectedRow()?.row {
                        
                        let selectedDevice:NSManagedObject = contactArray[SelectIndex] as NSManagedObject
                        destination.contactdb = selectedDevice
                    }
            }
        }
    }

}
