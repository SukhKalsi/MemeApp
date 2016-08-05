//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Sukh Kalsi on 22/08/2015.
//  Copyright (c) 2015 Sukh Kalsi. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // Obtain the currently saved Memes within this apps session
    var memes : [Meme]  {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appdelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBAction func addMeme(sender: AnyObject) {
        // set up the add Meme view
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("MemeMeViewController") as! MemeMeViewController
        
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // define and setup each collection cells layout
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh the collection view data.
        collectionView!.reloadData()
    }

    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // retrieve the meme
        let meme = memes[indexPath.row]
        
        // confgiure the collection
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        // setup the detail view controller
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        viewController.memedImage = memes[indexPath.row].memedImage
        
        // push to the navigation stack
        navigationController!.pushViewController(viewController, animated: true)
    }
    
}
