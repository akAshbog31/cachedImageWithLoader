//
//  LoaderImageView.swift
//  BodyRx
//
//  Created by mac on 10/01/23.
//

import Foundation
import UIKit

class LoaderImageView: UIImageView {
    private let imageCache = NSCache<NSString, AnyObject>()
    
    func setImageFromUrl(with ImageURL: String, placeHolderImg: UIImage = UIImage(named: "ic_ProfilePlaceHoler")!, activityIndeicatorStyle: UIActivityIndicatorView.Style = .medium) {
        guard let url = URL(string: ImageURL) else {
            self.image = placeHolderImg
            return
        }
        
        if let cachedImage = imageCache.object(forKey: ImageURL as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            let activityIndicator = self.activityIndicator
            activityIndicator.style = activityIndeicatorStyle
            DispatchQueue.main.async {
                activityIndicator.startAnimating()
            }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                DispatchQueue.main.async {
                    if let data = data {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        let imageToCache = UIImage(data: data)
                        self.imageCache.setObject(imageToCache!, forKey: ImageURL as NSString)
                        self.image = imageToCache
                    }
                }
            }).resume()
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        self.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return activityIndicator
    }
}
