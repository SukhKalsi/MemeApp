//
//  ViewController.swift
//  MemeMe
//
//  Created by Sukh Kalsi on 16/08/2015.
//  Copyright (c) 2015 Sukh Kalsi. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /* Static Variables */
    let memeTextFieldDelegate = MemeMeTextfieldDelegate()
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    /* Dynamic variables */
    var memedImage: UIImage? // store the generated Meme Me image
    var _currentKeyboardHeight:CGFloat = 0.0 // used for when we moving the view i.e. when clicking bottom textfield

    
    /* Outlets */
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    /* Actions */
    @IBAction func albumButtonAction(sender: AnyObject) {
        self.initImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func cameraButtonAction(sender: AnyObject) {
        self.initImagePicker(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func shareButton(sender: AnyObject) {
        // generate the image and store to local property so we only need to do this once
        self.memedImage = self.generateMemedImage()
        
        // initialise Activity view - provide completion handler on success, save the image and dismiss
        let activityViewController = UIActivityViewController(activityItems: [self.memedImage as! AnyObject], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        // show the Activity view
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    /* Override default view methods */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable the camera if it is not available i.e. simulator.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

        // Subscribe to the keyboard notifications, to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove the notification subscription for keyboard as they are applied globally!
        self.unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the share button by default, until we have an image
        self.shareButton.enabled = false
        self.cancelButton.enabled = false
        
        // setup the textfield with custom attributes etc.
        textFieldSetup(topTextField)
        textFieldSetup(bottomTextField)
    }
    
    /* Image Picker View Controller */
    func initImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    /* Image Picker Delegates */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            self.imagePickerView.contentMode = .ScaleAspectFit
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /* Set textfield attributes */
    func textFieldSetup(textField: UITextField) {
        textField.delegate = self.memeTextFieldDelegate
        textField.defaultTextAttributes = self.memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
    }
    
    
    /* Keybaord Notifications, with Show and Hide selector functions */
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        // we only want to move the view when the bottom textfield is selected
        if self.memeTextFieldDelegate.activeTextFieldTag == 2 {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            
            // reassign global variable to latest value
            _currentKeyboardHeight = keyboardSize.CGRectValue().height - _currentKeyboardHeight
            
            self.view.frame.origin.y -= _currentKeyboardHeight
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        // we only want to move the view when the bottom textfield is selected
        if self.memeTextFieldDelegate.activeTextFieldTag == 2 {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            
            // reset the global variable
            _currentKeyboardHeight = 0.0
            
            self.view.frame.origin.y += keyboardSize.CGRectValue().height
        }
    }
    
    
    /* Meme specific tasks, i.e. save, generate meme */
    func save() {
        
        // initialise meme using out Struct
        var meme = Meme(
            topText: topTextField.text!,
            bottomText: bottomTextField.text!,
            image: imagePickerView.image!,
            memedImage: self.memedImage!
        )
        
        // TODO: save the Meme.
        println("Saving...")
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        toggleUIElements()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toggleUIElements()
        
        return memedImage
    }
    
    func toggleUIElements() {
        // toggle view elements - we do this when generating a Meme image.
        self.toolBar.hidden = !self.toolBar.hidden
        self.navBar.hidden = !self.navBar.hidden
    }
}

