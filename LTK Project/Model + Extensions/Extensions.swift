//
//  Extensions.swift
//  LTK Challenge
//
//  Created by Edil Ashimov on 2/8/22.
//

import UIKit

extension URLRequest {
    
    struct httpMethod {
        static let GET: String = "GET"
    }
    
    init(withUrl url: URL, httpBody: Data?, httpHeaderFields: [String: String], httpMethod: String, networkServiceType: NetworkServiceType = .default, cachePolicy: NSURLRequest.CachePolicy = .reloadRevalidatingCacheData) {
        self.init(url: url)
        
        self.networkServiceType = networkServiceType
        self.httpMethod = httpMethod
        self.httpBody = httpBody
        self.cachePolicy = cachePolicy
        
        for (key, value) in httpHeaderFields {
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}

extension UIViewController {
    func presentAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        DispatchQueue.main.async  {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension UIView {
     private var shimmerAnimationKey: String {
         return "shimmer"
     }

     func startShimmering() {
         let white = UIColor.white.cgColor
         let alpha = UIColor.white.withAlphaComponent(0.7).cgColor
         let width = bounds.width
         let height = bounds.height

         let gradient = CAGradientLayer()
         gradient.colors = [alpha, white, alpha]
         gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
         gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
         gradient.locations = [0.4, 0.5, 0.6]
         gradient.frame = CGRect(x: -width, y: 0, width: width*3, height: height)
         layer.mask = gradient

         let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
         animation.fromValue = [0.0, 0.1, 0.2]
         animation.toValue = [0.8, 0.9, 1.0]
         animation.duration = 1
         animation.repeatCount = .infinity
         gradient.add(animation, forKey: shimmerAnimationKey)
     }

     func stopShimmering() {
         layer.mask = nil
     }
 }

