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

    
    var diaryEntries = [NSManagedObject]()
    var searchDiaryEntries = [AnyObject]()
    var selectedEntry : NSManagedObject!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // There is probably a more better way.  I will check this later
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"getOurCoreData", name:"updateTableViewWithCoreData", object: nil)
        
        //searchbar
        searchBar.delegate = self
        searchBar.showsScopeBar = true

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    
    // mark Searching
    // This is where we will search our color array
    func filterContentForSearchText(searchText: String) {
        
        var entries : NSArray = self.diaryEntries
        
        let predicate = NSPredicate(format: "entryTitle contains[c] %@", searchText)
        self.searchDiaryEntries = entries.filteredArrayUsingPredicate(predicate!)
        
        
        println(self.searchDiaryEntries)
        
        
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
}
