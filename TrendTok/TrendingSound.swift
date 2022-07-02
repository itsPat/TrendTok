//
//  TrendingSound.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/2/22.
//

import Foundation

struct TrendingSound: Codable {
    let id: String
    let rank: Int
    let title: String
    let author: String
    let coverUrlString: String
    let urlString: String
    let trend: [TrendPoint]
    
    private enum CodingKeys: String, CodingKey {
        case rank, title, author, trend
        case id = "song_id"
        case coverUrlString = "cover"
        case urlString = "link"
    }
}

