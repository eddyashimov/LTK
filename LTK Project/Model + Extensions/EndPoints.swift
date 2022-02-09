//
//  EndPoints.swift
//  LTK Challenge
//
//  Created by Edil Ashimov on 2/8/22.
//

import Foundation

enum EndPoints {
    case Ltks
    case Products
    case Profiles
}

extension EndPoints {
    
    var path:String {
        let baseURL = "https://api-gateway.rewardstyle.com/api/ltk/v2/"
        switch(self) {
        case .Ltks:
            return "\(baseURL)ltks/?featured=true&limit=20"
        case .Products:
            return "\(baseURL)products/"
        case .Profiles:
            return "\(baseURL)profiles/"
        }
    }
    
}
