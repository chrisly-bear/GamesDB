//
//  HomeScreen.swift
//  gamesdb
//
//  Created by Christoph Schwizer on 25.01.21.
//

import UIKit

class HomeScreen: UIViewController {
    
    var contentView: UIView!
    
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
        
        let popularImages = [#imageLiteral(resourceName: "tombraider"), #imageLiteral(resourceName: "nfs"), #imageLiteral(resourceName: "maxpayne"), #imageLiteral(resourceName: "splintercell")]
        var bottomAnchor = createSection(title: "Popular", images: popularImages, topAnchor: contentView.layoutMarginsGuide.topAnchor, topMargin: 0.0)
        
        let justReleasedImages = [#imageLiteral(resourceName: "cyberpunk"), #imageLiteral(resourceName: "amnesia"), #imageLiteral(resourceName: "gta"), #imageLiteral(resourceName: "cod")]
        bottomAnchor = createSection(title: "Just Released", images: justReleasedImages, topAnchor: bottomAnchor, topMargin: marginBetweenSections)
        
        let comingSoonImages = [#imageLiteral(resourceName: "splintercell"), #imageLiteral(resourceName: "hitman"), #imageLiteral(resourceName: "tombraider"), #imageLiteral(resourceName: "cod")]
        bottomAnchor = createSection(title: "Coming Soon", images: comingSoonImages, topAnchor: bottomAnchor, topMargin: marginBetweenSections)
        
        bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -marginBetweenSections).isActive = true
    }
    
    private func createSection(title: String, images: [UIImage], topAnchor: NSLayoutYAxisAnchor, topMargin: CGFloat) -> NSLayoutYAxisAnchor {
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
        addImagesToContentView(images: images, toView: contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        return scrollView.bottomAnchor
    }
    
    private func addImagesToContentView(images: [UIImage], toView contentView: UIView) {
        let marginBetweenGames = CGFloat(12.0)
        var previousImageView: UIImageView? = nil
        for image in images {
            let currentImageView = UIImageView(image: image)
            contentView.addSubview(currentImageView)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
