//
//  MasterTableViewController.swift
//  UISearchBar+TableView + Core Data
//
//  Created by Alex Gibson on 12/11/14.
//  Copyright (c) 2014 Alex Gibson . All rights reserved.
//

import UIKit
import CoreData

class MasterTableViewController: UITableViewController,UIViewControllerTransitioningDelegate,UISearchBarDelegate  {

    // will be our datasource array from CoreData----Loaded in getOurCoreData
    var diaryEntries = [NSManagedObject]()
    
    // will be used when the user does a search
    var searchDiaryEntries = [AnyObject]()
    // just used for segue to new viewcontroller but this variable is not necessary
    var selectedEntry : NSManagedObject!
    // our searchBar  // still trying to figure out how this works since some of it was deprecated is iOS 8
    @IBOutlet weak var searchBar: UISearchBar!
    
    // I don't know if Swift looks cleaner than Objective C or not. I am warming to Swift
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // There is probably a more better way.  I will check this later
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"getOurCoreData", name:"updateTableViewWithCoreData", object: nil)
        
        //searchbar
        searchBar.delegate = self
        searchBar.showsScopeBar = true

    }
    
    //because we like a beautiful status bar
   

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //pretty status bar
        self.navigationController?.navigationBar.barStyle
        
        //load up our data
        self.getOurCoreData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            if tableView == self.searchDisplayController?.searchResultsTableView{
                return searchDiaryEntries.count
                
            }
            else
            {
                return diaryEntries.count
            }
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            
            var entry :NSManagedObject
            
            if tableView == self.searchDisplayController!.searchResultsTableView{
                entry = self.searchDiaryEntries[indexPath.row] as NSManagedObject
            }
            else
            {
                entry = self.diaryEntries[indexPath.row] as NSManagedObject
            }
            
            
            cell.textLabel!.text = entry.valueForKey("entryTitle") as? String
            
            
            return cell
    }
    
    
    
    // Load our data for the table
    
    func getOurCoreData (){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "DiaryEntry")
        
        var error :NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error)as [NSManagedObject]?
        
        if let results = fetchedResults {
            diaryEntries = results
            
        }else
        {
            println("Could not fetch \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        if tableView == self.searchDisplayController!.searchResultsTableView{
            selectedEntry = self.searchDiaryEntries[indexPath.row] as NSManagedObject
        }
        else
        {
            selectedEntry = self.diaryEntries[indexPath.row] as NSManagedObject
        }
        

        
        // perform seque with our entry
        self.performSegueWithIdentifier("_viewEntry", sender: self)
        
    }
    
    
    
    // Mark : UIViewControllerAnimatedTransitioning
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentingAnimator()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimator()
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "_addNew"
        {
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //let dvc = storyboard.instantiateViewControllerWithIdentifier("detailsVC") as UIViewController
            //lets have some fun here
            let dvc : UIViewController = segue.destinationViewController as UIViewController
            dvc.transitioningDelegate = self
            dvc.modalPresentationStyle = UIModalPresentationStyle.Custom
        }
        
        if segue.identifier == "_viewEntry"
        {
            let viewEntryVC = segue.destinationViewController as ViewArticleViewController
            viewEntryVC.entry = selectedEntry
        }
        
        
    }
    
    
    // called when a row deletion action is confirmed
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
               
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                let managedContext = appDelegate.managedObjectContext!
            
                
                var entry :NSManagedObject
                //get our object we want to delete
                entry = self.diaryEntries[indexPath.row] as NSManagedObject
                
               // remove from CoreData
                managedContext.deleteObject(entry)
                var error: NSError? = nil
                if !managedContext.save(&error) {
                    println("error")
                    abort()
                    
                }

                //Reload our TableView
                self.getOurCoreData()
                break;
            default:
                return
            }
    }
    
    
    
    
    
    
    // mark Searching
    // This is where we will search our color array
    func filterContentForSearchText(searchText: String) {
        
        var entries : NSArray = self.diaryEntries
        
        //println(entries)
        // This is how you would search two properties of NSManagedObject
        let predicate = NSPredicate(format: "entryTitle contains[c] %@ OR diaryEntryText contains[c] %@", searchText,searchText)
        
        self.searchDiaryEntries = entries.filteredArrayUsingPredicate(predicate!)
        println(self.searchDiaryEntries)
        
        
    }
    
    // Reload the searchDisplayController  ???? I thought this was deprecated but it still works
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    // Dont really need this but why not
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    //dont need this either but why not
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    
}
