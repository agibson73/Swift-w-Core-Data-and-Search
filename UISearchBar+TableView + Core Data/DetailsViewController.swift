//
//  DetailsViewController.swift
//  
//
//  Created by Steven Gibson on 12/10/14.
//
//

import UIKit
import CoreData


class DetailsViewController: UIViewController {

    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var diaryEntryTextView: UITextView!
    //we will need a couple of things for coredata
    //1
    /*
    var appDelegate : UIApplicationDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var managedContext:NSManagedObjectContext = appDelegate.managedObjectContext
    
    */
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        println("View is loaded")
        scrollView.contentSizeToFit()
        var keyBoardToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        var buttons : [UIBarButtonItem] = []
        buttons = [UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideKeyboard"),UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil) ,UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "hideKeyboard")]
        
        
        keyBoardToolbar.items = buttons
        
        entryTitle.inputAccessoryView = keyBoardToolbar
        diaryEntryTextView.inputAccessoryView = keyBoardToolbar
        

        
    
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
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("DiaryEntry", inManagedObjectContext: managedContext)
        let diaryEntry = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        if (entryTitle.text != nil)
        {
            diaryEntry.setValue(entryTitle.text, forKey: "entryTitle")
        }
        
        diaryEntry.setValue(diaryEntryTextView.text, forKey: "diaryEntryText")
        
        
        // diaryEntry.setValue(entryDate, forKey: "date")
        
        
        //Save to coreData
        var error: NSError?
        if !managedContext.save(&error){
            println("Could not save \(error)")
        }
        
        
        //probably better to pass the array back and forth rather than to do this but this is just temp.
        NSNotificationCenter.defaultCenter().postNotificationName("updateTableViewWithCoreData", object: nil)
        
        self.dismissViewControllerAnimated(true , completion: nil)

    }

    
    func hideKeyboard(){
        self.view.endEditing(true )
    }
    
    
  
}
