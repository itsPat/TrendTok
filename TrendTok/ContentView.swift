//
//  ContentView.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/2/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HashtagsView()
                .tabItem {
                    Label("Hashtags", systemImage: "number")
                }
            SoundsView()
                .tabItem {
                    Label("Sounds", systemImage: "waveform")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
