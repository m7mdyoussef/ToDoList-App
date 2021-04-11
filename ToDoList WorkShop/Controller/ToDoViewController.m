//
//  ToDoViewController.m
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//



#import "ToDoViewController.h"


@interface ToDoViewController (){
    NSUserDefaults *defaults;
    
    NSString *stateForRemove;
    NSMutableDictionary *dictionaryForRemove;
    NSMutableDictionary *dictionaryForEdit;
    
    ShowDataViewController *showTask;
    InProgressViewController *progressView;
    
    BOOL isFilled;
    NSMutableArray *filteredArray;
    
    BOOL isGranted;
}
@end

@implementation ToDoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // to remove empty cell in table
    _tasksTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // search delegate
    self.tasksSearchBar.delegate = self;
    isFilled = false;
    
    // declear user defaults
    defaults = [NSUserDefaults standardUserDefaults];
    dictionaryForRemove = [NSMutableDictionary new];
    dictionaryForEdit = [NSMutableDictionary new];
    

    // NSMutableArray for todo tasks
    if ([[defaults objectForKey:@"todo_tasks"] mutableCopy] == nil) {
        _allTasks = [NSMutableArray new];
    }else{
        _allTasks = [[defaults objectForKey:@"todo_tasks"] mutableCopy];
    }
    
    // NSMutableArray for in progress tasks
    if ([[defaults objectForKey:@"in_progress_tasks"] mutableCopy] == nil) {
        _inProgressTasks = [NSMutableArray new];
    }else{
        _inProgressTasks = [[defaults objectForKey:@"in_progress_tasks"] mutableCopy];

    }
    
    // NSMutableArray for done tasks
    if ([[defaults objectForKey:@"done_tasks"] mutableCopy] == nil) {
        _doneTasks = [NSMutableArray new];
    }else{
        _doneTasks = [[defaults objectForKey:@"done_tasks"] mutableCopy];
    }

    
    showTask = [self.storyboard instantiateViewControllerWithIdentifier:@"show_task"];
    progressView = [self.storyboard instantiateViewControllerWithIdentifier:@"progress_task"];
    
    
    // add bar button
    UIBarButtonItem *addTaskButton = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(addTaskAction)];
    

    addTaskButton.tintColor = [UIColor colorWithRed:46/255.0 green:20/255.0 blue:88/255.0 alpha:1.0];
    
    [self.navigationItem setRightBarButtonItem:addTaskButton];
    
    
    // Notification
    isGranted = false;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions option = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:option completionHandler:^(BOOL granted, NSError * _Nullable error) {
        self->isGranted = granted;
        printf("%d", self->isGranted);
    }];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:119/255.0 green:94/255.0 blue:160/255.0 alpha:1.0];
    
    
}

-(void) notificationMethod{
    
    if(isGranted){

        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];

        for (NSMutableDictionary *dic in _allTasks) {

            // Start with todays date
            NSDate *startDate = [dic objectForKey:@"creation_date"];

            // End date
            NSDate *endDate = [dic objectForKey:@"date"];


            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];


//            printf("day: %ld", [components day]);
            if([components day] == 1){

                UNMutableNotificationContent *content = [UNMutableNotificationContent new];

                content.title = @"Task Remainder";
                content.subtitle = [dic objectForKey:@"name"];
                content.body = [dic objectForKey:@"description"];
                content.sound = [UNNotificationSound defaultSound];


                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
                NSString *identifier = @"Reminder Notification";
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];

                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                 if (error != nil) {
                   NSLog(@"Something went wrong: %@",error);
                 }
                 }];

            }
        }
    }
    
    
}

// search method
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length == 0) {
        isFilled = false;
    }else{
        isFilled = true;
        filteredArray = [NSMutableArray new];

        for (NSMutableDictionary *dic in _allTasks) {
            NSRange taskNameRange = [[dic objectForKey:@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];

            if(taskNameRange.location != NSNotFound){
                [filteredArray addObject:dic];
            }

        }

    }

        [_allTaskTableView reloadData];
}


// action on add bar button
- (void)addTaskAction {
    
    AddTaskViewController *addTaskView = [self.storyboard instantiateViewControllerWithIdentifier:@"add_task"];
    [addTaskView setAddTaskDelegation:self]; //property in AddTaskViewController
    [self.navigationController pushViewController:addTaskView animated:YES];
    
}


// add task delegation method
- (void)addTask:(NSMutableDictionary *)dataDictionary{
    
    
    [_allTasks addObject: dataDictionary]; // _alltask => array of dictionary
    [defaults setObject:_allTasks forKey:@"todo_tasks"]; // defaults => user defaults
    
    [self notificationMethod];
    
    [defaults synchronize];
    [_allTaskTableView reloadData];
    
}

