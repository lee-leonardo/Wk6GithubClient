//
//  SearchViewController.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	//This is only to debug the initialization of NetworkController
	_appDelegate = [[UIApplication sharedApplication] delegate];
	[[_appDelegate networkController] fetchResultsTest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegates
#pragma mark UITableView
-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return _searchList.count;
}

@end
