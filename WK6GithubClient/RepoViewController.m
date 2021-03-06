//
//  RepoViewController.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import "RepoViewController.h"
#import "AppDelegate.h"
#import "NetworkController.h"

@interface RepoViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *repoTableView;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSFetchedResultsController *resultsController;
@property (strong, nonatomic) UIAlertController *createRepoController;

@property BOOL notFirstTime;

@end

@implementation RepoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate =  [[UIApplication sharedApplication] delegate];
   _createRepoController = [self generateCreateAC];
    
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRepos:) name:@"ReceiveRepos" object:nil];
    
    if (!_notFirstTime) {
        [[_appDelegate networkController] fetchRepos:self];
        _notFirstTime = YES;
    } else {
        [self receiveRepos:nil];
    }
    _resultsController = [[_appDelegate dataController] resultsController];
    _resultsController.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:@"ReceiveRepos"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Methods
-(UIAlertController *)generateCreateAC {
    UIAlertController *createAlert = [UIAlertController alertControllerWithTitle:@"Create Repo?"
                                                                          message:@"This button allows you to create a repo:"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    [createAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name here:";
    }];
                                      
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *entry = [[createAlert textFields] firstObject];
        [[_appDelegate networkController] createRepoWithName:entry.text];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [createAlert addAction:done];
    [createAlert addAction:cancel];
    
    return createAlert;
}

- (IBAction)createNewRepo:(id)sender {
    NSLog(@"New Repo!");
    [self presentViewController:_createRepoController animated:YES completion:nil];
}

-(void)receiveRepos:(NSNotification *)sender {
    NSLog(@"Received Repos!");
    [[_appDelegate dataController] requestDataOfModelType:@"Repository"];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.repoTableView reloadData];
    }];
}

-(void)updateCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    Repository *repo = [[[_appDelegate dataController] resultsController] fetchedObjects][indexPath.row];
    cell.textLabel.text = [repo fullName];
    cell.detailTextLabel.text = [repo language];
}

#pragma mark - Delegate
#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return [[[[_appDelegate dataController] resultsController] sections][section] numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    [self updateCell:cell forIndexPath:indexPath];
	
	return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark NSFetchedResults
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self repoTableView] beginUpdates];
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self repoTableView] endUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [[self repoTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [[self repoTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self repoTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [[self repoTableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self repoTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

@end
