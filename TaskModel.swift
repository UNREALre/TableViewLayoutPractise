//
//  TaskModel.swift
//  TaskIt
//
//  Created by Александр Подрабинович on 06/01/15.
//  Copyright (c) 2015 Alex Podrabinovich. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)
class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}
