//
//  EditTaskViewController.m
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//


#import "EditTaskViewController.h"

@interface EditTaskViewController (){
    NSArray *priorityArray;
    NSArray *stateArray;
    NSString* state;
    NSString *priority;
    NSString *pageName;
    NSInteger selectedIndex, stateIndex;
    NSMutableDictionary *editDictionary;
    
}

@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    editDictionary = [NSMutableDictionary new];
    
    priorityArray = @[@"High", @"Medium", @"Low"];
//    stateArray = @[@"To Do", @"In Progress", @"Done"];
    
    if([_editState isEqual:@"To Do"]) {
        stateArray = @[@"To Do", @"In Progress", @"Done"];
    }else if([_editState isEqual:@"In Progress"]) {
        stateArray = @[@"In Progress", @"Done"];
    }else{
        stateArray = @[@"Done"];
    }

    
    priority = [NSString new];
    
    self.priorityPicker.delegate = self;
    self.priorityPicker.dataSource = self;
    
    self.statePicker.delegate = self;
    self.statePicker.dataSource = self;
    
    _editNameTextField.text = _editName;
    _editDescriptionTextView.text = _editDescription;
    _editDatePicker.date = _editDate;
    priority = _editPriority;
    state = _editState;
    pageName = state;
    
    
    selectedIndex = (NSInteger)[priorityArray indexOfObject:priority];
    [self.priorityPicker selectRow:selectedIndex inComponent:0 animated:YES];
    
    
    stateIndex = (NSInteger)[stateArray indexOfObject:state];
    [self.statePicker selectRow:stateIndex inComponent:0 animated:YES];
    
   
    // save bar button
    UIBarButtonItem *addTaskButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveTaskAction)];
    
    addTaskButton.tintColor = [UIColor colorWithRed:46/255.0 green:20/255.0 blue:88/255.0 alpha:1.0];
        
    [self.navigationItem setRightBarButtonItem:addTaskButton];

}

-(void) saveTaskAction{
        
    DataModel *model = [DataModel new];
    model.taskName = _editNameTextField.text;
    model.taskDate = _editDatePicker.date;
    model.taskDescription = _editDescriptionTextView.text;
    model.taskCreationDate = _editCreationDate;
    
    if(priority == nil){
        model.taskPriority = priorityArray[0];
    }else{
        model.taskPriority = priority;
    }
    
    if(state == nil){
        model.taskState = stateArray[0];
    }else{
        model.taskState = state;
    }
    
    
    [editDictionary setObject:model.taskName forKey:@"name"];
    [editDictionary setObject:model.taskDescription forKey:@"description"];
    [editDictionary setObject:model.taskPriority forKey:@"priority"];
    [editDictionary setObject:model.taskDate forKey:@"date"];
    [editDictionary setObject:model.taskState forKey:@"state"];
    [editDictionary setObject:model.taskCreationDate forKey:@"creation_date"];
        
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to save changes?!" preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if([self->pageName isEqual:@"To Do"]){
            [self->_showDelegation showTaskDelegation:self->editDictionary :self->_rowIndex];
        }else if([self->pageName isEqual:@"In Progress"]){
            [self->_inProgressEditDelegation editTaskDelegation:self->editDictionary :self->_rowIndex];
        }else if([self->pageName isEqual:@"Done"]){
            [self->_doneEditDelegation doneTaskDelegation:self->editDictionary :self->_rowIndex];
        }

        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:yesAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
    
}


-(NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSInteger numberOfRows = 0;
    
    switch (pickerView.tag) {
        case 1:
            numberOfRows = [priorityArray count];
            break;
            
        case 2:
            numberOfRows = [stateArray count];
            break;
    }
    
    return numberOfRows;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *titleForRow;
    
    switch (pickerView.tag) {
        case 1:
            titleForRow = priorityArray[row];
            break;
            
        case 2:
            titleForRow = stateArray[row];
            break;
    }
    
    return titleForRow;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    switch (pickerView.tag) {
        case 1:
            priority = priorityArray[row];
            break;
            
        case 2:
            state = stateArray[row];
            
           // printf("%s\n%li", [state UTF8String], (long)row);
            break;
    }
    
}




@end

