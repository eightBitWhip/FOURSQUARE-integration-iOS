//
//  ViewController.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "ViewController.h"

#import "FSSearchResultsTable.h"
#import "FSSearchInputView.h"
#import "AnimatedBGView.h"

#import "FSRequests.h"

#define BG_IMAGE (@"beaut")

@interface ViewController () <SearchRequestProtocol, ResponseProtocol, SearchContainerProtocol, SearchResultsTableProtocol>

@property (nonatomic) IBOutlet FSSearchResultsTable *resultsTable;

@property (weak, nonatomic) IBOutlet FSSearchInputView *searchInputContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapButtonWidthConstraint;

@property (nonatomic) FSRequests *requests;

@property (nonatomic) BOOL bgInitComplete;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.searchInputContainer.searchDelegate = self;
    self.resultsTable.tableDelegate = self;
    
    self.bgInitComplete = NO;
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self.resultsTable addPTR];
    [self.resultsTable setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    if ( self.bgInitComplete == NO ) {
        AnimatedBGView *animatedBg = [[AnimatedBGView alloc] initWithGifFileName:BG_IMAGE];
        [self.view insertSubview:animatedBg atIndex:0];
        self.bgInitComplete = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)attemptSearchWithValue:(NSString*)searchTerm {
    
    if ( !self.requests ) {
        self.requests = [[FSRequests alloc] init];
        self.requests.searchNearDelegate = self;
        self.requests.responseDelegate = self;
    }
    
    [self.requests searchNearWithTerm:searchTerm];
    
}

#pragma mark - Requests DMs-

- (void)requestSuccededWithResults:(NSDictionary *)results {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapButtonWidthConstraint.constant = 100.0;
        [self.resultsTable updateWithResults:results];
    });
    
}

- (void)requestFailedWithResponse:(NSDictionary *)response {
    
    
    
}

#pragma mark - Response DMs-

- (void)requestFailedWithErrorMessage:(NSString *)msg {
    
    
    
}

#pragma mark - SearchBar DMs-

- (void)performSearchWithTerm:(NSString *)searchTerm {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self attemptSearchWithValue:searchTerm];
    });
    
}

- (void)invalidSearchInput {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.resultsTable finishedUpdating];
    });
}

#pragma mark - ResultsTable DMs-

- (void)tableRequestedUpdate {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchInputContainer nudge]; //!!
    });
    
}

- (void)selectedVenue:(FSVenue *)venue {
    
    
    
}

@end
