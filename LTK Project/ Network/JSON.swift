//
//  JSON.swift
//  LTK Challenge
//
//  Created by Edil Ashimov on 2/8/22.
//

import Foundation

struct JSON {
    
    //MARK: - LTK
    struct Item: Codable {
        let results: [Feed]?
        
        private enum CodingKeys: String, CodingKey {
            case results = "ltks"
        }
        
        struct Feed: Codable {
            let heroImage: String?
            let profileId: String
            let productId: [String]
            let caption: String
            
            private enum CodingKeys: String, CodingKey {
                case heroImage = "hero_image"
                case profileId = "profile_id"
                case productId = "product_ids"
                case caption = "caption"
                
            }
        }
    }
    
    //MARK: - Profiles
    struct Profile: Codable {
        let profile: Item?
        
        private enum CodingKeys: String, CodingKey {
            case profile = "profile"
        }
        
        struct Item: Codable {
            let avatarUrl: String?
            let bgImageUrl: String?
            
            private enum CodingKeys: String, CodingKey {
                case avatarUrl = "avatar_url"
                case bgImageUrl = "bg_image_url"
            }
        }
    }
    
    //MARK: - Product
    struct Products: Codable {
        let product: Item?
        
        private enum CodingKeys: String, CodingKey {
            case product = "product"
        }
        
        struct Item: Codable {
            let imageUrl: String?
            let hyperlink: String?
            
            private enum CodingKeys: String, CodingKey {
                case imageUrl = "image_url"
                case hyperlink = "hyperlink"
            }
        }
    }
}
