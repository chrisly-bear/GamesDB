//
//  IGDBProvider.swift
//  gamesdb
//
//  Created by Christoph Schwizer on 01.02.21.
//

import Foundation
import UIKit

struct IGDBProvider: GamesProvider {
    
    // TODO: insert your IGDB API keys
    let CLIENT_ID = ""
    let CLIENT_SECRET = ""
    
    let decoder = JSONDecoder()
    
    // MARK: - GamesProvider implementations
    
    func fetchPopularGames(completionHandler: ([Game]) -> Void) {
        // TODO: implement
    }
    
    func fetchJustReleasedGames(completionHandler: @escaping ([Game]) -> Void) {
        var games = [Game]()
        getAuthToken { (token, error) in
            guard let token = token else {
                print("Encountered error while retrieving the auth token: \(error!)")
                return
            }
            let nowTimestamp = Int(Date().timeIntervalSince1970.rounded())
            let request = buildIGDBRequest(
                endpoint: "https://api.igdb.com/v4/games",
                query: "fields id,name,summary,first_release_date,cover; limit \(Game.GAMES_COUNT); where first_release_date < \(nowTimestamp); sort first_release_date desc;",
                token: token)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("Encountered error while retrieving 'just released' games: \(error!)")
                    return
                }
                let igdbGames = try! decoder.decode([IGDBGame].self, from: data)
                var gameIds = [String]()
                for igdbGame in igdbGames {
                    gameIds.append("game = \(igdbGame.id)")
                }
                let query = "fields game,image_id; where \(gameIds.joined(separator: "|"));"
                let request = buildIGDBRequest(endpoint: "https://api.igdb.com/v4/covers", query: query, token: token)
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data else {
                        print("Encountered error while retrieving 'just released' cover: \(error!)")
                        return
                    }
                    let covers = try! decoder.decode([IGDBCover].self, from: data)
                    for cover in covers {
                        let igdbGame = igdbGames.first { (g) in g.id == cover.game }!
                        let game = Game(title: igdbGame.name, description: igdbGame.summary, releaseDate: Date(timeIntervalSince1970: TimeInterval(igdbGame.first_release_date)), coverImage: cover.image!)
                        games.append(game)
                    }
                    games.sort(by: { g1, g2 in g1.releaseDate > g2.releaseDate })
                    completionHandler(games)
                }.resume()
            }.resume()
        }
    }
    
    func fetchComingSoonGames(completionHandler: ([Game]) -> Void) {
        // TODO: implement
    }
    
    func searchGame(gameTitle: String, completionHandler: ([Game]) -> Void) {
        // TODO: implement
    }
    
    // MARK: - helper functions
    
    func getAuthToken(completionHandler: @escaping (_ token: String?, Error?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "id.twitch.tv"
        components.path = "/oauth2/token"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: CLIENT_ID),
            URLQueryItem(name: "client_secret", value: CLIENT_SECRET),
            URLQueryItem(name: "grant_type", value: "client_credentials")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error!)
                return
            }
            let token = try! decoder.decode(IGDBTokenResponse.self, from: data)
            completionHandler(token.access_token, nil)
        }
        task.resume()
    }
    
    func buildIGDBRequest(endpoint: String, query: String, token: String) -> URLRequest {
        let url = URL(string: endpoint)!
        var request = URLRequest.init(url: url)
        request.httpBody = query.data(using: .utf8, allowLossyConversion: false)
        request.httpMethod = "POST"
        request.setValue(CLIENT_ID, forHTTPHeaderField: "Client-ID")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
}

// MARK: - structs

struct IGDBTokenResponse: Codable {
    let access_token: String
    let expires_in: Int
    let token_type: String
}

struct IGDBGame: Codable {
    let id: Int
    let name: String
    let summary: String
    let first_release_date: Int
    let cover: Int
}

struct IGDBCover: Codable {
    let game: Int
    let image_id: String
    var url: String {
        return "https://images.igdb.com/igdb/image/upload/t_cover_big/\(image_id).jpg"
    }
    var image: UIImage? {
        let data = try? Data(contentsOf: URL(string: url)!)
        if let data = data {
            return UIImage(data: data)
        }
        return nil
    }
}
