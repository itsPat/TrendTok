//
//  TrendingHashtag.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/2/22.
//

import Foundation

struct TrendingHashtag: Codable {
    let id: String
    let rank: Int
    let name: String
    let industryInfo: IndustryInfo?
    let trend: [TrendPoint]
    
    private enum CodingKeys: String, CodingKey {
        case rank, trend
        case id = "hashtag_id"
        case name = "hashtag_name"
        case industryInfo = "industry_info"
    }
}

