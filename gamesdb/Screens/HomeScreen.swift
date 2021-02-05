//
//  HomeScreen.swift
//  gamesdb
//
//  Created by Christoph Schwizer on 25.01.21.
//

import UIKit

class HomeScreen: UIViewController {
    
    let gamesProvider = IGDBProvider()
    var contentView: UIView!
    var popularGames: [Game] = {
        var array = [Game]()
        for i in 0...Game.GAMES_COUNT-1 { array.append(Game.placeholder()) }
        return array
    }()
    var justReleasedGames: [Game] = {
        var array = [Game]()
        for i in 0...Game.GAMES_COUNT-1 { array.append(Game.placeholder()) }
        return array
    }()
    var comingSoonGames: [Game] = {
        var array = [Game]()
        for i in 0...Game.GAMES_COUNT-1 { array.append(Game.placeholder()) }
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        
        let marginBetweenSections = CGFloat(28.0)
        
        var bottomAnchor = createSection(title: "Popular", games: popularGames, topAnchor: contentView.layoutMarginsGuide.topAnchor, topMargin: 0.0)
        bottomAnchor = createSection(title: "Just Released", games: justReleasedGames, topAnchor: bottomAnchor, topMargin: marginBetweenSections)
        bottomAnchor = createSection(title: "Coming Soon", games: comingSoonGames, topAnchor: bottomAnchor, topMargin: marginBetweenSections)
        bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -marginBetweenSections).isActive = true
        
        // fetch games from API
        gamesProvider.fetchJustReleasedGames { (_ games: [Game]) in
            for i in 0...games.count-1 {
                DispatchQueue.main.async {
                    self.justReleasedGames[i].update(new: games[i])
                }
            }
        }
    }
    
    private func createSection(title: String, games: [Game], topAnchor: NSLayoutYAxisAnchor, topMargin: CGFloat) -> NSLayoutYAxisAnchor {
        // title label
        let label = UILabel()
        contentView.addSubview(label)
        label.text = title
        label.font = .boldSystemFont(ofSize: 36.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: topMargin).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 8.0).isActive = true
        
        // horizontal scroll view
        let scrollView = UIScrollView()
        contentView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 180.0).isActive = true
        
        // content view
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        addGamesToContentView(games: games, toView: contentView)
        
        return scrollView.bottomAnchor
    }
    
    private func addGamesToContentView(games: [Game], toView contentView: UIView) {
        let marginBetweenGames = CGFloat(12.0)
        var previousImageView: UIImageView? = nil
        for game in games {
            let currentImageView = UIImageView(image: game.coverImage)
            game.attachedImageView = currentImageView
            contentView.addSubview(currentImageView)
            let tapRecognizer = ImageTapGestureRecognizer(target: self, action: #selector(tappedImage), game: game)
            currentImageView.addGestureRecognizer(tapRecognizer)
            currentImageView.isUserInteractionEnabled = true
            currentImageView.translatesAutoresizingMaskIntoConstraints = false
            currentImageView.contentMode = .scaleAspectFit
            currentImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
            currentImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            if let previousImageView = previousImageView {
                currentImageView.leadingAnchor.constraint(equalTo: previousImageView.trailingAnchor, constant: marginBetweenGames).isActive = true
            } else {
                // first image, position on left layout margin
                currentImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 8.0).isActive = true
            }
            // resize imageview to remove empty space
            currentImageView.widthAnchor.constraint(equalTo: currentImageView.heightAnchor, multiplier: currentImageView.image!.size.width / currentImageView.image!.size.height).isActive = true
            previousImageView = currentImageView
        }
        // last image, constrain to content view's trailing anchor
        previousImageView!.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8.0).isActive = true
    }

    @objc private func tappedImage(_ gestureRecognizer: ImageTapGestureRecognizer) {
        let game = gestureRecognizer.game
        self.present(DetailScreen(game: game), animated: true) {
            print("DetailScreen for game \"\(game.title)\" was opened")
        }
    }
    
    /// Custom UITapGestureRecognizer with additional parameters for passing information to the receiver.
    class ImageTapGestureRecognizer: UITapGestureRecognizer {
        let game: Game
        
        init(target: Any?, action: Selector?, game: Game) {
            self.game = game
            super.init(target: target, action: action)
        }
    }

}
