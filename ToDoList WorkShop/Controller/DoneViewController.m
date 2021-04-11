//
//  DoneViewController.m
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//


#import "DoneViewController.h"

@interface DoneViewController (){
    NSUserDefaults *defaults;
    
    BOOL isFilled;
    NSMutableArray *filteredArray;
    
    BOOL isGranted;
}


@end


@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    // to remove empty cell in table
    _doneTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // search delegate
    self.doneSearchBar.delegate = self;
    isFilled = false;
    
    
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
    
    [_doneTableView reloadData];
    
}



// search method
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length == 0) {
        isFilled = false;
    }else{
        isFilled = true;
        filteredArray = [NSMutableArray new];

        for (NSMutableDictionary *dic in _doneTasks) {
            NSRange taskNameRange = [[dic objectForKey:@"name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];

            if(taskNameRange.location != NSNotFound){
                [filteredArray addObject:dic];
            }

        }

    }

    //
        [_doneTableView reloadData];
}


// notification method
-(void) notificationMethod{
    
    if(isGranted){

        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];

        for (NSMutableDictionary *dic in _doneTasks) {

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
    
    // NSMutableArray for done tasks
    if ([[defaults objectForKey:@"done_tasks"] mutableCopy] == nil) {
        _doneTasks = [NSMutableArray new];
    }else{
        _doneTasks = [[defaults objectForKey:@"done_tasks"] mutableCopy];
    }
    
    [_doneTableView reloadData];
    
}

- (void)doneTaskDelegation:(NSMutableDictionary *)dictionary :(NSInteger)indexValue{
    
    [_doneTasks replaceObjectAtIndex:(NSUInteger)indexValue withObject:dictionary];
    
    
    
    [defaults setObject:_doneTasks forKey:@"done_tasks"];
    
    [self notificationMethod];
    
    [defaults synchronize];
    [_doneTableView reloadData];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isFilled) {
        return [filteredArray count];
    }else{
        return [_doneTasks count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
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
        NSString *dateString = [formatter stringFromDate:[[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"creation_date"]];
        
        cell.labelDate.text = dateString;
        cell.labelName.text = [[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"name"];

        if([[[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"priority"] isEqualToString: @"High"]){
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:255/255.0 green:77/255.0 blue:0/255.0 alpha:1.0];
            
        }else if([[[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"priority"] isEqualToString: @"Medium"]){
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:0/255.0 green:206/255.0 blue:255/255.0 alpha:1.0];
            
        }else{
            
            cell.imagePriority.tintColor = [UIColor colorWithRed:255/255.0 green:172/255.0 blue:0/255.0 alpha:1.0];
            
        }
    }
    
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // remove from 2 arrays
    [_doneTasks removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    [defaults setObject:_doneTasks forKey:@"done_tasks"];
    
    [defaults synchronize];
    [_doneTableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditTaskViewController *editTask = [self.storyboard instantiateViewControllerWithIdentifier:@"edit_task"];
    
    [editTask setDoneEditDelegation:self];

    [editTask setEditName:[[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"name"]];

    [editTask setEditDescription:[[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"description"]];

    [editTask setEditPriority:[[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"priority"]];

    [editTask setEditDate:[[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"date"]];
    
    [editTask setEditState:[[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"state"]];
    
    [editTask setEditCreationDate:[[_doneTasks objectAtIndex:indexPath.row] objectForKey:@"creation_date"]];
        
    [editTask setRowIndex:indexPath.row];
    
    [self.navigationController pushViewController:editTask animated:YES];
    
}


@end

