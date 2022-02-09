//
//  FeedDetail.swift
//  LTK Challenge
//
//  Created by Edil Ashimov on 2/8/22.
//

import UIKit
import SafariServices

class FeedDetailViewController: UIViewController {
    private let networkService = Network()
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var bgImageView: UIImageView!
    
    var selectedProductId: String?
    var selectedProfileId: String?
    private var hyperlink: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadSelectedFeed()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        navigationItem.titleView?.tintColor = .white
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width/2
        productImageView.layer.cornerRadius = 15
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        productImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapImageView(_ sender: UITapGestureRecognizer) {
        guard
            let urlString = hyperlink,
            let url = URL(string: urlString)
        else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }

    private func loadSelectedFeed() {
        if let profileId = selectedProfileId,
           let productId = selectedProductId {
            loadProfileImage(withID: profileId)
            loadProductImage(withID: productId)
        }
    }
    
    private func loadProductImage(withID id: String) {
        networkService.loadProductImage(with: id) { [weak self] (productFeed, error) in
            if let productItem = productFeed?.product, error == nil {
                self?.setProductPoster(with: productItem)
                self?.hyperlink = productItem.hyperlink
            }
            else {
                print(error?.localizedDescription ?? "Error")
            }
        }
    }
    
    private func loadProfileImage(withID id: String) {
        networkService.loadProfileImage(with: id) { [weak self] (profileFeed, error) in
            if let profileItem = profileFeed?.profile, error == nil {
                self?.setBackgroundPoster(with: profileItem)
                self?.setAvatarPoster(with: profileItem)
            }
            else {
                print(error?.localizedDescription ?? "Error")
            }
        }
    }

    private func setBackgroundPoster(with profile: JSON.Profile.Item) {
        guard let posterPath = profile.bgImageUrl else { return }
        self.networkService.getImage(with: posterPath, handler: { [weak self] (data, error) in
            guard let _data = data else { return }
            DispatchQueue.main.async {
                self?.bgImageView.image = UIImage(data: _data)
            }
        })
    }
    
    private func setAvatarPoster(with profile: JSON.Profile.Item) {
        guard let posterPath = profile.avatarUrl else { return }
        self.networkService.getImage(with: posterPath, handler: { [weak self] (data, error) in
            guard let _data = data else { return }
            DispatchQueue.main.async {
                self?.profileImageView.image = UIImage(data: _data)
            }
        })
    }
    
    private func setProductPoster(with product: JSON.Products.Item) {
        guard let posterPath = product.imageUrl else { return }
        self.networkService.getImage(with: posterPath, handler: { [weak self] (data, error) in
            guard let _data = data else { return }
            DispatchQueue.main.async {
                self?.productImageView.image = UIImage(data: _data)
            }
        })
    }

}
