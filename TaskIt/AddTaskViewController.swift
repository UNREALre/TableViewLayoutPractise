//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Александр Подрабинович on 05/01/15.
//  Copyright (c) 2015 Alex Podrabinovich. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addTaskButtonPressed(sender: UIButton) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let managedObjectContext = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        task.task = taskTextField.text
        task.subtask = subTaskTextField.text
        task.date = dueDatePicker.date
        task.completed = false
        
        appDelegate.saveContext()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
