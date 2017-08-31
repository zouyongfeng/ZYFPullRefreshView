//
//  UIScrollView+Refresh.h
//  ZYFPullRefreshView
//
//  Created by 邹勇峰 on 17/8/17.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@interface UIScrollView (Refresh)


- (void)addRefreshWithBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;


- (void)endPullToRefresh;

@end
