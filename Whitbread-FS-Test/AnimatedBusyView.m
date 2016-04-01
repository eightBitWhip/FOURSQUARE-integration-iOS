//
//  AnimatedBusyView.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "AnimatedBusyView.h"

#import "Styles.h"

#define FADING_SQUARES_FRAME_SIZE 180.0
#define FADING_SQUARES_SQUARE_SIZE 20.0
#define BAR_WIDTH 8.0
#define BAR_PADDING 2.0
#define MIN_ALPHA_VAL 0.0
#define MAX_ALPHA_VAL 1.0
#define MIN_BAR_HEIGHT 1.0
#define UPDATE_TIME 0.2
#define BAR_UPDATE_TIME 0.4
#define CHANCE_TO_CHANGE_ONE_IN 2

@interface BarLayer : CAShapeLayer

@property (nonatomic) CGPoint origin;

@property (nonatomic) BOOL isBottomBar;

@end

@implementation BarLayer

@end

@interface AnimatedBusyView()

@property (nonatomic) UIView *squareView, *spinningView;

@property (nonatomic) UILabel *loadingMessage;

@property (nonatomic) NSArray *squares;
@property (nonatomic) NSArray *bars;

@property (nonatomic) NSTimer *changeTimer;

@property (nonatomic) NSString *msg;

@end

@implementation AnimatedBusyView

-(instancetype)initWithHasFullLengthBorder:(BOOL)hasBorder{
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    if ( self = [super initWithFrame:frame] ) {
        
        if ( !self.msg ){
            self.msg = @"Loading";
        }
        
        self.backgroundColor = MODAL_BG_COLOUR;
        
        self.squareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FADING_SQUARES_FRAME_SIZE, FADING_SQUARES_FRAME_SIZE)];
        self.squareView.backgroundColor = [UIColor clearColor];
        [self.squareView setCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)];
        [self addSubview:self.squareView];
        
        CGRect labelFrame = ( hasBorder == YES ) ? CGRectMake(0, 0, FADING_SQUARES_FRAME_SIZE+6.0, FADING_SQUARES_SQUARE_SIZE) : CGRectMake(0, 0, FADING_SQUARES_FRAME_SIZE, FADING_SQUARES_SQUARE_SIZE*2.0);
        
        self.loadingMessage = [[UILabel alloc] initWithFrame:labelFrame];
        [self.loadingMessage setCenter:CGPointMake(FADING_SQUARES_FRAME_SIZE/2.0, FADING_SQUARES_FRAME_SIZE/2.0)];
        [self.loadingMessage setText:self.msg];
        [self.loadingMessage setBackgroundColor:[STYLE_COLOUR colorWithAlphaComponent:0.7]];
        [self.loadingMessage setTextAlignment:NSTextAlignmentCenter];
        [self.loadingMessage setTextColor:[UIColor whiteColor]];
        [self.loadingMessage setFont:[UIFont fontWithName:PRIMARY_FONT_FAMILY_BOLD size:20.0]];
        
        if ( hasBorder == YES ) {
            
            [self.loadingMessage.layer setBorderWidth:1.0];
            [self.loadingMessage.layer setBorderColor:[UIColor whiteColor].CGColor];
            [self.loadingMessage.layer setCornerRadius:4.0];
            
        }
        
        [self.squareView addSubview:self.loadingMessage];
        
    }
    
    return self;
    
}

-(instancetype)initWithFadingSquares{
    
    if ( self = [self initWithHasFullLengthBorder:NO] ) {
        
        self.squareView.clipsToBounds = YES;
        self.squareView.layer.cornerRadius = FADING_SQUARES_FRAME_SIZE/2.0;
        self.squareView.layer.borderWidth = 1.0;
        self.squareView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        NSMutableArray *squaresTemp = [NSMutableArray new];
        
        for ( int i = 0; i < (int)(FADING_SQUARES_FRAME_SIZE/FADING_SQUARES_SQUARE_SIZE); i++ ) {
            
            for ( int j = 0; j < (int)(FADING_SQUARES_FRAME_SIZE/FADING_SQUARES_SQUARE_SIZE); j++ ) {
                UIView *square = [[UIView alloc] initWithFrame:CGRectMake(FADING_SQUARES_SQUARE_SIZE*i, FADING_SQUARES_SQUARE_SIZE*j, FADING_SQUARES_SQUARE_SIZE, FADING_SQUARES_SQUARE_SIZE)];
                [square setBackgroundColor:STYLE_COLOUR];
                [self.squareView addSubview:square];
                [squaresTemp addObject:square];
            }
            
        }
        
        [self.squareView bringSubviewToFront:self.loadingMessage];
        
        self.squares = [NSArray arrayWithArray:squaresTemp];
        
        self.changeTimer = [NSTimer timerWithTimeInterval:UPDATE_TIME target:self selector:@selector(updateSquares) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.changeTimer forMode:NSRunLoopCommonModes];
        
        [self addSpinningViewAndSpin];
        
    }
    
    return self;
    
}

