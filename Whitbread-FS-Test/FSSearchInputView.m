//
//  FSSearchInputView.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSSearchInputView.h"

#import "InputValidator.h"

@interface FSSearchInputView() <UITextFieldDelegate>

@end

@implementation FSSearchInputView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setupView];
    
    [self.searchInput becomeFirstResponder];
    
}

- (void)setupView {
    
    self.searchInput.delegate = self;
    self.searchContainerTopContraint.constant = ([UIScreen mainScreen].bounds.size.height / 2.0) - (self.frame.size.height / 2.0);
    
}

- (void)moveToTop {
    
    self.searchContainerTopContraint.constant = 0.0;
    [self setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
    
}

- (void)attemptSearchWithValue:(NSString*)searchTerm {
    
    if ( self.searchDelegate && [InputValidator locationSearchTermIsValid:searchTerm] ) {
        
        if ( [InputValidator locationSearchTermIsValid:searchTerm] ) {
            
            [self moveToTop];
        
            [self.searchInput resignFirstResponder];
            [self.searchDelegate performSearchWithTerm:searchTerm];
            
        }
        else {
            [self.searchDelegate invalidSearchInput];
        }
        
    }
    
}

- (void)nudge {
    
    [self textFieldShouldReturn:self.searchInput];
    
}

#pragma mark - Textfield DMs-

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ( textField == self.searchInput ) {
        [self attemptSearchWithValue:textField.text];
    }
    
    return NO;
    
}

@end
