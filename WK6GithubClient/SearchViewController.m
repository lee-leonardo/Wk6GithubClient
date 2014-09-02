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
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedSearch:) name:@"ReceivedSearch" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReceivedSearch" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Methods
-(void)receivedSearch:(NSNotification *)sender {
    NSLog(@"Received Search!");
    switch (_searchSearchBar.selectedScopeButtonIndex) {
        case 0:
            [[_appDelegate dataController] requestDataOfModelType:@"Repository"];
            break;
        case 1:
            [[_appDelegate dataController] requestDataOfModelType:@"User"];
            break;
        default:
            break;
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_searchTableView reloadData];
    }];
    
}

-(void)prepareCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
//    cell.textLabel.text
//    cell.detailTextLabel.text
}

#pragma mark - Delegates
#pragma mark UITableView
-(UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    [self prepareCell:cell withIndexPath:indexPath];
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[[[_appDelegate dataController] resultsController] sections][section] numberOfObjects];
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
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_searchTableView beginUpdates];
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_searchTableView endUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeUpdate:
            [_searchTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [_searchTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_searchTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeInsert:
            [_searchTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [_searchTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

@end
