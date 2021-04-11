//
//  InProgressViewController.m
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//


#import "InProgressViewController.h"

@interface InProgressViewController (){
    NSUserDefaults *defaults;
    
    BOOL isFilled;
    NSMutableArray *filteredArray;
    
    BOOL isGranted;
}


@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _inProgressTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // search delegate
    self.progressSearchBar.delegate = self;
    isFilled = false;
    
    // declear user defaults
    defaults = [NSUserDefaults standardUserDefaults];

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
    
    // Notification
    isGranted = false;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions option = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:option completionHandler:^(BOOL granted, NSError * _Nullable error) {
        self->isGranted = granted;
        printf("%d", self->isGranted);
    }];
    
    self.view.backgroundColor = [UIColor colorWithRed:119/255.0 green:94/255.0 blue:160/255.0 alpha:1.0];
    
    [_inProgressTableView reloadData];
    
}


// search method
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length == 0) {
        isFilled = false;
    }else{
        isFilled = true;
        filteredArray = [NSMutableArray new];

        for (NSMutableDictionary *dic in _inProgressTasks) {
            NSRange taskNameRange = [[dic objectForKey:@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];

            if(taskNameRange.location != NSNotFound){
                [filteredArray addObject:dic];
            }

        }

    }

    //
        [_inProgressTableView reloadData];
}

// notification method
-(void) notificationMethod{
    
    if(isGranted){

        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];

        for (NSMutableDictionary *dic in _inProgressTasks) {

            // Start with todays date
            NSDate *startDate = [dic objectForKey:@"creation_date"];

            // End date
            NSDate *endDate = [dic objectForKey:@"date"];


            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];


            printf("day: %ld", [components day]);
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


- (void)viewWillAppear:(BOOL)animated{
  
    if ([[defaults objectForKey:@"in_progress_tasks"] mutableCopy] == nil) {
        _inProgressTasks = [NSMutableArray new];
    }else{
        _inProgressTasks = [[defaults objectForKey:@"in_progress_tasks"] mutableCopy];
    }
    
    [_inProgressTableView reloadData];
}

- (void)editTaskDelegation:(NSMutableDictionary *)dictionary :(NSInteger)indexValue{

    [_inProgressTasks replaceObjectAtIndex:(NSUInteger)indexValue withObject:dictionary];
    [defaults setObject:_inProgressTasks forKey:@"in_progress_tasks"];

  
    
    
    if ([[dictionary objectForKey:@"state"] isEqual:@"Done"]){
        // done
        if([[defaults objectForKey:@"done_tasks"] mutableCopy] == nil || [[defaults objectForKey:@"done_tasks"] count] == 0){
            [_doneTasks removeAllObjects];
            [_doneTasks addObject: dictionary];
            [defaults setObject:_doneTasks forKey:@"done_tasks"];
        }

        else{
            
            _doneTasks = [[defaults objectForKey:@"done_tasks"] mutableCopy];
            [_doneTasks addObject: dictionary];
            [defaults setObject:_doneTasks forKey:@"done_tasks"];
        }
        
                
        //
        [_inProgressTasks removeObjectAtIndex:(NSUInteger)indexValue];
        [defaults setObject:_inProgressTasks forKey:@"in_progress_tasks"];
        //
    }
    
    [self notificationMethod];
    
    [defaults synchronize];
    [_inProgressTableView reloadData];
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isFilled) {
        return [filteredArray count];
    }else{
        return [_inProgressTasks count];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
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
        NSString *dateString = [formatter stringFromDate:[[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"creation_date"]];
        
        cell.labelDate.text = dateString;
        cell.labelName.text = [[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"name"];

        if([[[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"priority"] isEqualToString: @"High"]){
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:255/255.0 green:77/255.0 blue:0/255.0 alpha:1.0];
            
        }else if([[[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"priority"] isEqualToString: @"Medium"]){
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:0/255.0 green:206/255.0 blue:255/255.0 alpha:1.0];
            
        }else{
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:255/255.0 green:172/255.0 blue:0/255.0 alpha:1.0];
            
        }
    }
    
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    [_inProgressTasks removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    [defaults setObject:_inProgressTasks forKey:@"in_progress_tasks"];
    
    [defaults synchronize];
    [_inProgressTableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    EditTaskViewController *editTask = [self.storyboard instantiateViewControllerWithIdentifier:@"edit_task"];
    
    [editTask setInProgressEditDelegation:self];
    

    [editTask setEditName:[[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"name"]];

    [editTask setEditDescription:[[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"description"]];

    [editTask setEditPriority:[[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"priority"]];

    [editTask setEditDate:[[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"date"]];
    
    [editTask setEditState:[[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"state"]];
    
    [editTask setEditCreationDate:[[_inProgressTasks objectAtIndex:indexPath.row] objectForKey:@"creation_date"]];
        
    [editTask setRowIndex:indexPath.row];
    
    
    
    
    [self.navigationController pushViewController:editTask animated:YES];
    
}

//swipe down to refresh
- (IBAction)reloadAction:(id)sender {
    [_inProgressTableView reloadData];
}

@end

