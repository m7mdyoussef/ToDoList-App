//
//  DataModelManager.h
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataModelManager : NSObject

@property NSMutableArray<NSMutableDictionary*> *allTasks;

@property NSMutableArray<NSMutableDictionary*> *inProgressTasks;

@property NSMutableArray<NSMutableDictionary*> *doneTasks;

@property NSUserDefaults *defaults;

@end

NS_ASSUME_NONNULL_END
