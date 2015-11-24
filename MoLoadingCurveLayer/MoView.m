//
//  MoView.m
//  StudyLayer
//
//  Created by admin on 15/11/20.
//  Copyright © 2015年 Meone. All rights reserved.
//

#import "MoView.h"
#import "MoCurveLayer.h"

#define DefaultColor [UIColor colorWithRed:60.0/255.0 green:151.0/255.0 blue:227.0/255.0 alpha:1.0]
#define ErrorColor [UIColor colorWithRed:221.0/255.0 green:39.0/255.0 blue:41.0/255.0 alpha:1.0]

#define kAnimationDuration 1.3
#define kTickDuratioin 0.6

@interface MoView ()

@property (copy, nonatomic) void(^successBlock)();
@property (copy, nonatomic) void(^errorBlock)();

// 开始加载
@property (nonatomic, strong) MoCurveLayer *moLayer;

//完成
@property (nonatomic, weak) CAShapeLayer *tickLayer;

@property (nonatomic, assign) NSUInteger isWaitingState;;

@end

@implementation MoView

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(52, 52);
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        self.isWaitingState = 0;
        
        self.moLayer = [[MoCurveLayer alloc] init];
        self.moLayer.bounds = self.bounds;
        self.moLayer.anchorPoint = CGPointZero;
        
        [self.layer addSublayer:self.moLayer];
        
    }
    return self;
}

#pragma mark - successLayer
- (CGPathRef)succesTickLine
{
    CGMutablePathRef tickPath = CGPathCreateMutable();
    CGPathMoveToPoint(tickPath, NULL, 15, 29);
    CGPathAddLineToPoint(tickPath, NULL, 22, 36);
    CGPathAddLineToPoint(tickPath, NULL, 39, 20);
    return tickPath;
}

- (void)addSuccessLayer
{
    CAShapeLayer *tickLayer = [[CAShapeLayer alloc] init];
    tickLayer.fillColor = nil;
    tickLayer.strokeColor = DefaultColor.CGColor;
    tickLayer.lineWidth = 4;
    tickLayer.miterLimit = 4;//斜接，大于线宽，线条衔接处会出现斜接角
    tickLayer.lineCap = kCALineCapRound;
    tickLayer.bounds = self.bounds;
    tickLayer.anchorPoint = CGPointZero;
    [self.layer addSublayer:tickLayer];
    self.tickLayer = tickLayer;
    
    CGPathRef path = [self succesTickLine];
    tickLayer.path = path;
    CGPathRelease(path);

    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(0.0);
    startAnimation.toValue = @(0.0);
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0.0);
    endAnimation.toValue = @(1.0);
    
    CAAnimationGroup *successAnimation = [CAAnimationGroup animation];
    successAnimation.animations = @[startAnimation, endAnimation];
    successAnimation.duration = kTickDuratioin;
    
    successAnimation.delegate = self;
    [successAnimation setValue:@"end" forKey:@"moAnimation"];
    successAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [tickLayer addAnimation:successAnimation forKey:nil];
}

#pragma mark - errorLayer
- (CGPathRef)errorTickLine
{
    CGMutablePathRef tickPath = CGPathCreateMutable();
    CGPathMoveToPoint(tickPath, NULL, 15, 15);
    CGPathAddLineToPoint(tickPath, NULL, 37, 37);
    CGPathMoveToPoint(tickPath, NULL, 37, 15);
    CGPathAddLineToPoint(tickPath, NULL, 15, 37);
    return tickPath;
}

- (void)addErrorLayer
{
    CAShapeLayer *tickLayer = [[CAShapeLayer alloc] init];
    tickLayer.fillColor = nil;
    tickLayer.strokeColor = ErrorColor.CGColor;
    tickLayer.lineWidth = 4;
    tickLayer.miterLimit = 4;//斜接，大于线宽，线条衔接处会出现斜接角
    tickLayer.lineCap = kCALineCapRound;
    tickLayer.bounds = self.bounds;
    tickLayer.anchorPoint = CGPointZero;
    [self.layer addSublayer:tickLayer];
    self.tickLayer = tickLayer;
    
    CGPathRef path = [self errorTickLine];
    tickLayer.path = path;
    CGPathRelease(path);
    
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(0.0);
    startAnimation.toValue = @(0.0);
    
    CABasicAnimation *endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(0.0);
    endAnimation.toValue = @(1.0);
    
    CAAnimationGroup *successAnimation = [CAAnimationGroup animation];
    successAnimation.animations = @[startAnimation, endAnimation];
    successAnimation.duration = kTickDuratioin;
    
    successAnimation.delegate = self;
    [successAnimation setValue:@"end" forKey:@"moAnimation"];
    successAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [tickLayer addAnimation:successAnimation forKey:nil];
}

