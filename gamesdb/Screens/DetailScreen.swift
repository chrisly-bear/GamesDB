//
//  DetailScreen.swift
//  gamesdb
//
//  Created by Christoph Schwizer on 29.01.21.
//

import UIKit

class DetailScreen: UIViewController {
    
    let gameId: String
    
    init(gameId: String) {
        self.gameId = gameId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        
        let label = UILabel()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Game Details (game ID: \(gameId))"
        
        // constraints
        label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
    }

}
