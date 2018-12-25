//
//  MZRefreshHeader.m
//  ZYFPullRefreshView
//
//  Created by 邹勇峰 on 17/8/17.
//  Copyright © 2017年 邹勇峰. All rights reserved.
//

#import "MZRefreshHeader.h"
#import <Lottie/Lottie.h>

@interface MZRefreshHeader ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIImageView *bgLogoView;
@property (nonatomic, strong) UIView *maskView;
// 遮罩波纹layer
@property (nonatomic, strong) CAShapeLayer *maskWaveLayer;
// 遮罩方形layer
@property (nonatomic, strong) CAShapeLayer *maskRectLayer;

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat waveWidth;
// 波的最高点到最低点高度
@property (nonatomic, assign) CGFloat waveHeight;
@property (nonatomic, assign) CGFloat bgWidth;
@property (nonatomic, assign) CGFloat bgHeight;

@end

@implementation MZRefreshHeader

- (void)prepare {
    [super prepare];
    self.bgWidth = 35;
    self.bgHeight = 35;
    self.offset = 0;
    self.speed = 0.5;
    self.waveHeight = self.bgHeight / 4.f;
    self.waveWidth = self.bgWidth;
    
    self.mj_h = 60;

    [self addSubview:self.bgLogoView];
    
    [self.bgLogoView addSubview:self.logoView];
    
    [self.maskView.layer addSublayer:self.maskWaveLayer];
    
    [self.maskView.layer addSublayer:self.maskRectLayer];
}

- (void)placeSubviews {
    [super placeSubviews];
    self.bgLogoView.center = CGPointMake(self.mj_w / 2.0, self.mj_h / 2.0 - 12);
    self.logoView.frame = self.bgLogoView.bounds = CGRectMake(0, 0, self.bgWidth, self.bgHeight);
    self.logoView.maskView = self.maskView;
 }

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
        {
            [self stopWave];
            [self.bgLogoView.layer removeAllAnimations];
            self.maskView.mj_y = self.bgHeight - self.waveHeight;
        }

            break;
        case MJRefreshStatePulling:
        {
            [self stopWave];
            self.maskView.mj_y = - self.waveHeight;
        }
            break;
        case MJRefreshStateRefreshing:
        {
            [self stopWave];
            CABasicAnimation *rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
            rotationAnimation.duration = 1;
            rotationAnimation.cumulative = YES;
            rotationAnimation.repeatCount = MAXFLOAT; 
            
            [self.bgLogoView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        }
            break;

        default:
            break;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    NSLog(@"--%f",pullingPercent);
    if (pullingPercent <= 1) {
        if (!self.link && pullingPercent > 0) {
            [self startWave];
        } else if (pullingPercent == 0) {
            [self stopWave];
        }
        self.maskView.mj_y = (1.f - pullingPercent) * self.bgHeight - self.waveHeight;
    } else {
        [self stopWave];
        self.maskView.mj_y = - self.waveHeight;
    }
}

- (void)endRefreshing{
    
    [super endRefreshing];
}

- (void)startWave {
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setupWave)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)stopWave {
    _offset = 0;
    [_link invalidate];
    _link = nil;
}

- (void)setupWave {
    
    _offset += _speed;
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat startY = 0.5f * _waveHeight*sinf(2.f*_offset*M_PI/_waveWidth+1.f/4.f*M_PI);
    CGPathMoveToPoint(path, NULL, 0, startY);
    
    NSInteger count = _waveWidth * [UIScreen mainScreen].scale;
    for (NSInteger x = 0; x <= count; x++) {
        CGFloat y = 0.5f * _waveHeight*sinf(1.5f*M_PI*(x/[UIScreen mainScreen].scale)/_waveWidth + 2.f*_offset*M_PI/_waveWidth+1.f/4.f*M_PI) + 0.5f*_waveHeight;
        CGPathAddLineToPoint(path, nil, x/[UIScreen mainScreen].scale, y);
    }
    
    CGPathAddLineToPoint(path, nil, self.maskWaveLayer.frame.size.width, _waveHeight + 1/[UIScreen mainScreen].scale);
    CGPathAddLineToPoint(path, nil, 0, _waveHeight + 1/[UIScreen mainScreen].scale);
    
    self.maskWaveLayer.path = path;
    
    CGPathRelease(path);
}

#pragma mark - setter & getter
- (UIImageView *)logoView {
    if (!_logoView) {
        _logoView = [[UIImageView alloc] init];
        _logoView.image = [UIImage imageNamed:@"orange"];
    }
    return _logoView;
}

- (UIImageView *)bgLogoView {
    if (!_bgLogoView) {
        _bgLogoView = [[UIImageView alloc] init];
        _bgLogoView.image = [UIImage imageNamed:@"gray"];
    }
    return _bgLogoView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.frame = CGRectMake(0, 35, self.bgWidth, self.bgHeight + self.waveHeight);
        _maskView.backgroundColor = [UIColor clearColor];
    }
    return _maskView;
}

- (CAShapeLayer *)maskWaveLayer {
    if (!_maskWaveLayer) {
        _maskWaveLayer = [[CAShapeLayer alloc] init];
        _maskWaveLayer.frame = CGRectMake(0, 0, self.bgWidth, self.waveHeight);
        _maskWaveLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _maskWaveLayer;
}

- (CAShapeLayer *)maskRectLayer {
    if (!_maskRectLayer) {
        _maskRectLayer = [[CAShapeLayer alloc] init];
        _maskRectLayer.frame = CGRectMake(0, self.waveHeight, self.bgWidth, self.bgHeight);
        _maskRectLayer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _maskRectLayer;
}

@end

@interface MZRefreshHeader1()

@property (nonatomic, strong) LOTAnimationView *logoView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MZRefreshHeader1
- (void)prepare {
    [super prepare];

    self.mj_h = 70;
    
    [self addSubview:self.logoView];
    [self addSubview:self.titleLabel];
}

- (void)placeSubviews {
    [super placeSubviews];
    self.logoView.center = CGPointMake(self.mj_w / 2.0, self.mj_h / 2.0 - 10);
    self.titleLabel.center = CGPointMake(self.mj_w / 2.0, 0);
    self.titleLabel.mj_y = CGRectGetMaxY(self.logoView.frame) + 10;
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
        {
            [self.logoView stop];
            self.logoView.animationProgress = 0;
        }
            
            break;
        case MJRefreshStatePulling:
        {
//            [self.logoView stop];
        }
            break;
        case MJRefreshStateRefreshing:
        {
            [self.logoView play];
        }
            break;
        default:
            break;
    }
}


- (void)setPullingPercent:(CGFloat)pullingPercent {
    if (pullingPercent > 1) {
        self.titleLabel.text = @"释放刷新";
    } else {
        self.titleLabel.text = @"下拉刷新";
    }
}

- (LOTAnimationView *)logoView {
    if (!_logoView) {
        _logoView = [LOTAnimationView animationNamed:@"data"];
        _logoView.bounds = CGRectMake(0, 0, 35, 35);
        _logoView.loopAnimation = true;
    }
    return _logoView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 14)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end

