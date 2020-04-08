//
//  RouteDetailsController.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/26/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailsController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.layer.cornerRadius = 8
        mapView.layer.borderColor = UIColor.init(red: 128/255, green: 25/255, blue: 50/255, alpha: 1).cgColor
        mapView.layer.borderWidth = 1
        
        let initialLocation = CLLocation(latitude: 40.000, longitude: -75.21943)
        let regionRadius: CLLocationDistance = 12000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: initialLocation)
        
        let artwork = Artwork(title: "Merakey Germantown",
                              locationName: "Merakey Germantown",
                              discipline: "",
                              coordinate: CLLocationCoordinate2D(latitude: 40.03337, longitude: -75.171005))
        let artwork2 = Artwork(title: "New Directions (Adolescents)",
                              locationName: "New Directions (Adolescents)",
                              discipline: "",
                              coordinate: CLLocationCoordinate2D(latitude: 39.978996, longitude: -75.21943))
        let artwork3 = Artwork(title: "Merakey Parkside",
                              locationName: "Merakey Parkside",
                              discipline: "",
                              coordinate: CLLocationCoordinate2D(latitude: 39.979996, longitude: -75.21943))
        let artwork4 = Artwork(title: "Re-Enter",
                              locationName: "Re-Enter",
                              discipline: "",
                              coordinate: CLLocationCoordinate2D(latitude: 39.960274, longitude: -75.19033))
        mapView.addAnnotation(artwork)
        mapView.addAnnotation(artwork2)
        mapView.addAnnotation(artwork3)
        mapView.addAnnotation(artwork4)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier  = String(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
