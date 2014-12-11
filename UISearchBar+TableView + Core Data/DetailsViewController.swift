//
//  DetailsViewController.swift
//  
//
//  Created by Steven Gibson on 12/10/14.
//
//

import UIKit
import CoreData


class DetailsViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var diaryEntryTextView: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        println("View is loaded")
        
        var keyBoardToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        var buttons : [UIBarButtonItem] = []
        buttons = [UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideKeyboard"),UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil) ,UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideKeyboard")]
        
        
        keyBoardToolbar.items = buttons
        
        
        // add our custom buttons to the textview keyboard
        diaryEntryTextView.inputAccessoryView = keyBoardToolbar

        
        // This is using a don button
        entryTitle.returnKeyType = UIReturnKeyType.Done
        entryTitle.delegate = self
        

        // set up or tpkeyboardAvoiding
        scrollView.contentSizeToFit()
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelDidPress(sender: AnyObject) {
        
        // dismiss the view Controller without saving
        self.dismissViewControllerAnimated(true , completion: nil)
    }

    @IBAction func saveButtonPress(sender: AnyObject) {
        
        // save to core data and dismiss the view controller
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("DiaryEntry", inManagedObjectContext: managedContext)
        let diaryEntry = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if (entryTitle.text != nil)
        {
            diaryEntry.setValue(entryTitle.text, forKey: "entryTitle")
            diaryEntry.setValue(diaryEntryTextView.text, forKey: "diaryEntryText")
            
            
            //Save to coreData
            var error: NSError?
            if !managedContext.save(&error){
                println("Could not save \(error)")
            }
            
            
            //probably better to pass the array back and forth rather than to do this but this is just temp.
            // This will update or tableview on the masterTableViewController
            NSNotificationCenter.defaultCenter().postNotificationName("updateTableViewWithCoreData", object: nil)
            
            self.dismissViewControllerAnimated(true , completion: nil)
        }
        
       

    }

    
    // This is the hide method for our custom keyboard buttons
    func hideKeyboard(){
        self.view.endEditing(true )
        
        //Return scrollview to top because tpkeyboardavoiding did not get it done
        self.scrollView.setContentOffset(CGPointMake(0, -self.scrollView.contentInset.top), animated: true)
        
        
        
    }
    
    // this is the function used to hide the keybard with a done button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true )
        return false
    }
    
 
  
}
