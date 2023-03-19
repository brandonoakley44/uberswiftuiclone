//
//  HomeViewModel.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-07.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine
import MapKit

class HomeViewModel: NSObject, ObservableObject {
    
    //MARK - Properties
    
    @Published var drivers = [User]()
    @Published var trip: Trip?
    
    private let service = UserService.shared
    //var currentUser: User?
    private var cancellables = Set<AnyCancellable>()        //combine has to be able to store the value somewhere
    private var currentUser: User?
    
    //Location Search Properties
    @Published var results = [MKLocalSearchCompletion]()    // Initialize as blank array of results
   // @Published var selectedLocationCoordinate: CLLocationCoordinate2D? // initialize as a nil string as user needs to populate it first
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }  // what searchCompleter uses to search for all of those locations
    
    
    // MARK - lifecycle
    override init() {
        super.init()
        fetchUser()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    
    //MARK - User API
    
  
    
    
    func fetchUser() {
        service.$user
            .sink { user in
                self.currentUser = user
                guard let user = user else {return }
              //  self.currentUser = user
              //  guard user.accountType == .passenger else { return }
                if user.accountType == .passenger {
                    self.fetchDrivers()
                    self.addTripObserverForPassenger()  //automatically subscribes to a trip when passenger requests one
                } else {
                    self.fetchTrips()
                }
            }
            .store(in: &cancellables)
            
    }
    
}

//MARK: - Passenger API
extension HomeViewModel {
    
    func addTripObserverForPassenger() {
        guard let currentUser = currentUser, currentUser.accountType == .passenger else { return }
        
        Firestore.firestore().collection("trips").whereField("passengerUid", isEqualTo: currentUser.uid).addSnapshotListener { snapshot, _ in
            guard let change = snapshot?.documentChanges.first, change.type == .added || change.type == .modified else { return }
            
            guard let trip = try? change.document.data(as: Trip.self) else { return }
            self.trip = trip
            print("DEBUG: Updated trip state is \(trip.state)")
        }
    }
    
    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {return }
                
                let drivers = documents.compactMap({ try?  $0.data(as: User.self) }) // handles non-optional
               self.drivers = drivers //   make it set to the publishable var above so the UberMapView Representable can see them
            }
    }
    
    
    func requestTrip() {
        guard let driver = drivers.first else { return }
        guard let currentUser = currentUser else { return  }
        guard let dropoffLocation = selectedUberLocation else { return }
        let dropoffGeoPoint = GeoPoint(latitude: dropoffLocation.coordinate.latitude, longitude: dropoffLocation.coordinate.longitude)
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)
       
        
        getPlacemark(forLocation: userLocation) { placemark, error in
            guard let placemark = placemark else { return }
            
            let tripCost = self.computeRidePrice(forType: .uberX)
    
            let trip = Trip(
                //id: NSUUID().uuidString,
                passengerUid: currentUser.uid,
                driverUid: driver.uid,
                passengerName: currentUser.fullName,
                driverName: driver.fullName,
                passengerLocation: currentUser.coordinates,
                driverLocation: driver.coordinates,
                pickupLocationName: placemark.name ?? "Current Location",
                dropoffLocationName: dropoffLocation.title,
                pickupLocationAddress: self.addressFromPlacemark(placemark),
                pickupLocation: currentUser.coordinates,
                dropoffLocation: dropoffGeoPoint ,
                tripCost: tripCost,
                distanceToPassenger: 0,
                travelTimeToPassenger: 0,
                state: .requested
            )
            
            
            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else { return }
            Firestore.firestore().collection("trips").document().setData(encodedTrip) { _ in
                print("DEBUG: Did upload trip to firestore")
            }
            
        }
    }
}


//MARK: - Driver  API
extension HomeViewModel {
    func fetchTrips() {
        guard let currentUser = currentUser else { return }
        
        Firestore.firestore().collection("trips").whereField("driverUid", isEqualTo: currentUser.uid)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents, let document = documents.first else { return }
                guard let trip = try? document.data(as: Trip.self) else { return }
                self.trip = trip
                
                self.getDestinationRoute(from: trip.driverLocation.toCoordinate(), to: trip.pickupLocation.toCoordinate()) { route in
                self.trip?.travelTimeToPassenger = Int(route.expectedTravelTime / 60)
                self.trip?.distanceToPassenger = route.distance
                }
            }
    }
    
    func rejectTrip() {
        updateTripState( state: .rejected)
    }
    
    func acceptTrip() {
        updateTripState( state: .accepted)
    }
    
    private func updateTripState( state: Trip.TripState) {
        guard let trip = trip else { return }
        
        var data = ["state": state.rawValue]
        
        if state == .accepted {
            data["travelTimeToPassenger"] =  trip.travelTimeToPassenger
        }
        
        Firestore.firestore().collection("trips").document(trip.id).updateData(
            data
        ) { _ in
            print("DEBUG: Did update trip with state \(state)")
        }
    }
    
}

//MARK: - Location Search Helpers


extension HomeViewModel {
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        
        if let thoroughfare = placemark.thoroughfare {  // thoroughfare is street address
            result += thoroughfare
        }
        
        if let subthoroughfare = placemark.subThoroughfare {
            result += " \(subthoroughfare)"
        }
        
        if let subadministrativearea = placemark.subAdministrativeArea {
            result += ", \(subadministrativearea)"
        }
        
        return result
    }
    
    //reverse geocoding
    func getPlacemark(forLocation location: CLLocation, completion: @escaping(CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }
    
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            
            switch config {
            case .ride:
                self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
            case .saveLocation(let viewModel):
                guard let uid = Auth.auth().currentUser?.uid else { return }    // do it this way bc dont have access to user view model in this file
                let savedLocation = SavedLocation(title: localSearch.title, address: localSearch.subtitle, coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                guard let encodedLocation =  try? Firestore.Encoder().encode(savedLocation) else { return }
                Firestore.firestore().collection("users").document(uid).updateData([
                    viewModel.databaseKey: encodedLocation
                ])
            }
        }
    }
    
    // MKLocalSearchCompletion doesn't give me any coordinate data, so I need to use a search request for a location object
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion) // handler is the locationsearch above in selectLocation function (the response is there)
    }
    
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let destCoordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCoordinate = self.userLocation else { return 0.0 }
        
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        
        let destination = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)
        
        let tripDistanceInMeters = userLocation.distance(from: destination)
        
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void) {
        
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG Failed to get directions with error \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    
    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results    // most recently received search completion
    }

}
