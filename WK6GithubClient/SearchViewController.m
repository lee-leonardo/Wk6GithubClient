//
//  SearchViewController.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchSearchBar;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (strong, nonatomic) NSFetchedResultsController *resultsController;

@end

@implementation SearchViewController

-(void)viewDidLoad {
    [super viewDidLoad];
	_appDelegate = [[UIApplication sharedApplication] delegate];
    _resultsController = [[_appDelegate dataController] resultsController];
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

#pragma mark - Delegates
#pragma mark UITableView
-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    //Need to embed the context, which will need to checked as the context will not be set on launch.
//    if (<#condition#>) {
//        <#statements#>
//    }
    
    return 10;
}

#pragma mark UISearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSInteger button = searchBar.selectedScopeButtonIndex;
    NSString *query = searchBar.text;
    
    switch (button) {
        case 0:
            //Search for Repo
            [[_appDelegate networkController] searchForQuery:query withType:@"Repositories"];
            break;
        case 1:
            //Search for User
            [[_appDelegate networkController] searchForQuery:query withType:@"Users"];
            break;
            
        default:
            break;
    }
    
}

#pragma mark NSFetchedResults

@end
