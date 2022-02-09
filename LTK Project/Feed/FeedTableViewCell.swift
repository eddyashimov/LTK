//
//  FeedTableCell.swift
//  LTK Challenge
//
//  Created by Edil Ashimov on 2/8/22.
//

import UIKit
import Nuke

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var profileImageViewContainer: UIView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    
    private let networkService = Network()
    
    // MARK: - Lifecycle
    override init(style: FeedTableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "feedCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.alpha = 0
        profileImageViewContainer.startShimmering()
        profileImageViewContainer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    // MARK: - Helpers
    func configureCell(with info: JSON.Item.Feed){
        captionLabel.text = info.caption
        setPoster(with: info)
    }
    
    private func setPoster(with item: JSON.Item.Feed) {
        guard let posterPath = item.heroImage else { return }
        let imageView = UIImageView()
        Nuke.loadImage(with: posterPath, into: imageView) { result in
            self.fadeIn(imageView.image)
        }
    }
    
    private func fadeIn(_ image: UIImage?) {
        profileImageView.image = image
        
        UIView.animate(withDuration: 0.25,
                       delay: 1.25,
                       options: [],
                       animations: {
            self.profileImageView.alpha = 1
            self.profileImageViewContainer.backgroundColor = UIColor.clear
        }, completion : { completed in
            if completed {
                self.profileImageViewContainer.stopShimmering()
            }
        })
    }
    
}
