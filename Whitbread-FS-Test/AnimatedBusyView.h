//
//  AnimatedBusyView.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedBusyView : UIView

-(instancetype)initWithFadingSquares;
-(instancetype)initWithFadingSquaresAndMsg:(NSString*)msg;

-(void)finishedLoading;

@end
