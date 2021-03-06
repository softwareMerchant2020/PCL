//
//  RouteDetailsController.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/26/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate
{
    var location1:CLLocation?
    var routeDetails:[EditRoute]?
    let locationManager = CLLocationManager()
    var driverLoc: [DriverLocation]?
    var routeNumber: Int?
    var driverNumber: Int?
    var routeNo:Int?
    var customer:[Location]?
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var mapViewDisplay: MKMapView!
    var distanceMatrix = DistanceMatrixAPI()
    var distanceString:[String]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.routeNumber = UserDefaults.standard.integer(forKey: "RouteNumberForMap")
        self.driverNumber = UserDefaults.standard.integer(forKey: "DriverNumber")
        getDriverLoc(driverNo: self.driverNumber ?? 3)
        mapViewDisplay.layer.cornerRadius = 8
        mapViewDisplay.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
        mapViewDisplay.layer.borderWidth = 1
        getLocs(RouteNumber: self.routeNumber ?? 2)
        
        self.navigationController?.isNavigationBarHidden = false
        locationManager.delegate = self // Sets the delegate to self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // Sets the accuracy of the GPS to best in this case
        locationManager.requestAlwaysAuthorization() // Asks for permission
        locationManager.requestWhenInUseAuthorization() //Asks for permission when in use
        locationManager.startUpdatingLocation() //Updates location when moving
        mapViewDisplay.delegate = self
        mapViewDisplay.showsScale = true
        mapViewDisplay.showsUserLocation = true
        gettingLoc()
    }
    
    func gettingDistanceMatrix(route:[EditRoute]){
        let driverArr = driverLocForDistanceMatrix(xcoord: UserDefaults.standard.double(forKey: "xCoord"),ycoord: UserDefaults.standard.double(forKey: "yCoord"))
        let customers = route[0].Customer
        for customer in customers{
            let customerArr = driverLocForDistanceMatrix(xcoord: customer.Cust_Lat ?? 0, ycoord: customer.Cust_Log ?? 0)
            let urlString = distanceMatrix.URLGenForDistanceMatrixAPI(startPoint: driverArr, endPoint: customerArr)
            distanceMatrix.distanceMatrixAPICall(URLForUse: urlString){distanceMatrixReturn,error in
                if error == nil && distanceMatrixReturn?.rows[0].elements[0].distance.text != "" {
                    self.distanceString?.append(distanceMatrixReturn?.rows[0].elements[0].distance.text ?? "")
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    func driverLocForDistanceMatrix(xcoord:Double,ycoord:Double)->[Double]
    {
        var driverLocArray = [Double]()
        driverLocArray.append(xcoord)
        driverLocArray.append(ycoord)
        return driverLocArray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeDetails?[0].Customer.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "CustomerListCell") as! CustomerListCell
        cell.populateCell((self.routeDetails?[0].Customer[indexPath.row])!, distance: self.distanceString?[indexPath.row] ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: map stuff
    func mapThis(originCoordinate: CLLocationCoordinate2D, destinationCord : CLLocationCoordinate2D)
    {
        let soucePlaceMark = MKPlacemark(coordinate: originCoordinate) // Start point as coordinate
        let destPlaceMark = MKPlacemark(coordinate: destinationCord) // End point as coordinate
        
        let sourceItem = MKMapItem(placemark: soucePlaceMark) // Start point as placemark (MapItem)
        let destItem = MKMapItem(placemark: destPlaceMark)// Start point as placemark (MapItem)
        
        let destinationRequest = MKDirections.Request() // Initialises requests to apple Maps to get route
        destinationRequest.source = sourceItem // Requesting where to start from
        destinationRequest.destination = destItem // Requesting where to end
        destinationRequest.transportType = .automobile // Requesting what mode of transport is being used
        destinationRequest.requestsAlternateRoutes = true // Requesting Alternate Routes
        
        let directions = MKDirections(request: destinationRequest) //Initialsing the directions with the request
        directions.calculate { (response, error) in // Calculates route Using MKDirections
            //            error handling for unforseen problems such as User denying location access, or start point = end point etc.
            guard let response = response else {
                if error != nil {
                    print("Something is wrong :(")
                }
                return
            }
            
            let route = response.routes[0] // Retrieves useful information for plotting the route
            self.mapViewDisplay.addOverlay(route.polyline) // Creates route as a road map that is similar to that on google maps/ apple maps
            self.mapViewDisplay.setVisibleMapRect(route.polyline.boundingMapRect, animated: true) // Makes the route visible to user and animates it
        }
    }
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void )
    {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString){ (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    self.location1 = placemark.location!
                    completionHandler(self.location1?.coordinate ?? CLLocationCoordinate2D(), nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func createAnnot(locations:[[String: Any]])
    {
        for location in locations
        {
            let annot = MKPointAnnotation()
            annot.title = location["title"] as? String
            annot.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
            mapViewDisplay.addAnnotation(annot)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline) // Tells hardware what the render is going to look like
        render.strokeColor = .blue // Tells hardware what colour to make the render
        return render
    }
    
    func getLocs(RouteNumber: Int)
    {
        let url = baseURL + getRouteDetail + "?RouteNumber=" + String(self.routeNumber ?? 0)
        RestManager.APIData(url: url, httpMethod: RestManager.HttpMethod.post.self.rawValue, body: nil){
            (Data, Error) in
            if Error == nil{
                do {
                    self.routeDetails = try JSONDecoder().decode([EditRoute].self, from: Data as! Data )
                    self.driverNumber =  self.routeDetails?[0].Route.DriverId
                    self.getAllCoordsForRoute()
                    self.gettingDistanceMatrix(route: self.routeDetails ?? [EditRoute]())
//                    DispatchQueue.main.async {
//                        self.tableView.delegate = self
//                        self.tableView.dataSource = self
//                        self.tableView.reloadData()
//                    }
                    
                } catch let JSONErr{
                    print(JSONErr.localizedDescription)
                }
            }
        }
    }
    
    func createAddress(entry: Int)-> String
    {
        let streetAddress: String = (routeDetails?[0].Customer[entry].StreetAddress ?? "this was empty ")
        let city: String = (routeDetails?[0].Customer[entry].City) ?? " this was empty "
        let state: String = (routeDetails?[0].Customer[entry].State) ?? " this was empty "
        let ZIP = (routeDetails?[0].Customer[entry].Zip) ?? ""
        let Seperator: String = ", "
        
        let addressToGeocode: String = (streetAddress+Seperator+state+Seperator+city+Seperator+ZIP)
        return(addressToGeocode)
    }
    
    func getAllCoordsForRoute()
    {
        
        var addressToAdd = String()
        var coordsOfATA = [CLLocationCoordinate2D]()
        var ListOfAddresses = [String]()
        var coordToAppend = CLLocationCoordinate2D()
        for i in Range(0...((routeDetails?[0].Customer.count)!-1))
        {
            addressToAdd = createAddress(entry: i)
            ListOfAddresses.append(addressToAdd)
        }
        
        for j in ListOfAddresses
        {
            getCoordinate(addressString: j) { (CLLocationCoordinate2D, NSError) in
                coordToAppend = CLLocationCoordinate2D
                coordsOfATA.append(coordToAppend)
                if ListOfAddresses.count>0
                {
                    for k in coordsOfATA
                    {
                        let listOfDropOffs = [["title":"Pick Up Here!", "latitude":k.latitude, "longitude":k.longitude]]
                        self.createAnnot(locations: listOfDropOffs)
                        let geoFenceRegion = CLCircularRegion(center: k, radius: 100, identifier: "PickUp Location")
                        geoFenceRegion.notifyOnEntry = true
                        geoFenceRegion.notifyOnExit = true
                        self.locationManager.startMonitoring(for: geoFenceRegion)
                    }
                    
                    if coordsOfATA.count>1
                    {
                        for z in Range(0...coordsOfATA.count-2)
                        {
                            self.mapThis(originCoordinate: coordsOfATA[z], destinationCord: coordsOfATA[z+1])
                        }
                    }
                }
            }
        }
    }
    
    func getDriverLoc(driverNo: Int)
    {
        RestManager.APIData(url: baseURL + getDriverLocation + "?DriverId=" + String(driverNo), httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){
            (Data, Error) in
            if Error == nil{
                do {
                    self.driverLoc = try JSONDecoder().decode([DriverLocation].self, from: Data as! Data )
                    
                } catch let JSONErr{
                    print(JSONErr.localizedDescription)
                }
            }
        }
    }
    
    func makeDriverRealAgain() -> CLLocationCoordinate2D
    {
        var xCoord: Double = 0.0
        var yCoord: Double = 0.0
        if driverLoc?.count != 0{
            xCoord = driverLoc?[0].Lat ?? 0
            yCoord = driverLoc?[0].Log ?? 0
            UserDefaults.standard.set(xCoord, forKey: "xCoord")
            UserDefaults.standard.set(yCoord, forKey: "yCoord")
        } else {
            xCoord = UserDefaults.standard.double(forKey: "xCoord")
            yCoord = UserDefaults.standard.double(forKey: "yCoord")
        }
        let driverPoint: CLLocationCoordinate2D = CLLocationCoordinate2DMake(xCoord,yCoord)
        return driverPoint
    }
    
    func driverLocForDistanceMatrix()->[Double]
    {
        var driverLocArray = [Double]()
        driverLocArray.append(UserDefaults.standard.double(forKey: "xCoord"))
        driverLocArray.append(UserDefaults.standard.double(forKey: "yCoord"))
        return driverLocArray
    }
    
    func gettingLoc()
    {
        let delayTime = DispatchTime.now() + 5.0
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute:
            {
                self.getDriverLoc(driverNo: self.driverNumber ?? 0)
                self.helloDriver()
        })
    }
    
    func helloDriver()
    {
        let DL = self.makeDriverRealAgain()
        let locationOfDriver = [["title":"driver is here","latitude":DL.latitude,"longitude":DL.longitude]]
        let filteredAnnotations = mapViewDisplay.annotations.filter { annotation in
            if annotation is MKUserLocation { return false }          // don't remove MKUserLocation
            guard let title = annotation.title else { return false }  // don't remove annotations without any title
            return title == "driver is here"                             // remove those whose title does not match search string
        }
        self.createAnnot(locations: locationOfDriver)

        mapViewDisplay.removeAnnotations(filteredAnnotations)
        gettingLoc()
    }
    @IBAction func refreshDrivrLoc(_ sender: UIBarButtonItem)
    {
        self.getDriverLoc(driverNo: self.driverNumber ?? 0)
        self.helloDriver()
    }
    
}
