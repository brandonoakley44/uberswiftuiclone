//
//  UberMapViewRepresentable.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-21.
//

import Foundation
import SwiftUI
import MapKit

//Allows us to create a view using UIKit and represent that view using SwiftUI

struct UberMapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
    let locationManager = LocationManager.shared
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("DEBUG map state is \(mapState)")
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndCenterOnUserLocation()
            print("DEBUG: Drivers in map view \(homeViewModel.drivers)") // show drivers on map whhen map is just showing
            // Adding drivers to the map:
            context.coordinator.addDriversToMap(homeViewModel.drivers)
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedUberLocation?.coordinate {
                print("DEBUG: Coordinate is \(coordinate)")
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
                print("DEBUG: Selected coordinates in map view \(coordinate)")
            }
            break
        case .polylineAdded:
            break
        }
        
//        if let coordinate = locationViewModel.selectedLocationCoordinate {
//            context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
//            context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
//            print("DEBUG: Selected coordinates in map view \(coordinate)")
//        }
        
//        if mapState == .noInput {
//            context.coordinator.clearMapViewAndCenterOnUserLocation()
//        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
}

extension UberMapViewRepresentable {
    //MapCoordinator is basically a middleman between SwiftUI view and UIKit functionality
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        //MARK: - Properties
        
        let parent: UberMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        //MARK - Lifecycle
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //MARK - MKMapViewDelegate
        
        //delegate method (if user moves, updates the map area)
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            // delegate method tells the delegate that the location of the user was updated
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.currentRegion = region
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        //need this because I am using a custom annotation (for the drivers)
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                view.image = UIImage(systemName: "car.fill  ")
                    
                return view
            }
            return nil
        }
        
        //MARK - Helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            
            parent.mapView.removeAnnotations(parent.mapView.annotations) // remove old annotations before adding new one (markers on map)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno) // dont necessarily need to say self unless im in a block like a handler
            self.parent.mapView.selectAnnotation(anno, animated: true)
            
//            self.parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return}
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                // adjust the mapview when selecting a place
                let rect =  self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        //Clear the map view
        func clearMapViewAndCenterOnUserLocation() {
            //Remove all overlays, annotations, and centre map
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        
        func addDriversToMap(_ drivers: [User]) {
            let annotations = drivers.map({ DriverAnnotation(driver: $0) }) // commented code below does the same thing
//            for driver in drivers {
//                let driverAnno = DriverAnnotation(driver: driver)
//            }
            self.parent.mapView.addAnnotations(annotations)
        }
    }
}