// edit task delegation
- (void)editTaskDelegation:(NSMutableDictionary *)dictionary :(NSInteger)indexValue{
    
    
    stateForRemove = [dictionary objectForKey:@"state"];
    printf("%s\n", [stateForRemove UTF8String]);
    
    
    
    [_allTasks replaceObjectAtIndex:(NSUInteger)indexValue withObject:dictionary];
    [defaults setObject:_allTasks forKey:@"todo_tasks"];


    if([[dictionary objectForKey:@"state"] isEqual:@"In Progress"]){
        // in progress
        if([[defaults objectForKey:@"in_progress_tasks"] mutableCopy] == nil
           || [[defaults objectForKey:@"in_progress_tasks"] count] == 0){
            
            [_inProgressTasks removeAllObjects];
            [_inProgressTasks addObject: dictionary];
            
        }
        else{
            [_inProgressTasks addObject: dictionary];
        }
        [defaults setObject:_inProgressTasks forKey:@"in_progress_tasks"];

        // remove in progress from todo_tasks
        [_allTasks removeObjectAtIndex:(NSUInteger)indexValue];
        [defaults setObject:_allTasks forKey:@"todo_tasks"];
        //reload todo_tasks
        

    }else if ([[dictionary objectForKey:@"state"] isEqual:@"Done"]){
        // done
        if([[defaults objectForKey:@"done_tasks"] mutableCopy] == nil || [[defaults objectForKey:@"done_tasks"] count] == 0){
            [_doneTasks removeAllObjects];
            [_doneTasks addObject: dictionary];
        }

        else{
            [_doneTasks addObject: dictionary];
        }
        
        
        [defaults setObject:_doneTasks forKey:@"done_tasks"];
        
        //
        [_allTasks removeObjectAtIndex:(NSUInteger)indexValue];
        [defaults setObject:_allTasks forKey:@"todo_tasks"];
        //
    }
    
    [self notificationMethod];


    [defaults synchronize];
    [_allTaskTableView reloadData];
 
    
    
    
}


// table methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isFilled) {
        return [filteredArray count];
    }else{
        return [_allTasks count];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if(isFilled){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
        NSString *dateString = [formatter stringFromDate:[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"creation_date"]];
        
                cell.labelDate.text = dateString;
                cell.labelName.text = [[filteredArray objectAtIndex:indexPath.row] objectForKey:@"name"];

        if([[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"priority"] isEqualToString: @"High"]){
        
            cell.imagePriority.tintColor = [UIColor colorWithRed:255/255.0 green:77/255.0 blue:0/255.0 alpha:1.0];
            
        }else if([[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"priority"] isEqualToString: @"Medium"]){
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:0/255.0 green:206/255.0 blue:255/255.0 alpha:1.0];
            
        }else{
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:255/255.0 green:172/255.0 blue:0/255.0 alpha:1.0];
            
        }
        
    }else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
        NSString *dateString = [formatter stringFromDate:[[_allTasks objectAtIndex:indexPath.row] objectForKey:@"creation_date"]];
        
        cell.labelDate.text = dateString;
        cell.labelName.text = [[_allTasks objectAtIndex:indexPath.row] objectForKey:@"name"];

        if([[[_allTasks objectAtIndex:indexPath.row] objectForKey:@"priority"] isEqualToString: @"High"]){
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:255/255.0 green:77/255.0 blue:0/255.0 alpha:1.0];
            
        }else if([[[_allTasks objectAtIndex:indexPath.row] objectForKey:@"priority"] isEqualToString: @"Medium"]){
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:0/255.0 green:206/255.0 blue:255/255.0 alpha:1.0];
            
        }else{
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:255/255.0 green:172/255.0 blue:0/255.0 alpha:1.0];
            
        }
        
    }

    
    
    return  cell;
    
}

//for delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    dictionaryForRemove = [_allTasks objectAtIndex:indexPath.row];
    
    // if todo => remove from alltasks only
    [_allTasks removeObjectAtIndex:indexPath.row];
    [defaults setObject:_allTasks forKey:@"todo_tasks"];
      
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [defaults synchronize];
    [_allTaskTableView reloadData];
    
    
}


//go to details to edit
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    dictionaryForEdit = [_allTasks objectAtIndex:indexPath.row];
    ShowDataViewController *showTask = [self.storyboard instantiateViewControllerWithIdentifier:@"show_task"];

    [showTask setEditDedegation:self];
    
    [showTask setShowName:[[_allTasks objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    [showTask setShowDescription:[[_allTasks objectAtIndex:indexPath.row] objectForKey:@"description"]];

    [showTask setShowPriority:[[_allTasks objectAtIndex:indexPath.row] objectForKey:@"priority"]];

    [showTask setShowDate:[[_allTasks objectAtIndex:indexPath.row] objectForKey:@"date"]];
    
    [showTask setShowCreationDate:[[_allTasks objectAtIndex:indexPath.row] objectForKey:@"creation_date"]];

    [showTask setShowState:[[_allTasks objectAtIndex:indexPath.row] objectForKey:@"state"]];
    
    [showTask setRowIndex:indexPath.row];
    
    [self.navigationController pushViewController:showTask animated:YES];
    
    

    
}






@end

