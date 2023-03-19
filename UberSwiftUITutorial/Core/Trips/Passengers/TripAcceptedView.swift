//
//  TripAcceptedView.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-03-18.
//

import SwiftUI

struct TripAcceptedView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            if let trip = viewModel.trip {
                // pick up info view
                VStack {
                    HStack {
                        Text("Meet your driver at \(trip.pickupLocationName) for your trip to \(trip.dropoffLocationName)")
                            .font(.body)
                            .frame(height: 44)
                            .lineLimit(2)
                            .padding(.trailing)
                        
                        Spacer()
                        
                        VStack {
                            Text("\(trip.travelTimeToPassenger)")
                                .bold()
                            
                            Text("min")
                                .bold()
                        }
                        .frame(width: 56, height: 56)
                        .foregroundColor(.white)
                    //    .padding()
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                    }
                    .padding()
                    
                    Divider()
                }
                
                //Driver info
                VStack {
                    HStack {
                        Image("male-profile-photo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trip.driverName)
                                .fontWeight(.bold)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(.systemYellow))
                                    .imageScale(.small)
                                
                                Text("4.8")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        
                        //driver vehicle info
                        VStack(alignment: .center) {
                            Image("uber-x")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 64)
                            
                            HStack {
                                Text("Mercedes S -")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                Text("GKZ 041")
                                    .font(.system(size:14, weight: .semibold))
                            }
                            .frame(width: 160)
                            .padding(.bottom)
                        }
                    }
                    
                    Divider()
                }
                .padding()
            }
        
 
            
            Button {
                print("DEBUG: Cancel trip")
            } label: {
                Text("CANCEL TRIP")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height:50)
                    .background(.red)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 26)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor ,radius: 20)
    }
}

struct TripAcceptedView_Previews: PreviewProvider {
    static var previews: some View {
        TripAcceptedView()
    }
}
