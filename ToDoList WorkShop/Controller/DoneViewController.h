//
//  DoneViewController.h
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

#import "ViewController.h"
#import "DoneTableViewCell.h"
#import "DoneDelegation.h"
#import "EditTaskViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface DoneViewController : ViewController <UITableViewDelegate, UITableViewDataSource, DoneDelegation, UISearchBarDelegate>

@property NSMutableArray<NSMutableDictionary*> *doneTasks;

@property (weak, nonatomic) IBOutlet UITableView *doneTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *doneSearchBar;

@property NSString *test;

@end
