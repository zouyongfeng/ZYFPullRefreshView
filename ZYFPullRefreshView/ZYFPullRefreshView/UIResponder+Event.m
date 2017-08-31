//
//  UIResponder+Event.m
//  ZYFPullRefreshView
//
//  Created by 邹勇峰 on 17/8/20.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import "UIResponder+Event.h"

@implementation UIResponder (Event)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [[self nextResponder]routerEventWithName:eventName userInfo:userInfo];
}
@end

@implementation MyView



@end
