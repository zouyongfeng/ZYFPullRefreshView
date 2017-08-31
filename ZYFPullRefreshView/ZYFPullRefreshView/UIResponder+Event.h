//
//  UIResponder+Event.h
//  ZYFPullRefreshView
//
//  Created by 邹勇峰 on 17/8/20.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Event)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
@end


@interface MyView : UIView

@end
