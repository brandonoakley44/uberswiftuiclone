//
//  LocationManager.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-21.
//

import CoreLocation


// I cant ask for location through MapView, I have to use CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    static let shared = LocationManager()  //static similar to environment object
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //call in order for app to request usr location
        locationManager.startUpdatingLocation()
    }
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // guard !locations.isEmpty else { return }//
        guard let location = locations.first else { return }
        self.userLocation = location.coordinate
        locationManager.stopUpdatingLocation() // only have to get location here once, MapView file will handle update
    }
}
