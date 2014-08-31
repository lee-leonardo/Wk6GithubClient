//
//  UserViewController.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "ContactViewController.h"
#import "AppDelegate.h"
#import "ContactCollectionViewCell.h"

@interface ContactViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *userSearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionView;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSFetchedResultsController *resultsController;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = [[UIApplication sharedApplication] delegate];
    _resultsController = [[_appDelegate dataController] resultsController];
    _resultsController.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Methods
-(void)updateCell:(ContactCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    //Where the UIImage and the other important
}

#pragma mark - Delegates
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section {
    return [[[[_appDelegate dataController] resultsController] sections][section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ContactCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ContactCell" forIndexPath:indexPath];
    [self updateCell:cell withIndexPath:indexPath];
    
	return cell;
}

#pragma mark UISearchBar
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
//    searchBar.text
}

#pragma mark NSFetchedResults
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeMove:
            [[self userCollectionView] insertItemsAtIndexPaths:@[newIndexPath]];
            [[self userCollectionView] deleteItemsAtIndexPaths:@[indexPath]];
            break;
        case NSFetchedResultsChangeInsert:
            [[self userCollectionView] insertItemsAtIndexPaths:@[newIndexPath]];
            break;
        case NSFetchedResultsChangeDelete:
            [[self userCollectionView] deleteItemsAtIndexPaths:@[indexPath]];
        case NSFetchedResultsChangeUpdate:
            [[self userCollectionView] reloadItemsAtIndexPaths:@[indexPath]];
            break;
        default:
            break;
    }
    
}

@end
