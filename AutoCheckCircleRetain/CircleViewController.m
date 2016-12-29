//
//  CircleViewController.m
//  AutoCheckCircleRetain
//
//  Created by lixy on 2016/12/29.
//  Copyright © 2016年 lixy. All rights reserved.
//

#import "CircleViewController.h"

typedef void(^Circle)(NSString *str);

@interface CircleViewController ()
@property (nonatomic, copy) Circle circle;
@property (nonatomic, strong) NSString *str;
@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.title = @"circle";
    
    [self setCircle:^(NSString *str){
        self.str = str;
        [self test];
    }];
    
    self.circle(@"test");
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = bbi;
}

- (void)cancel
{
    if (self.navigationController.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)test
{
    
}

- (void)dealloc
{
    NSLog(@"dealloc - %@", NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
