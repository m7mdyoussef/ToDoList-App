//
//  AddDelegation.h
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddDelegation <NSObject>
-(void) addTask: (NSMutableDictionary*) dataDictionary;

@end

NS_ASSUME_NONNULL_END
