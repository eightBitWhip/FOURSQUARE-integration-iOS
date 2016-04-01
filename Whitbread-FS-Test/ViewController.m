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

#import "FSRequests.h"

@interface ViewController () <SearchRequestProtocol, ResponseProtocol, SearchContainerProtocol, SearchResultsTableProtocol>

@property (nonatomic) IBOutlet FSSearchResultsTable *resultsTable;

@property (weak, nonatomic) IBOutlet FSSearchInputView *searchInputContainer;

@property (nonatomic) FSRequests *requests;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.searchInputContainer.searchDelegate = self;
    self.resultsTable.tableDelegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self.resultsTable addPTR];
    [self.resultsTable setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
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

@end
