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

@interface RepoViewController () <UITableViewDataSource>

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *repoTableView;
@property (strong, nonatomic) NSMutableArray *repoData;

@end

@implementation RepoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate =  [[UIApplication sharedApplication] delegate];
	_repoData = [[NSMutableArray alloc] init];
	
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRepos:) name:@"ReceiveRepos" object:nil];
    
    [[_appDelegate networkController] fetchRepos:self];
    
}

-(void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:@"ReceiveRepos"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark
-(void)receiveRepos:(NSNotification *)sender {
    NSLog(@"Fired!");
        
    [self.repoTableView reloadData];
}

#pragma mark - Delegate
#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
	return _repoData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
	
	return cell;
}

@end
