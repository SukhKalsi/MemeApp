//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sukh Kalsi on 22/08/2015.
//  Copyright (c) 2015 Sukh Kalsi. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memedImage: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = memedImage
    }

}
