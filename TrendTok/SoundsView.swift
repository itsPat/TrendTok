//
//  HashtagsView.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/3/22.
//

import SwiftUI

struct SoundsView: View {
    @StateObject private var trendManager = TrendManager.shared
    
    var body: some View {
        VStack {
            if trendManager.trendingSounds.isEmpty {
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(trendManager.trendingSounds, id: \.id) { sound in
                            SoundRow(sound: sound)
                                .frame(maxWidth: .infinity, minHeight: 60.0, idealHeight: 60.0)
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .onAppear {
            trendManager.fetch( 
                .sound(
                    page: 1,
                    country: .us,
                    period: .last7,
                    ordering: .popular
                )
            )
        }
    }
}

struct SoundsView_Previews: PreviewProvider {
    static var previews: some View {
        SoundsView()
    }
}

struct SoundRow: View {
    
    let sound: TrendingSound
    
    var body: some View {
        Link(destination: URL(string: sound.urlString)!) {
            HStack(spacing: 16.0) {
                AsyncImage(
                    url: URL(string: sound.coverUrlString),
                    content: { image in
                        image
                            .resizable()
                            .frame(width: 60.0, height: 60.0, alignment: .center)
                            .aspectRatio(1.0, contentMode: .fit)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                            )
                    }, placeholder: {
                        ProgressView()
                    }
                )
                .frame(width: 60.0, height: 60.0, alignment: .center)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("#\(sound.rank) · " + sound.title)
                            .font(.callout.bold())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    HStack {
                        Text(sound.author)
                            .font(.subheadline.smallCaps())
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}
