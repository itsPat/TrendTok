//
//  TrendManager.swift
//  TrendTok
//
//  Created by Pat Trudel on 7/2/22.
//

import Foundation
import Combine

enum TrendManagerError: Error {
    case dataNotFound
}

final class TrendManager: NSObject, ObservableObject {
    
    
    static let shared = TrendManager()
    private override init() { super.init() }
    
    @Published var trendingHashtags: [TrendingHashtag] = []
    @Published var trendingSounds: [TrendingSound] = []
    @Published var isLoading: Bool = false
    
    private var cancellable: Set<AnyCancellable> = []
    
    func fetch(_ route: Route, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let request = route.request else { return }
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                // Reject non-200 status codes.
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                // Extract only the data we need from JSON.
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let jsonData = json["data"] as? [String: Any] else { throw TrendManagerError.dataNotFound }
                
                var jsonList: [[String: Any]]?
                
                // Extract only the list data from the JSON.
                switch route {
                case .hashtag:
                    jsonList = jsonData["list"] as? [[String: Any]]
                case .sound:
                    jsonList = jsonData["sound_list"] as? [[String: Any]]
                }
                
                // Convert back into data for decoding.
                guard let jsonList = jsonList else { throw TrendManagerError.dataNotFound }
                do {
                    let listData = try JSONSerialization.data(withJSONObject: jsonList)
                    return listData
                } catch let err {
                    throw err
                }
            }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished:
                        self?.isLoading = false
                    case .failure(let err):
                        completion(err)
                    }
                },
                receiveValue: { [weak self] data in
                    do {
                        switch route {
                        case .hashtag:
                            let trendingHashtags = try JSONDecoder().decode([TrendingHashtag].self, from: data)
                            
                            if route.page == 1 {
                                self?.trendingHashtags = trendingHashtags
                            } else {
                                self?.trendingHashtags += trendingHashtags
                            }
                        case .sound:
                            let trendingSounds = try JSONDecoder().decode([TrendingSound].self, from: data)
                            
                            if route.page == 1 {
                                self?.trendingSounds = trendingSounds
                            } else {
                                self?.trendingSounds += trendingSounds
                            }
                        }
                    } catch {
                        completion(error)
                    }
                }
            )
            .store(in: &cancellable)
    }
    
}
