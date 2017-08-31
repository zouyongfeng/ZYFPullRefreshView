//
//  UIScrollView+Refresh.m
//  ZYFPullRefreshView
//
//  Created by 邹勇峰 on 17/8/17.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "MZRefreshHeader.h"

@implementation UIScrollView (Refresh)

- (void)addRefreshWithBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    
    self.mj_header = [MZRefreshHeader headerWithRefreshingBlock:refreshingBlock];

}

- (void)endPullToRefresh {
    [self.mj_header endRefreshing];
}

@end
