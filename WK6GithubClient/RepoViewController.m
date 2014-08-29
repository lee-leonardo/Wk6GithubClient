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

@property (weak, nonatomic) IBOutlet UITableView *repoTableView;
@property (strong, nonatomic) NSMutableArray *repoData;

@end

@implementation RepoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_repoData = [[NSMutableArray alloc] init];
	
}
-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    AppDelegate *appDelegate =  [[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRepos:) name:@"ReceiveRepos" object:nil];
    
    //How?
    [[NSNotificationCenter defaultCenter] addObserver:[appDelegate networkController] selector:@selector(fetchRepos:) name:@"GetRepo" object:nil];

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetRepos" object:nil];
    }];
    
    [[appDelegate networkController] fetchRepos:self];
    
}
-(void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:@"ReceiveRepos"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"GetRepo"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
-(void)receiveRepos:(id)sender {
    NSLog(@"Fired!");
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
