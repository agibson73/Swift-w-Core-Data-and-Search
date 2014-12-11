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

    // what's up with ? and !  -optional or no this is going down like this
    
    // Just a heads up this viewcontroller is pretty much worthless but i just was segue the data back and forth
    
    var entry :NSManagedObject!
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var entryTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.sizeToFit()
        
        var keyBoardToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        var buttons : [UIBarButtonItem] = []
        buttons = [UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideKeyboard"),UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil) ,UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideKeyboard")]
        
        
        keyBoardToolbar.items = buttons
        
        entryTitleTextField.inputAccessoryView = keyBoardToolbar
        entryTextView.inputAccessoryView = keyBoardToolbar
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if entry.valueForKey("entryTitle") != nil{
            entryTitleTextField.text = entry.valueForKey("entryTitle") as? String
        }
        
        if entry.valueForKey("diaryEntryText") != nil
        {
            entryTextView.text = entry.valueForKey("diaryEntryText") as? String
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelDidPress(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func hideKeyboard(){
        self.view.endEditing(true )
    }
    

   

}
