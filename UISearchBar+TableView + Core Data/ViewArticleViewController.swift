//
//  ViewArticleViewController.swift
//  UISearchBar+TableView + Core Data
//
//  Created by Alex Gibson on 12/11/14.
//  Copyright (c) 2014 Alex Gibson . All rights reserved.
//

import UIKit
import CoreData


class ViewArticleViewController: UIViewController {

    // what's up with ? and !  -"optional" or "no this is going down like this"
    
    // Just a heads up this viewcontroller is pretty much worthless but i just wanted to segue the data back and forth
    
    
    //it says what it is very Swift like
    var entry :NSManagedObject!
    
    //this is not a textfield it is a time machine haha
    @IBOutlet weak var entryTitleTextField: UITextField!
    
    //magic scrollview created by someone very smart...hopefully they have mad a mint in app development
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    // just a textview ... nothing to see here
    @IBOutlet weak var entryTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up the magic scrollview
        scrollView.sizeToFit()
        
        
        //custom keyboard toolbar to dismiss it
        var keyBoardToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        var buttons : [UIBarButtonItem] = []
        buttons = [UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideKeyboard"),UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil) ,UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideKeyboard")]
        
        //adding the buttons to the toolbar
        keyBoardToolbar.items = buttons
        
        // now adding the keybard to the textview and textfield
        entryTitleTextField.inputAccessoryView = keyBoardToolbar
        entryTextView.inputAccessoryView = keyBoardToolbar
        
    }
   

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // if swift is not safe already I just made it double safe :)
        if entry.valueForKey("entryTitle") != nil{
            entryTitleTextField.text = entry.valueForKey("entryTitle") as? String
        }
        // one wrong move and I will blow up your iphone
        if entry.valueForKey("diaryEntryText") != nil
        {
            entryTextView.text = entry.valueForKey("diaryEntryText") as? String
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //we can dismiss our view controller
    @IBAction func cancelDidPress(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //we can hide the keyboard
    func hideKeyboard(){
        self.view.endEditing(true )
    }
    

   

}
