//
//  AnimatedBGView.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedBGView : UIView

@property (nonatomic) NSString *gifName;

-(instancetype)initWithGifFileName:(NSString*)gif;
-(instancetype)initWithGifFileName:(NSString *)gif andFrame:(CGRect)frame;

-(instancetype)initWithVideoName:(NSString*)video;
-(instancetype)initWithVideoName:(NSString *)video andFrame:(CGRect)frame;

@end
