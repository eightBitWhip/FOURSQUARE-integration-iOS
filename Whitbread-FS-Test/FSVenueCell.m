//
//  FSVenueCell.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSVenueCell.h"

@implementation FSVenueCell

- (void)styleCell {
    
    self.contentView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.55];
    
}

- (void)presentCell {
    
    CGFloat selfCenterX = self.frame.size.width / 2.0;
    
    self.contentView.alpha = 0.0;
    self.contentView.center = CGPointMake(selfCenterX + 120.0, self.contentView.center.y);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = CGPointMake(selfCenterX, self.contentView.center.y);
        self.contentView.alpha = 1.0;
    }];
    
}

@end
