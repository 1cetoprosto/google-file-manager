//
//  UIImage+Extension.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 13.06.2022.
//

import UIKit

extension UIImageView {

    func downloadImage(_ imgURLString: String?, finished: @escaping ((_ isTrue: Bool, _ label: String)-> Void)){
        finished(false, "Loading")
        
        if let strURL = imgURLString {
            if let url = URL(string: strURL) {
                
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url) {
                        
                        DispatchQueue.main.async {
                            self?.image = UIImage(data: data) }
                        finished(true, "Loaded")
                    } else { finished(false, "Failed to load image") }
                }
            } else { finished(false, "Invalid URL") }
        } else {finished(false, "Invalid String URL")}
    }
}
