//
//  FSButton.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSButton.h"

#import "Styles.h"

@implementation FSButton

- (void)awakeFromNib {
    
    [self styleButton];
    
}

- (void)styleButton {
    
    [self setBackgroundColor:STYLE_COLOUR];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //[self.layer setCornerRadius:8.0];
    //[self.layer setBorderWidth:3.0];
    //[self.layer setBorderColor:[self.titleLabel.textColor CGColor]];
    
    [self setClipsToBounds:YES];
    [self.titleLabel setText:[self.titleLabel.text uppercaseString]];
    
}

@end
