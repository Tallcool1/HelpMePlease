//
//  DetailViewController.swift
//  HelpMePlease
//
//  Created by Charles Konkol on 3/31/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//
import MapKit
import CoreLocation
import UIKit

class DetailViewController: UIViewController,UITextFieldDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate{
   
   
    @IBAction func btnBack(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(false, completion: nil)

    }
    
    

    
    @IBOutlet weak var maos: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapManager = MapManager()
    var tableData = NSArray()
    var longe:Double=0.0
    var late:Double=0.0
    var IsMap=true
    @IBOutlet var tableview:UITableView? = UITableView()
    @IBOutlet var maps:MKMapView? = MKMapView()
    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("timeStamp")!.description
            }
        }
    }

    override func viewDidLoad() {
        IsMap=true
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         self.maps?.delegate = self
        
        //IsMap=true
        loadLocal()
        //var location = self.mapView?.userLocation
        getDirectionsUsingApple()
//        self.configureView()
//       loadLocal()
//        //var location = self.mapView?.userLocation
//        getDirectionsUsingApple()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadLocal()
    {
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }        // Do any additional setup after loading the view, typically from a nib.
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        var location:CLLocation = locations[locations.count - 1] as CLLocation
        var alts = manager.location.altitude
        
        println("locations = \(locValue.latitude) \(locValue.longitude)")
      //  longitude.text = "\(locValue.longitude)"
      //  lat.text = "\(locValue.latitude)"
        longe = (locValue.longitude)
        late = (locValue.latitude)
     //   alt.text = "\(alts)"
     //   speed.text = "\(location.speed)"
        
        if IsMap==true{
            IsMap=false
            self.getlocations()
        }
        
        
    }
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            println("done")
            return polylineRenderer
        }
        
        return nil
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        return 1
    }
    
    func mapViewWillStartLocatingUser(mapView: MKMapView!) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return tableData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "direction")
        
        var idx:Int = indexPath.row
        
        
        var dictTable:NSDictionary = tableData[idx] as NSDictionary
        var instruction = dictTable["instructions"] as NSString
        var distance = dictTable["distance"] as NSString
        var duration = dictTable["duration"] as NSString
        var detail = "distance:\(distance) duration:\(duration)"
        
        
        cell.textLabel?.text = instruction
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont(name: "Helvetica Neue Light", size: 15.0)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        //cell.textLabel.font=  [UIFont fontWithName:"Helvetica Neue-Light" size:15];
        cell.detailTextLabel!.text = detail
        
        
        return cell
    }
    
    func getlocations(){
        
        var location = CLLocationCoordinate2D(
            latitude: late,
            longitude: longe
        )
        
        var span = MKCoordinateSpanMake(0.5, 0.5)
        var region = MKCoordinateRegion(center: location, span: span)
        
        maos.setRegion(region, animated: true)
      
        var annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = "Help"
        annotation.subtitle = "Me"
        
        // maps.addAnnotation(annotation)
    }
    func getDirectionsUsingApple() {
        
        var destination = Ssendlocation // sendlocation
        mapManager.directionsFromCurrentLocation(to: destination!) { (route, directionInformation, boundingRegion, error) -> () in
            
            if (error? != nil) {
                
                println(error!)
            }else{
                
                if let web = self.maps?{
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        web.addOverlay(route!)
                        web.setVisibleMapRect(boundingRegion!, animated: true)
                        
                        self.tableview?.delegate = self
                        self.tableview?.dataSource = self
                        self.tableData = directionInformation?.objectForKey("steps") as NSArray
                        self.tableview?.reloadData()
                    }
                    
                }
            }
            
        }
        
        
    }
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var hasAuthorised = false
            var locationStatus:NSString = ""
            var verboseKey = status
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access"
            case CLAuthorizationStatus.Denied:
                locationStatus = "Denied access"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Not determined"
            default:
                locationStatus = "Allowed access"
                hasAuthorised = true
            }
            
            
            
            if(hasAuthorised == true){
                
                getDirectionsUsingApple()
                
            }else {
                
                println("locationStatus \(locationStatus)")
                
            }
            
    }


}

