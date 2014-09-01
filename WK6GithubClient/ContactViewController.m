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

//The recent changes in the app are due to the collection view lacking support for updating with a NSFetchedResults controller. The implementation is attributed to Ash Furrow: https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController/blob/master/AFMasterViewController.m
@implementation ContactViewController
{
    //Ivars are used in this case as they are more performant.
    //Properties contain a getter and the setter, which are not really needed for disposable reasons such as the object and section changes in this app.
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
    
}

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
    [[_appDelegate dataController] requestDataOfModelType:@"User"];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_userCollectionView reloadData];
    }];
}

-(void)updateCell:(ContactCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    //Where the UIImage and the other important
    User *user = [[[_appDelegate dataController] resultsController] fetchedObjects][indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[user imageURL]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        cell.contactImageView.image = image;
    }];
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
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[_appDelegate networkController] fetchContactsWithQuery:searchBar.text];
}

#pragma mark NSFetchedResults
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch (type) {
        case NSFetchedResultsChangeMove:
            //[[self userCollectionView] insertItemsAtIndexPaths:@[newIndexPath]];
            //[[self userCollectionView] deleteItemsAtIndexPaths:@[indexPath]];
            change[@(type)] = @[indexPath, newIndexPath];
            break;
        case NSFetchedResultsChangeInsert:
            //[[self userCollectionView] insertItemsAtIndexPaths:@[newIndexPath]];
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            //[[self userCollectionView] deleteItemsAtIndexPaths:@[indexPath]];
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            //[[self userCollectionView] reloadItemsAtIndexPaths:@[indexPath]];
            change[@(type)] = indexPath;
            break;
        default:
            break;
    }
    [_objectChanges addObject:change];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSMutableDictionary *change = [NSMutableDictionary new]; //Temp dictionary that records the type of change and records it on the queue of changes to be handled.
    switch (type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = @(sectionIndex);
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = @(sectionIndex);
            break;
        default:
            break;
    }
    [_sectionChanges addObject:change];
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    if ([_sectionChanges count] > 0) {
        [_userCollectionView performBatchUpdates:^{
            for (NSDictionary *change in _sectionChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [_userCollectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [_userCollectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [_userCollectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        default:
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([_objectChanges count] > 0 && [_sectionChanges count] == 0) {
        //This is circumvent a bug in the collectionView that hasn't been resolved.
        [_userCollectionView reloadData];
    } else {
        [_userCollectionView performBatchUpdates:^{
            for (NSDictionary *change in _objectChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [_userCollectionView insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [_userCollectionView deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [_userCollectionView reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [_userCollectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    
    
    [_objectChanges removeAllObjects];
    [_sectionChanges removeAllObjects];
}


@end
