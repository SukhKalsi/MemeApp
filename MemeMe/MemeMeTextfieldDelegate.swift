//
//  MemeMeTextfieldDelegate.swift
//  MemeMe
//
//  Created by Sukh Kalsi on 16/08/2015.
//  Copyright (c) 2015 Sukh Kalsi. All rights reserved.
//

import Foundation
import UIKit

class MemeMeTextfieldDelegate: NSObject, UITextFieldDelegate {
    
    var activeTextFieldTag: Int?
    
    // Just as user begins typing into any textfield, identifiy if this is first time entering specific textfield - if so clear the default text.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        var text = textField.text
        var tag = textField.tag
        
        // assign our property so we know when editing if we need to move the view up i.e. for Bottom TextField.
        self.activeTextFieldTag = tag
        
        // The tag is defined within storyboard attributes inspector for each textfield
        if (text == "TOP" && tag == 1) || (text == "BOTTOM" && tag == 2) {
            textField.text = ""
        }
        
        return true
    }
    
    // Once finished, bring focus back to the main app.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // Whilst typing, convert everything to uppercase - for some reason setting capitalisation doesn't do this automatically...
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // If we have upper case, then we directly edit the text field...
        if string.capitalizedString != string {
            textField.text = textField.text! + string.capitalizedString
            return false
        }
        
        // Otherwise we allow the proposed edit.
        return true
    }
}