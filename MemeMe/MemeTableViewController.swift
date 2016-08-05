//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Sukh Kalsi on 22/08/2015.
//  Copyright (c) 2015 Sukh Kalsi. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // Obtain the currently saved Memes within this apps session
    var memes : [Meme]  {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appdelegate.memes
    }
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        // set up the add Meme view
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("MemeMeViewController") as! MemeMeViewController
        
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // refresh the table view
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // retrieve the meme
        let meme = memes[indexPath.row]

        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = meme.description()
        cell.imageView?.image = meme.image

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // setup the detail view controller
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        viewController.memedImage = memes[indexPath.row].memedImage
        
        // push to the navigation stack
        navigationController!.pushViewController(viewController, animated: true)
    }

}
