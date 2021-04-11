//
//  DataModel.h
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : NSObject

@property NSString* taskName;
@property NSString* taskDescription;
@property NSString* taskPriority;
@property NSString* taskState;
@property NSDate* taskDate;
@property NSDate* taskCreationDate;

@end



NS_ASSUME_NONNULL_END
