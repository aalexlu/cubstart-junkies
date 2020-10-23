//
//  MapViewController.swift
//  Junkies
//
//  Created by Alex Lu on 10/18/20.
//  Copyright © 2020 Alexandra Lu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    /** IBOutlets for MKMapView and labels */
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    /** Variables for basic location */
    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    /** Variables for the closest location; set in findNearest based on best result */
    var closestLocation : CLLocation? = nil
    var minDistance : CLLocationDistance = 0.0
    var closestLocationAddress = ""
    /** Variable for locationName based on button pressed in VC; used for request, search, annotation */
    var locationName = ""
    
    /** viewDidLoad */
    override func viewDidLoad() {
        super.viewDidLoad()
        locateMe()
    }
    
    /** locateMe performed in viewDidLoad */
    func locateMe() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
    }
    
    /** didUpdateLocations sets mapView region based on the userLocation and a span; calls findNearest */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocation = locations[0]
        let coordinates = CLLocationCoordinate2D(latitude: self.userLocation.coordinate.latitude, longitude: self.userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
        findNearest()
    }
    
    /** findNearest creates the search request and sets the closestLocation based on the locationName and userLocation; calls addAnnotation and updateView */
    func findNearest() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "\(locationName)"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            if error != nil {
                print("An error occurred")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                print(self.userLocation)
                for place in response!.mapItems {
                    print(place.placemark.coordinate.latitude)
                    print(place.placemark.coordinate.longitude)
                    let placemark = CLLocation(latitude: place.placemark.coordinate.latitude, longitude: place.placemark.coordinate.longitude)
                    if self.closestLocation == nil || self.minDistance > self.userLocation.distance(from: placemark) {
                        self.closestLocation = placemark
                        self.minDistance = self.userLocation.distance(from: placemark)
                        self.closestLocationAddress = place.placemark.subThoroughfare! + " " + place.placemark.thoroughfare! + " " + place.placemark.locality! + " " + place.placemark.administrativeArea!
                    }
                }
                self.addAnnotation()
                self.updateView()
            }
        })
    }
    
    /** Adds an annotation at the closestLocation; based on locationName */
    func addAnnotation() {
        let anno = MKPointAnnotation()
        anno.coordinate = self.closestLocation!.coordinate
        anno.title = "\(locationName)"
        mapView.addAnnotation(anno)
    }
    
    /** Updates the label IBOutlets of the address and distance; based on the newly found closestLocation in findNearest*/
    func updateView() {
        addressLabel.text = closestLocationAddress
        distanceLabel.text = "\(minDistance) meters"
    }

    /** IBAction for the "Open In Maps" button; opens the Apple maps application with the path from the userLocation to the closestLocation */
    @IBAction func openInMaps(_ sender: Any) {
        let coords = closestLocation!.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coords))
        mapItem.name = "\(locationName)"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
