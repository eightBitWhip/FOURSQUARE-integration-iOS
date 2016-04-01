//
//  ViewController.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "ViewController.h"

#import "FSRequests.h"

@interface ViewController () <SearchRequestProtocol, ResponseProtocol>

@property (nonatomic) FSRequests *requests;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated{
    
    self.requests = [[FSRequests alloc] init];
    self.requests.searchNearDelegate = self;
    self.requests.responseDelegate = self;
    
    [self.requests searchNearWithTerm:@"London"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests DMs-

- (void)requestSuccededWithResults:(NSDictionary *)results {
    
    
    
}

- (void)requestFailedWithResponse:(NSDictionary *)response {
    
    
    
}

#pragma mark - Response DMs-

- (void)requestFailedWithErrorMessage:(NSString *)msg {
    
    
    
}

@end
