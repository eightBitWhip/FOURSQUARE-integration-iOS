//
//  FSPullToRefresh.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSPullToRefresh.h"

#import "Styles.h"

#define FIRE_REQUIRE 100.0
#define MY_HEIGHT 80.0
#define CIRCLE_RADIUS 20.0
#define CIRCLE_WIDTH 3.0
#define CIRCLE_DESTINATION_DISTANCE 4.0

@interface FSPullToRefresh()

@property (nonatomic) BOOL firing, canFire;

@property (nonatomic) UILabel *releaseLabel;

@property (nonatomic) CAShapeLayer *shapeLayer, *bgShapeLayer;

@property (nonatomic) UITableView *myVeryOwnTableView;

@end

@implementation FSPullToRefresh

-(instancetype)initWithTableView:(UITableView *)table{
    
    if ( self = [super initWithFrame:CGRectMake(0, -MY_HEIGHT, table.frame.size.width, MY_HEIGHT)] ) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = STYLE_COLOUR;
        
        self.myVeryOwnTableView = table;
        
        self.bgShapeLayer = [CAShapeLayer layer];
        self.bgShapeLayer.fillColor = [UIColor colorWithWhite:0.1 alpha:0.5].CGColor;
        self.bgShapeLayer.strokeColor = self.bgShapeLayer.fillColor;
        [self.layer addSublayer:self.bgShapeLayer];
        
        self.firing = self.canFire = NO;
        self.releaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, MY_HEIGHT)];
        [self.releaseLabel setBackgroundColor:[UIColor clearColor]];
        [self.releaseLabel setTextColor:[UIColor whiteColor]];
        [self.releaseLabel setTextAlignment:NSTextAlignmentCenter];
        [self.releaseLabel setText:@"Release to refresh"];
        [self.releaseLabel setHidden:YES];
        [self.releaseLabel setFont:[UIFont fontWithName:PRIMARY_FONT_FAMILY_BOLD size:15.0]];
        [self addSubview:self.releaseLabel];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.opacity = 0.9;
        [self.layer addSublayer:self.shapeLayer];
        
    }
    
    return self;
    
}

-(void)updateViewWithOffset:(CGFloat)offset{
    
    if ( self.firing == NO ) {
        
        // update shape
        [self updateShapeWithOffset:offset];
        
        if ( offset > FIRE_REQUIRE && self.delegate ) {
            self.releaseLabel.hidden = NO;
            self.shapeLayer.opacity = 0.4;
            self.canFire = YES;
        }
        else {
            self.canFire = NO;
            self.releaseLabel.hidden = YES;
            self.shapeLayer.opacity = 0.9;
        }
        
    }
    
}

#define USE_ARROW_HEAD 1
#define ARROW_LENGTH_RAD 0.3
#define ARROW_SIDE_LENGTH 3.0

-(void)updateShapeWithOffset:(CGFloat)offset{
    
    if ( offset > FIRE_REQUIRE ) {
        offset = FIRE_REQUIRE;
    }
    
    CGFloat newAlpha = (1.0 / FIRE_REQUIRE) * offset;
    self.alpha = newAlpha;
    
    CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    CGFloat angleProportion = CIRCLE_DESTINATION_DISTANCE / (FIRE_REQUIRE / offset);
    CGFloat startPoint = M_PI_4;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(center.x + CIRCLE_RADIUS * cosf(startPoint), center.y + CIRCLE_RADIUS * sinf(startPoint))];
    [path addArcWithCenter:center radius:CIRCLE_RADIUS startAngle:startPoint endAngle:-angleProportion clockwise:NO];
    
    if ( USE_ARROW_HEAD ) {
        
        // add the head here!
        [path addLineToPoint:CGPointMake(center.x + (CIRCLE_RADIUS+ARROW_SIDE_LENGTH) * cosf(-angleProportion), center.y + (CIRCLE_RADIUS+ARROW_SIDE_LENGTH) * sinf(-angleProportion))];
        [path addLineToPoint:CGPointMake(center.x + (CIRCLE_RADIUS-(CIRCLE_WIDTH/2.0)) * cosf(-(angleProportion+ARROW_LENGTH_RAD)), center.y + (CIRCLE_RADIUS-(CIRCLE_WIDTH/2.0)) * sinf(-(angleProportion+ARROW_LENGTH_RAD)))];
        [path addLineToPoint:CGPointMake(center.x + (CIRCLE_RADIUS-ARROW_SIDE_LENGTH) * cosf(-angleProportion), center.y + (CIRCLE_RADIUS-ARROW_SIDE_LENGTH) * sinf(-angleProportion))];
        
    }
    
    [path addLineToPoint:CGPointMake(center.x + (CIRCLE_RADIUS-CIRCLE_WIDTH) * cosf(-angleProportion), center.y + (CIRCLE_RADIUS-CIRCLE_WIDTH) * sinf(-angleProportion))];
    [path addArcWithCenter:center radius:(CIRCLE_RADIUS-CIRCLE_WIDTH) startAngle:-angleProportion endAngle:startPoint clockwise:YES];
    [path closePath];
    
    self.shapeLayer.path = path.CGPath;
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:center radius:( (offset <= 30.0) ? offset : 30.0 ) startAngle:M_PI endAngle:M_PI-0.01 clockwise:YES];
    [self.bgShapeLayer setPath:bgPath.CGPath];
    
}

-(void)fire{
    
    // edge instets
    [self.myVeryOwnTableView setContentInset:UIEdgeInsetsMake(self.myVeryOwnTableView.contentInset.top + self.frame.size.height, self.myVeryOwnTableView.contentInset.left, self.myVeryOwnTableView.contentInset.bottom, self.myVeryOwnTableView.contentInset.right)];
    
    CGPathRef newPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:self.frame.size.width/1.6 startAngle:M_PI endAngle:(M_PI - 0.05) clockwise:YES].CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    [animation setFromValue:(__bridge id)self.bgShapeLayer.path];
    [animation setToValue:(__bridge id)newPath];
    [animation setDuration:0.5];
    [animation setRemovedOnCompletion:NO];
    [animation setBeginTime:CACurrentMediaTime()];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setDelegate:self];
    [animation setRepeatCount:1];
    
    [self.bgShapeLayer addAnimation:animation forKey:@"BoomCircle"];
    
}

-(void)releasedScrollView{
    
    if ( self.canFire == YES && self.delegate ) {
        
        self.firing = YES;
        [self fire];
        
    }
    
}

-(void)finishedUpdating{
    
    if ( self.firing == YES ) {
        
        [UIView animateWithDuration:0.6 animations:^{
            
            [self.myVeryOwnTableView setContentInset:UIEdgeInsetsMake(self.myVeryOwnTableView.contentInset.top - self.frame.size.height, self.myVeryOwnTableView.contentInset.left, self.myVeryOwnTableView.contentInset.bottom, self.myVeryOwnTableView.contentInset.right)];
            
        } completion:^(BOOL finished){
            self.firing = NO;
            self.canFire = NO;
        }];
        
    }
    
}

#pragma mark - CAAnim DMs-

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ( anim == [self.bgShapeLayer animationForKey:@"BoomCircle"] ) {
        
        [self.delegate readyForARefreshDontForgetToLetMeKnowWhenYouveFinished];
        
    }
    
}

@end
