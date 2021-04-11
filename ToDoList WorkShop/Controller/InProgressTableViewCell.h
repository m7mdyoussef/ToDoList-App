//
//  InProgressTableViewCell.h
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InProgressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;


@property (weak, nonatomic) IBOutlet UIImageView *imagePriority;
@end

NS_ASSUME_NONNULL_END
