//
//  ContentView.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/2/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var trendManager = TrendManager.shared
    
    var body: some View {
        VStack {
            if trendManager.trendingHashtags.isEmpty {
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(trendManager.trendingHashtags, id: \.id) { hashtag in
                            Text(hashtag.name)
                        }
                    }
                }
            }
        }
        .onAppear {
            trendManager.fetch(
                .hashtag(
                    page: 1,
                    country: .us,
                    period: .last7,
                    industry: nil
                )
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
