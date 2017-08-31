//
//  ViewController.m
//  ZYFPullRefreshView
//
//  Created by 邹勇峰 on 17/8/17.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+Refresh.h"
#import "UIResponder+Event.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __weak ViewController *weakSelf = self;
    [self.tableView addRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView endPullToRefresh];
        });
    }];
}

- (IBAction)buttonClick:(UIButton *)sender {
    [sender routerEventWithName:@"hehi" userInfo:nil];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    NSLog(@"%@",eventName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
