//
//  MainTripleSplitView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI

struct MainTripleSplitView: View, Hashable {
    var body: some View {
        NavigationSplitView {
            CollectionsView()
        } content: {
            ScoresView()
        } detail: {
            PagesView()
        }
    }
}

struct MainTripleSplitView_Previews: PreviewProvider {
    static var previews: some View {
        MainTripleSplitView()
    }
}
