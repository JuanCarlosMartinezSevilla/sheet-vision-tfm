//
//  PopupView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 16/5/23.
//

import SwiftUI

struct PopupView: View {
    var body: some View {
        VStack (spacing: .zero) {
            icon
            title
            content
            
        }.padding()
            .multilineTextAlignment(.center)
            .background(.pink)
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView()
    }
}

private extension PopupView {
    var icon: some View {
  Image (systemName: "info")
    .symbolVariant(.circle.fill)
    .font (.system(size: 50,
    weight: .bold,
                  design: .rounded)
    )
    .foregroundStyle(.white)
           }
           
    var title: some View {
    Text ("You can just save one picture")

    .font (
    .system(size: 30,
    weight: .bold,
    design: .rounded)
    )
 
    .padding ()
    }
    
    var content: some View {
    Text ("Delete the ones that you are not using")
    .font (.callout)
    .foregroundColor(.black.opacity(0.8))
          }
          
}
