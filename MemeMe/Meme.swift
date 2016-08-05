//
//  Meme.swift
//  MemeMe
//
//  Created by Sukh Kalsi on 16/08/2015.
//  Copyright (c) 2015 Sukh Kalsi. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let image: UIImage
    let memedImage: UIImage
    
    func description() -> String {
        return "\(self.topText) \(self.bottomText)"
    }
}
