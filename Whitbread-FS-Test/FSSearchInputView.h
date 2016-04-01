//
//  FSSearchInputView.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchContainerProtocol <NSObject>

- (void)performSearchWithTerm:(NSString*)searchTerm;
- (void)invalidSearchInput;

@end

@interface FSSearchInputView : UIView

@property (weak, nonatomic) IBOutlet UITextField *searchInput;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchContainerTopContraint;

@property (nonatomic) id<SearchContainerProtocol>searchDelegate;

- (void)nudge;

@end
