//
//  ScoresView.swift
//  SheetVision
//
//  Created by Juan Carlos Martínez Sevilla on 4/5/23.
//

import SwiftUI

struct MusicScore: Identifiable {
    let id = UUID()
    let name: String
}

struct ScoresView: View {
    
    let musicScores = ["Moon River", "My Favorite Things", "Fly Me to the Moon", "Autumn Leaves", "The Girl from Ipanema", "Take Five", "All the Things You Are", "Summertime"]
    
    var randomScores: [MusicScore] {
        var scores = [MusicScore]()
        for i in 1...5 {
            let randomIndex = Int.random(in: 0..<musicScores.count)
            let randomName = musicScores[randomIndex]
            let score = MusicScore(name: "\(randomName) Score \(i)")
            scores.append(score)
        }
        return scores
    }
    
    var body: some View {
        List(randomScores) { score in
            NavigationLink(score.name) {
                PagesView()
            }
        }.toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Text("Add score")
                } label: {
                    Label("Add score", systemImage: "plus")
                }
            }
        }
            
            .navigationBarTitle("Scores")
        }
    }
    
    struct ScoresView_Previews: PreviewProvider {
        static var previews: some View {
            ScoresView()
        }
    }
