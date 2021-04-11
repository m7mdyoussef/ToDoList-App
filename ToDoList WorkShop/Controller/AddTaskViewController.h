//
//  AddTaskViewController.h
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddDelegation.h"
#import "DataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddTaskViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property id <AddDelegation> addTaskDelegation;

@property (weak, nonatomic) IBOutlet UIPickerView *priorityPicker;


@property (weak, nonatomic) IBOutlet UITextField *addNameTextField;

@property (weak, nonatomic) IBOutlet UITextView *addDescriptionTextView;


@property (weak, nonatomic) IBOutlet UIDatePicker *addDatePicker;


@end

NS_ASSUME_NONNULL_END
