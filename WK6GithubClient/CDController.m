//
//  CDController.m
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/29/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CDController.h"
#import "AppDelegate.h"

@interface CDController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *dataContext;
@property (nonatomic, strong) NSFetchedResultsController *resultsController;

@end

@implementation CDController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _appDelegate = [[UIApplication sharedApplication] delegate];
        _dataContext = [_appDelegate managedObjectContext];
    }
    return self;
}

#pragma mark -
-(void)requestDataOfModelType:(NSString *)model {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:model];
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:<#(NSString *)#> ascending:YES];
//    [request sortDescriptors] = sort;
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                             managedObjectContext:_dataContext
                                                               sectionNameKeyPath:nil
                                                                        cacheName:nil];
    _resultsController.delegate = self;
}

#pragma mark - Parse Method
-(void)repoParse:(NSData *)data {
    //NSLog(@"Repo data: %@", data);
    NSArray *repoDataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [Repository generateRepoData:repoDataArray withContext:_dataContext];
    
    //Below Subject to change:
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveRepos" object:self];
}

@end
