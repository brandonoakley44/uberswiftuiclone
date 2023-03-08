//
//  DriverAnnotation.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-07.
//

import Foundation
import MapKit
import Firebase

class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let uid: String
    
    
    init(driver: User) {
        self.uid = driver.uid
        self.coordinate = CLLocationCoordinate2D(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
    }
}