-(instancetype)initWithFadingSquaresAndMsg:(NSString *)msg{
    
    self.msg = msg;
    if ( self = [self initWithFadingSquares] ) {
        
    }
    
    return self;
    
}

-(void)addSpinningViewAndSpin{
    
    self.spinningView = [[UIView alloc] initWithFrame:self.squareView.frame];
    self.spinningView.backgroundColor = [UIColor clearColor];
    
    self.spinningView.layer.borderWidth = 3.0;
    self.spinningView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.spinningView.layer.cornerRadius = self.spinningView.frame.size.width/2.0;
    
    [self addSubview:self.spinningView];
    
    CAShapeLayer *littleCircle = [CAShapeLayer layer];
    littleCircle.fillColor = [UIColor whiteColor].CGColor;
    littleCircle.strokeColor = littleCircle.fillColor;
    littleCircle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.spinningView.frame.size.width, self.spinningView.frame.size.height/2.0) radius:8.0 startAngle:M_PI endAngle:M_PI-0.05 clockwise:YES].CGPath;
    [self.spinningView.layer addSublayer:littleCircle];
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [rotateAnimation setFromValue:@(0)];
    [rotateAnimation setToValue:@((M_PI * 2.0))];
    [rotateAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [rotateAnimation setRepeatCount:CGFLOAT_MAX];
    [rotateAnimation setDuration:1.0];
    [rotateAnimation setRemovedOnCompletion:NO];
    [rotateAnimation setFillMode:kCAFillModeBoth];
    [rotateAnimation setBeginTime:CACurrentMediaTime()];
    
    [self.spinningView.layer addAnimation:rotateAnimation forKey:@"spinner"];
    
}

-(void)finishedLoading{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0.0;
        for ( UIView *view in self.squares ) {
            [view setFrame:CGRectMake(view.center.x-1.0, view.center.y-1.0, 2.0, 2.0)];
        }
        
    } completion:^(BOOL finished){ [self removeFromSuperview]; }];
    
}

-(void)updateSquares{
    
    for ( UIView *square in self.squares ) {
        if ( (arc4random() % CHANCE_TO_CHANGE_ONE_IN + 1) == 1 ) {
            square.alpha = [self randomAlphaValue];
        }
    }
    
}

-(void)updateBars{
    
    for ( BarLayer *bar in self.bars ) {
        CGFloat newHeight = [self randomBarHeight];
        if ( bar.isBottomBar == YES ) newHeight *= -1;
        [self animateBar:bar toNewHeights:newHeight];
    }
    
}

-(void)animateBar:(BarLayer*)bar toNewHeights:(CGFloat)height{
    
    [bar removeAllAnimations];
    
    CGPathRef newPath = [self barPathWithStartPoint:bar.origin andHeight:height];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    [animation setFromValue:(id)bar.path];
    [animation setToValue:(__bridge id)newPath];
    [animation setDuration:BAR_UPDATE_TIME];
    [animation setRepeatCount:1];
    [animation setBeginTime:0];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    bar.path = newPath;
    
    [bar addAnimation:animation forKey:@"changemapath"];
    
}

-(BarLayer*)barWithStartPoint:(CGPoint)start andHeight:(CGFloat)height{
    
    BarLayer *bar = [BarLayer layer];
    bar.origin = start;
    bar.fillColor = [UIColor whiteColor].CGColor;
    bar.fillColor = [STYLE_COLOUR CGColor];
    bar.strokeColor = bar.fillColor;
    bar.path = [self barPathWithStartPoint:start andHeight:height];
    
    return bar;
    
}

