//
//  LocationSearchResultsView.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-05.
//

import SwiftUI

struct LocationSearchResultsView: View {
    
    @StateObject var viewModel: HomeViewModel
    let config: LocationResultsViewConfig
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.results, id:\.self) { result in
                    LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                viewModel.selectLocation(result, config: config)
    //                            mapState = .locationSelected // because settings page doesn't need to know anything about the map state (no sense in having this component tightly coupled with map
                            }
                        }
                }
            }
        }
    }
}


