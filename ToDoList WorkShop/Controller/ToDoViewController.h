//
//  ToDoViewController.h
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//


#import "ViewController.h"
#import "AddTaskViewController.h"
#import "TodoTableViewCell.h"
#import "ShowDataViewController.h"
#import "DataModel.h"
#import "AddDelegation.h"
//#import "DataModelManager.h"
#import "EditDelegation.h"
#import "EditTaskViewController.h"
#import "InProgressViewController.h"

#import <UserNotifications/UserNotifications.h>


@interface ToDoViewController : ViewController <UITableViewDelegate, UITableViewDataSource, AddDelegation, EditDelegation, UISearchBarDelegate>

@property NSMutableArray<NSMutableDictionary*> *allTasks;
@property NSMutableArray<NSMutableDictionary*> *inProgressTasks;
@property NSMutableArray<NSMutableDictionary*> *doneTasks;


@property (weak, nonatomic) IBOutlet UISearchBar *tasksSearchBar;


@property (weak, nonatomic) IBOutlet UITableView *allTaskTableView;
@property (weak, nonatomic) IBOutlet UITableView *tasksTableView;

@end


