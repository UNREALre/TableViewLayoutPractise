//
//  ViewController.swift
//  TaskIt
//
//  Created by Александр Подрабинович on 04/01/15.
//  Copyright (c) 2015 Alex Podrabinovich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var baseArray:[[Task]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let date1 = Date.from(year: 2015, month: 01, day: 05)
        let date2 = Date.from(year: 2015, month: 01, day: 06)
        let date3 = Date.from(year: 2015, month: 01, day: 07)
        
        let task1 = Task(task: "Learn", subtask: "IOS", date: date1, completed: false)
        let task2 = Task(task: "Eat", subtask: "Some food", date: date2, completed: false)
        let task3 = Task(task: "Celebrate", subtask: "X-MASS", date: date3, completed: false)
        
        let taskArray = [task1, task2, task3]
        
        var completedArray = [Task(task: "Test", subtask: "Some sub", date: date2, completed: true), Task(task: "Test another", subtask: "Some sub again", date: date3, completed: true)]
        
        baseArray = [taskArray, completedArray]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        func sortByDate(taskOne: Task, taskTwo: Task) -> Bool {
            return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970
        }
        
        baseArray[0] = baseArray[0].sorted(sortByDate)
        baseArray[1] = baseArray[1].sorted(sortByDate)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailed" {
            let detailedVC: DetailedViewController = segue.destinationViewController as DetailedViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let curTask = baseArray[indexPath!.section][indexPath!.row]
            detailedVC.detailTaskModel = curTask
            detailedVC.mainVC = self
        }
        else if segue.identifier == "showTaskAdd" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as AddTaskViewController
            addTaskVC.mainVC = self
        }
    }

    @IBAction func addTaskButtonPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return baseArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseArray[section].count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myCell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        
        let curTask = baseArray[indexPath.section][indexPath.row]
        
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
        let thisTask = baseArray[indexPath.section][indexPath.row]
        
        var newTask = Task(task: thisTask.task, subtask: thisTask.subtask, date: thisTask.date, completed: !thisTask.completed)
        
        baseArray[indexPath.section].removeAtIndex(indexPath.row)
        if indexPath.section == 0 {
            baseArray[1].append(newTask)
        }
        else {
            baseArray[0].append(newTask)
        }
        
        func sortByDate(taskOne: Task, taskTwo: Task) -> Bool {
            return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970
        }
        
        baseArray[0] = baseArray[0].sorted(sortByDate);
        baseArray[1] = baseArray[1].sorted(sortByDate);

        tableView.reloadData()
    }

}

