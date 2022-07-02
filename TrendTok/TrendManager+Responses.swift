//
//  TrendManager+Responses.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/2/22.
//

import Foundation

struct ListResponse<T: Codable>: Codable {
    let list: [T]
}

struct SoundListResponse<T: Codable>: Codable {
    let list: [T]
    
    enum CodingKeys: String, CodingKey {
        case list = "sound_list"
    }
}
