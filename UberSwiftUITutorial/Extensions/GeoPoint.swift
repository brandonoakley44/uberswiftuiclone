//
//  GeoPoint.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-11.
//

import Firebase
import CoreLocation

extension GeoPoint {
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }

}
