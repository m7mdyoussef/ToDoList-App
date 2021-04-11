//
//  InProgressViewController.h
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//


#import "ViewController.h"
#import "InProgressTableViewCell.h"
#import "InProgressEditDelegation.h"
#import "EditTaskViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface InProgressViewController : ViewController <UITableViewDelegate, UITableViewDataSource, InProgressEditDelegation, UISearchBarDelegate>

@property NSMutableArray<NSMutableDictionary*> *inProgressTasks;
@property NSMutableArray<NSMutableDictionary*> *doneTasks;

@property (weak, nonatomic) IBOutlet UITableView *inProgressTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *progressSearchBar;

@end


