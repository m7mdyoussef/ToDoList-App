//
//  FirstViewViewController.m
//  ToDoList WorkShop
//
//  Created by mohamed youssef on 4/5/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//


#import "FirstViewViewController.h"

@interface FirstViewViewController ()

@end


@implementation FirstViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _subViewDesign.layer.cornerRadius = 35;
    
    
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPage)];
    
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
    

    
}

-(void) nextPage{
    
    MyTasksViewController *taskaty = [self.storyboard instantiateViewControllerWithIdentifier:@"task_tab_bar"];
    
    [taskaty setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [taskaty setModalPresentationStyle: UIModalPresentationFullScreen];
    [self presentViewController:taskaty animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

