//
//  AddCollectionView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 15/5/23.
//

import SwiftUI

struct AddCollectionView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var colDescription = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Collection name", text: $name)
                }

                Section {
                    TextField("Description", text: $colDescription)
                    
                }

                Section {
                    Button("Save") {
                        
                        let newCollection = Collection(context: moc)
                        newCollection.id = UUID()
                        newCollection.name = name
                        newCollection.colDescription = colDescription
                        
                        try? moc.save()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Collection")
        }
    }
}

struct AddCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddCollectionView()
    }
}
