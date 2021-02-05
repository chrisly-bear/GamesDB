//
//  Game.swift
//  gamesdb
//
//  Created by Christoph Schwizer on 01.02.21.
//

import Foundation
import UIKit

class Game {
    // initial number of games to display
    static let GAMES_COUNT = 10
    
    var title: String
    var description: String
    var releaseDate: Date
    var coverImage: UIImage
    var attachedImageView: UIImageView?
    
    init(title: String, description: String, releaseDate: Date, coverImage: UIImage) {
        self.title = title
        self.description = description
        self.releaseDate = releaseDate
        self.coverImage = coverImage
    }
    
    static func placeholder() -> Game {
        return Game(title: "Placeholder", description: "This is a placeholder game.", releaseDate: Date(), coverImage: #imageLiteral(resourceName: "placeholder"))
    }
    
    /// Update this Game with new data. Useful to replace placeholder data after fetching data from API.
    ///
    /// This will also update the attached ImageView (if one exists).
    ///
    /// - Parameters:
    ///   - new: Game containing the updated data.
    func update(new: Game) {
        self.title = new.title
        self.description = new.description
        self.releaseDate = new.releaseDate
        self.coverImage = new.coverImage
        if let iv = self.attachedImageView {
            iv.image = new.coverImage
        }
    }
}
