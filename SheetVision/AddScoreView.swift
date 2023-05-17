//
//  AddScoreView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 15/5/23.
//

import SwiftUI

struct AddScoreView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var author = ""
    var collection : Collection?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Score title", text: $name)
                }

                Section {
                    TextField("Author", text: $author)
                }

                Section {
                    Button("Save") {
                        
                        let newScore = Score(context: moc)
                        newScore.id = UUID()
                        newScore.name = name
                        newScore.author = author
                        newScore.collection = collection
                        
                        try? moc.save()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Score")
        }
    }
}

struct AddScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddScoreView()
    }
}