-(CGPathRef)barPathWithStartPoint:(CGPoint)start andHeight:(CGFloat)height{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    [path addLineToPoint:CGPointMake(start.x, start.y - height)];
    [path addLineToPoint:CGPointMake(start.x + BAR_WIDTH, start.y - height)];
    [path addLineToPoint:CGPointMake(start.x + BAR_WIDTH, start.y)];
    [path closePath];
    
    return path.CGPath;
    
}

-(void)addGradientLayerToLayer:(CAShapeLayer*)shapeLayer{
    
    NSMutableArray *gradientColours = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        [gradientColours addObject:(id)[[UIColor colorWithWhite:1.0 alpha:(0.07 * i)] CGColor]];
    }
    
    CGRect pathBounds = CGPathGetBoundingBox(shapeLayer.path);
    pathBounds = CGRectMake(pathBounds.origin.x, pathBounds.origin.y, pathBounds.size.width, pathBounds.size.height);
    
    CAShapeLayer *gradientMask = [CAShapeLayer layer];
    gradientMask.fillColor = [STYLE_COLOUR CGColor];
    gradientMask.frame = CGRectMake(0, 0, pathBounds.size.width, pathBounds.size.height);
    gradientMask.path = shapeLayer.path;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, pathBounds.size.width, pathBounds.size.height);
    gradientLayer.colors = gradientColours;
    
    [gradientLayer setMask:gradientMask];
    [shapeLayer addSublayer:gradientLayer];
    
}

-(void)drawDots{
    
    self.spinningView = [[UIView alloc] initWithFrame:self.squareView.frame];
    self.spinningView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.spinningView];
    
    NSArray *colours = @[STYLE_COLOUR_TRANS(0.1), STYLE_COLOUR_TRANS(0.2), STYLE_COLOUR_TRANS(0.3), STYLE_COLOUR_TRANS(0.4), STYLE_COLOUR_TRANS(0.8), STYLE_COLOUR_TRANS(1.0)];
    
    NSArray *locations = @[[self aPointX:0 Y:-100.0], [self aPointX:90.0 Y:-40.0], [self aPointX:90.0 Y:40.0], [self aPointX:0 Y:100.0], [self aPointX:-90.0 Y:40.0], [self aPointX:-90.0 Y:-40.0]];
    
    CGPoint center = CGPointMake(self.spinningView.frame.size.width/2.0, self.spinningView.frame.size.height/2.0);
    
    for ( UIColor *colour in colours ) {
        
        CGPoint centerVals = [[locations objectAtIndex:[colours indexOfObject:colour]] CGPointValue];
        
        CAShapeLayer *dot = [CAShapeLayer layer];
        [dot setFillColor:[colour CGColor]];
        
        CGPathRef path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(center.x + centerVals.x, center.y + centerVals.y) radius:8.0 startAngle:M_PI endAngle:M_PI-0.01 clockwise:YES] CGPath];
        
        [dot setPath:path];
        
        [self.spinningView.layer addSublayer:dot];
        
    }
    
}

-(void)startSpinning{
    
    [self.layer removeAllAnimations];
    
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [spinAnimation setFromValue:@(0.0)];
    [spinAnimation setToValue:@(2*M_PI)];
    [spinAnimation setDuration:1.0];
    [spinAnimation setRepeatCount:INT32_MAX];
    [spinAnimation setBeginTime:CACurrentMediaTime()];
    [spinAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [spinAnimation setRemovedOnCompletion:NO];
    
    [self.spinningView.layer addAnimation:spinAnimation forKey:@"spinDots"];
    
}

-(NSValue*)aPointX:(CGFloat)x Y:(CGFloat)y{
    
    return [NSValue valueWithCGPoint:CGPointMake(x, y)];
    
}

-(CGFloat)randomBarHeight{
    
    CGFloat maxBarHeight = (FADING_SQUARES_FRAME_SIZE - FADING_SQUARES_SQUARE_SIZE) / 2.0;
    return (arc4random() % (int)(maxBarHeight - MIN_BAR_HEIGHT) + (int)(MIN_BAR_HEIGHT));
    
}

-(CGFloat)randomAlphaValue{
    
    return (arc4random() % ((int)(MAX_ALPHA_VAL * 10.0)) + ((int)(MIN_ALPHA_VAL*10.0)))/10.0;
    
}

@end
