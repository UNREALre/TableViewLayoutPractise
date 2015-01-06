//
//  ViewController.swift
//  TaskIt
//
//  Created by Александр Подрабинович on 04/01/15.
//  Copyright (c) 2015 Alex Podrabinovich. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchedResultsController = getFetchResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailed" {
            let detailedVC: DetailedViewController = segue.destinationViewController as DetailedViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let curTask = fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
            detailedVC.detailTaskModel = curTask
        }
        else if segue.identifier == "showTaskAdd" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as AddTaskViewController
        }
    }

    @IBAction func addTaskButtonPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myCell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        
        let curTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        myCell.taskLabel.text = curTask.task
        myCell.subtaskLabel.text = curTask.subtask
        myCell.DateLabel.text = Date.toString(date: curTask.date)
        
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetailed", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "To do"
        }
        else {
            return "Completed"
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        if indexPath.section == 0 {
            thisTask.completed = true
        }
        else {
            thisTask.completed = false
        }
        
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
         tableView.reloadData()
    }
    
    
    //HELPER
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptior = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [completedDescriptior, sortDescriptor]
        
        return fetchRequest
    }
    
    func getFetchResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        
        return fetchedResultsController
    }

}

