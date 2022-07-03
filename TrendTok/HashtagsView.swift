//
//  HashtagsView.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/3/22.
//

import SwiftUI

struct HashtagsView: View {
    @StateObject private var trendManager = TrendManager.shared
    
    var body: some View {
        VStack {
            if trendManager.trendingHashtags.isEmpty {
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 10.0) {
                        HStack {
                            Spacer()
                            
                            Button {
                                let strings = trendManager.trendingHashtags.prefix(10).map {
                                    "#"+$0.name
                                }
                                UIPasteboard.general.string = strings.joined(separator: " ")
                            } label: {
                                Text("✨ Copy top 10 hashtags! ✨")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                        }
                        .frame(height: 44, alignment: .center)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(.sRGBLinear, red: 167.0/255.0, green: 113.0/255.0, blue: 255.0/255.0, opacity: 1.0),
                                    Color(.sRGBLinear, red: 252.0/255.0, green: 92.0/255.0, blue: 255.0/255.0, opacity: 1.0),
                                    Color(.sRGBLinear, red: 255.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, opacity: 1.0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 22.0)
                            )
                        )
                        
                        
                        ForEach(trendManager.trendingHashtags, id: \.id) { hashtag in
                            Button {
                                UIPasteboard.general.string = "#" + hashtag.name
                            } label: {
                                HStack(spacing: 16) {
                                    Text("\(hashtag.rank)")
                                        .font(.system(size: 36))
                                        .fontWeight(.black)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text("#" + hashtag.name)
                                        .font(.system(size: 18))
                                        .italic()
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                    
                                    TrendView(trendData: hashtag.trend)
                                        .frame(width: 80, height: 30, alignment: .trailing)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
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

struct HashtagsView_Previews: PreviewProvider {
    static var previews: some View {
        HashtagsView()
    }
}
