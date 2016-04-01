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
    
}

- (void)setupView {
    
    self.searchInput.delegate = self;
    
}

- (void)attemptSearchWithValue:(NSString*)searchTerm {
    
    if ( self.searchDelegate && [InputValidator locationSearchTermIsValid:searchTerm] ) {
        
        if ( [InputValidator locationSearchTermIsValid:searchTerm] ) {
        
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
