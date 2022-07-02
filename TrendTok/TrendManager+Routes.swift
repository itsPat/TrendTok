//
//  TrendManager+Routes.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/2/22.
//

import Foundation

extension TrendManager {
    
    enum Route {
        case hashtag(page: Int = 1, country: Country = .us, period: Period = .last7, industry: Industry? = nil)
        case sound(page: Int = 1, country: Country = .us, period: Period = .last7, ordering: Ordering = .popular)
        
        /// MARK: - Nested ROUTE enums
        enum Country: String {
            case us
        }
        
        enum Period: Int {
            case last7 = 7
            case last30 = 30
            case last90 = 90
        }
        
        enum Ordering: String {
            case popular, surging
        }
        
        enum Industry: Int {
            case tech
        }
        
        var stringValue: String {
            switch self {
            case .hashtag: return "hashtag"
            case .sound: return "sound"
            }
        }
        
        var path: String {
            "/\(stringValue)/list"
        }
        
        var page: Int {
            switch self {
            case .hashtag(let page, _, _, _),
                    .sound(let page, _, _, _):
                return page
            }
        }
        
        var request: URLRequest? {
            let baseUrlString = "https://ads.tiktok.com/creative_radar_api/v1/popular_trend"
            var components = URLComponents(string: baseUrlString + path)
            switch self {
            case .sound(let page, let country, let period, let ordering):
                components?.queryItems = [
                    URLQueryItem(name: "period", value: period.rawValue.formatted()),
                    URLQueryItem(name: "limit", value: "20"),
                    URLQueryItem(name: "page", value: page.formatted()),
                    URLQueryItem(name: "country_code", value: country.rawValue.uppercased()),
                    URLQueryItem(name: "rank_type", value: ordering.rawValue)
                ]
            case .hashtag(let page, let country, let period, let industry):
                components?.queryItems = [
                    URLQueryItem(name: "period", value: period.rawValue.formatted()),
                    URLQueryItem(name: "limit", value: "20"),
                    URLQueryItem(name: "page", value: page.formatted()),
                    URLQueryItem(name: "region", value: country.rawValue.uppercased()),
                    URLQueryItem(name: "country_code", value: country.rawValue.uppercased()),
                    URLQueryItem(name: "country_code", value: country.rawValue.uppercased()),
                    URLQueryItem(name: "industry_id", value: industry?.rawValue.formatted())
                ]
            }
            
            guard let url = components?.url else { return nil }
            var request = URLRequest(url: url)
            request.setValue("6895f956c8244a4686c342ab314f122e", forHTTPHeaderField: "anonymous-user-id")
            return request
        }
    }
    
}
