//
//  LoginView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @ObservedObject var loginManager : LoginManager
    
    var body: some View {
            VStack {
                
                Spacer()
                //                Image("logo")
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fit)
                //                    .frame(width: 200, height: 200)
                //                    .padding()
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8.0)
                
                Button(action: {
                    // Perform login action here
                    loginManager.login()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
        }
    
}

