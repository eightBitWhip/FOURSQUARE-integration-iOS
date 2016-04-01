//
//  AnimatedBGView.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "AnimatedBGView.h"

@interface AnimatedBGView() <UIWebViewDelegate>

@end

@implementation AnimatedBGView

-(instancetype)initWithGifFileName:(NSString *)gif andFrame:(CGRect)frame{
    
    if ( self = [super initWithFrame:frame] ) {
        
        self.gifName = gif;
        [self addWebViewWithFrame:frame andGifName:self.gifName];
        
    }
    
    return self;
    
}

-(instancetype)initWithGifFileName:(NSString *)gif{
    
    // Frame = screen
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    if ( self = [self initWithGifFileName:gif andFrame:frame] ){}
    
    return self;
    
}

-(instancetype)initWithVideoName:(NSString *)video andFrame:(CGRect)frame{
    
    if ( self = [super initWithFrame:frame] ) {
        
    }
    
    return self;
    
}

-(instancetype)initWithVideoName:(NSString *)video{
    
    // Frame = screen
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    if ( self = [self initWithVideoName:video andFrame:frame] ){}
    
    return self;
    
}

-(void)awakeFromNib{
    
    if ( self.gifName ) {
        [self addWebViewWithFrame:self.frame andGifName:self.gifName];
    }
    
}

-(void)addWebViewWithFrame:(CGRect)frame andGifName:(NSString*)gif{
    
    UIWebView *imageContainerView = [[UIWebView alloc] initWithFrame:frame];
    [imageContainerView setUserInteractionEnabled:YES];
    [imageContainerView setBackgroundColor:[UIColor clearColor]];
    [imageContainerView.scrollView setScrollEnabled:NO];
    [self addSubview:imageContainerView];
    
    NSString *pathImg = [[NSBundle mainBundle] pathForResource:gif ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:pathImg];
    
    [imageContainerView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
}

#pragma mark - Web View DMs-

-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"started load!");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"finished load!");
}

@end
