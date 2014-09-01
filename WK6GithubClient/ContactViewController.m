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
@property BOOL notFirstTime;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_notFirstTime) {
        [[_appDelegate networkController] fetchUser];
        _notFirstTime = YES;
    } else {
        [[_appDelegate dataController] requestDataOfModelType:@"User"];
    }
    _resultsController = [[_appDelegate dataController] resultsController];
    _resultsController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUsers:) name:@"ReceiveUsers" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReceiveUsers" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Methods
-(void)receiveUsers:(NSNotification *)sender {
    NSLog(@"Users received!");
    [_userCollectionView reloadData];
    
}

-(void)updateCell:(ContactCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    //Where the UIImage and the other important
    User *user = [[[_appDelegate dataController] resultsController] fetchedObjects][indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[user imageURL]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    //CGSize size = image.size;
    
    cell.contactImageView.image = image;
}

#pragma mark - Delegates
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section {
    return [[[[_appDelegate dataController] resultsController] sections][section] numberOfObjects];
}

- (ContactCollectionViewCell *)collectionView:(UICollectionView *)collectionView
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

//This is the way that AshFurrow has done it. I do not know if this is the most suitable for this situation. I'll need to ask someone in class before I implement it. (As it requires some over head that isn't really suitable for this assignment.
//https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController/blob/master/AFMasterViewController.m
/*
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case <#constant#>:
            <#statements#>
            break;
            
        default:
            break;
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}
*/

@end
