//
//  ViewController.m
//  AutoCheckCircleRetain
//
//  Created by lixy on 2016/12/29.
//  Copyright © 2016年 lixy. All rights reserved.
//

#import "ViewController.h"
#import "NormalViewController.h"
#import "CircleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"AutoCheckCircleRetain";

}
- (IBAction)pushCircle:(id)sender {
    CircleViewController *vc = [[CircleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)pushNormal:(id)sender {
    NormalViewController *vc = [[NormalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)presentCircle:(id)sender {
    CircleViewController *vc = [[CircleViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (IBAction)presentNormal:(id)sender {
    NormalViewController *vc = [[NormalViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
