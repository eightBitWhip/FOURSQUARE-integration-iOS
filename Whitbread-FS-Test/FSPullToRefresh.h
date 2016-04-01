//
//  FSPullToRefresh.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PullToRefreshDelegate <NSObject>

-(void)readyForARefreshDontForgetToLetMeKnowWhenYouveFinished;

@end

@interface FSPullToRefresh : UIView

@property (nonatomic) id<PullToRefreshDelegate>delegate;

-(instancetype)initWithTableView:(UITableView*)table;

-(void)updateViewWithOffset:(CGFloat)offset;
-(void)releasedScrollView;
-(void)finishedUpdating;

@end
