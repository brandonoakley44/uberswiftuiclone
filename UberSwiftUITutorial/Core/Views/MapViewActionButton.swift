//
//  MapViewActionButton.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-23.
//

import SwiftUI

struct MapViewActionButton: View {
    
   // @Binding var showLocationSearchView: Bool
    @Binding var mapState: MapViewState
    @Binding var showSideMenu: Bool
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        //align to leading edge:
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
           // authViewModel.signout()
            showSideMenu.toggle()
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .polylineAdded:
            mapState = .noInput
            viewModel.selectedUberLocation = nil
            print( "DEBUG Clear Map View")
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected, .polylineAdded:
            return "arrow.left"
        default:
            return "line.3.horizontal"
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput), showSideMenu: .constant(false))
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
    }
}
