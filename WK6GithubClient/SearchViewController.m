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
@property (nonatomic, strong) NSManagedObjectContext *repoContext;

@end

@implementation SearchViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	_appDelegate = [[UIApplication sharedApplication] delegate];
    _repoContext = [_appDelegate managedObjectContext];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (![[NSUserDefaults standardUserDefaults] stringForKey:@"GithubOAuth"]) {
		[[_appDelegate networkController] githubAuthenticate];
	}
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)reloadRepos {
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Repository"];
//    NSError *error;
//    if (error) {
//        NSLog(@"%@", error.localizedDescription);
//    }
//}

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
