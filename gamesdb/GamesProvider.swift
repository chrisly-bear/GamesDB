//
//  GamesProvider.swift
//  gamesdb
//
//  Created by Christoph Schwizer on 01.02.21.
//

import Foundation

protocol GamesProvider {
    
    func fetchPopularGames(completionHandler: (_ popularGames: [Game]) -> Void)
    
    func fetchJustReleasedGames(completionHandler: @escaping (_ justReleasedGames: [Game]) -> Void)
    
    func fetchComingSoonGames(completionHandler: (_ comingSoonGames: [Game]) -> Void)
    
    func searchGame(gameTitle: String, completionHandler: (_ searchResults: [Game]) -> Void)

}
