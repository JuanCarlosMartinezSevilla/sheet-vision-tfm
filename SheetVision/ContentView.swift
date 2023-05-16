//
//  ContentView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI
import CoreData

class LoginManager : ObservableObject {
    //@Published var isLoggedIn = false
    @Published var isLoggedIn = true
    
    func login() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                self.isLoggedIn = true
            }
        }
    }
}

struct ContentView : View {
    @StateObject var loginManager = LoginManager()
    
    var body: some View {
        if loginManager.isLoggedIn {
            MainTripleSplitView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .leading))
        } else {
            LoginView(loginManager: loginManager)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .leading))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