#pragma mark - 三步动画
- (void)reset
{
    if (self.tickLayer) {
        [self.tickLayer removeFromSuperlayer];
    }
}

- (void)startLoading
{
    if (self.isWaitingState == 0) {
        [self reset];
        [self.moLayer reset];
        CABasicAnimation *firstAnimation = [self startCAAnimation];
        [self.moLayer applyAnimation:firstAnimation];
        self.isWaitingState = 1;
    }
}

- (CABasicAnimation *)startCAAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.fromValue = [NSNumber numberWithDouble:0.0];
    animation.toValue = [NSNumber numberWithDouble:kSuccessState];
    animation.duration = kAnimationDuration * kSuccessState;
    [animation setValue:@"start" forKey:@"moAnimation"];
    animation.delegate = self;
    return animation;
}

- (CABasicAnimation *)loadingProcessCAAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.fromValue = [NSNumber numberWithDouble:kSuccessState];
    animation.toValue = [NSNumber numberWithDouble:2.0 - (1 - kSuccessState)];
    animation.duration = kAnimationDuration;
    animation.repeatCount = HUGE_VAL;
    animation.removedOnCompletion = NO;
    [animation setValue:@"loading" forKey:@"moAnimation"];
    animation.delegate = self;
    return animation;
}

- (CABasicAnimation *)finishProcessCAAnimation:(CGFloat)startProgress
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.fromValue = [NSNumber numberWithDouble:startProgress];
    CGFloat end = 0;
    if (startProgress >= kSuccessState) {
        //start完成
        end = 1 - fabs(1.0-startProgress);
    } else {
        //start未完成
        end = fabs(1.0-startProgress);
    }
    CGFloat finishProcessing = (startProgress + end);
    [MoCurveLayer recordFinishProcessing:finishProcessing];
    animation.toValue = [NSNumber numberWithDouble:finishProcessing];
    animation.duration = end * kAnimationDuration;
    animation.delegate = self;
    [animation setValue:@"finish" forKey:@"moAnimation"];
    return animation;
}

//第一阶段动画完成,执行第二段无限重复动画
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        NSString *moAnimation = [anim valueForKey:@"moAnimation"];
        if (moAnimation && [moAnimation isEqualToString:@"start"]) {
            NSLog(@"start完成,开始loading");
            [self.moLayer applyAnimation:[self loadingProcessCAAnimation]];
        } else if([moAnimation isEqualToString:@"finish"]){
            NSLog(@"finish完成");
            if (self.isWaitingState == 2) {
                NSLog(@"成功");
                [self addSuccessLayer];
            } else {
                NSLog(@"失败");
                [self addErrorLayer];
            }
        } else if([moAnimation isEqualToString:@"end"]) {
            if (self.isWaitingState == 2) {
                if (self.successBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.successBlock();
                    });
                }
            } else {
                if (self.errorBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.errorBlock();
                    });
                }
            }
            self.isWaitingState = 0;
        }
    }
}


- (void)success:(void (^)(void))successBlock
{
    if(self.isWaitingState == 1) {
        self.moLayer.progress = [MoCurveLayer processing];
        [self.moLayer removeAllAnimations];
        [self.moLayer applyAnimation:[self finishProcessCAAnimation:self.moLayer.progress]];
        self.isWaitingState = 2;
        self.successBlock = successBlock;
    }
}

- (void)error:(void (^)(void))errorBlock
{
    if (self.isWaitingState == 1) {
        self.moLayer.progress = [MoCurveLayer processing];
        [self.moLayer removeAllAnimations];
        [self.moLayer applyAnimation:[self finishProcessCAAnimation:self.moLayer.progress]];
        self.isWaitingState = 3;
        self.errorBlock = errorBlock;
    }
}

@end
