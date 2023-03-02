//
//  LoginView.swift
//  UberSwiftUITutorial
//
//  Created by Brandon Oakley on 2023-02-27.
//

import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        //NOTE: they are deprecating NavigationView wrapper
        //Simply set Deployment target for now to remove app
        NavigationStack {
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                
                VStack {
                    
                    //Image and title
                    
                    VStack(spacing: 20) {   // -16 in tutorial, I have box around it
                        //Image
                        Image("uber-app-icon")
                            .resizable()
                            .frame(width: 200, height: 200)
                            //.scaledToFill()
                        //Title
                        Text("UBER")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    
                    //input fields
                    VStack(spacing: 32) {
                        // Input field 1
                        CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                        //Input field 2
                        CustomInputField(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        //Forgot password
                        Button {
                            
                        } label: {
                            Text("Forgot Password?")
                                .font(.system(size:13, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.top)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                       // .padding(.trailing,20)

                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    //social sign in view
                    VStack {
                        // Dividers + Text
                        HStack(spacing: 24) {
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.white)
                                .opacity(0.5)
                            
                            Text("Sign in with social")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            
                            Rectangle()
                                .frame(width: 76, height: 1)
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                        // Signup buttons
                        HStack(spacing: 24) {
                            //facebook button
                            Button {
                                
                            } label: {
                                
                                Image("facebook-signin-icon")
                                    .resizable()
                                    .frame(width:44, height: 44)
                            }
                            
                            //google button
                            Button {
                                
                            } label: {
                                Image("google-signin-icon")
                                    .resizable()
                                    .frame(width:44, height: 44)
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    //sign in button
                    
                    Button {
                        viewModel.signIn(withEmail: email, password: password)
                    } label: {
                        HStack {
                            Text("SIGN IN")
                                .foregroundColor(.black)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    .background(Color.white)
                    .cornerRadius(10)

                    //sign up button
                    
                    Spacer()
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)// bc implemented own back button
                    } label: {
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size: 14))
                            
                            Text("Sign Up")
                                .font(.system(size:14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.bottom, 3)
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}
