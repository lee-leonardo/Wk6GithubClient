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
@property (nonatomic, readwrite, strong) NSFetchedResultsController *resultsController;

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

#pragma mark - Request and Sort
-(void)requestDataOfModelType:(NSString *)model {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:model];
    NSSortDescriptor *sort = [self sortType:model];
    [request setSortDescriptors:@[sort]];
    
    [request.sortDescriptors arrayByAddingObject:[self sortType:model]];
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                             managedObjectContext:_dataContext
                                                               sectionNameKeyPath:nil
                                                                        cacheName:nil];
    NSError *error;
    [_resultsController performFetch:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    //Do I need this here? Ask!
    _resultsController.delegate = self;
}

-(NSSortDescriptor *)sortType:(NSString *)model {
    if ([model isEqualToString:@"Repository"]) {
        return [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES];
    } else if ([model isEqualToString:@"User"]) {
        return [NSSortDescriptor sortDescriptorWithKey:@"login" ascending:YES];
    } else {
        return nil;
    }
}

#pragma mark - Parse Methods
-(void)searchParse:(NSData *)data withType:(NSString *)type {
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@", searchDictionary);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedSearch" object:nil];
}

-(void)addedRepo:(NSData *)data {
    NSDictionary *newRepoDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [Repository generateRepoData:@[newRepoDictionary] withContext:_dataContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveRepos" object:nil];
}

-(void)repoParse:(NSData *)data {
    //NSLog(@"Repo data: %@", data);
    NSArray *repoDataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [Repository generateRepoData:repoDataArray withContext:_dataContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveRepos" object:self];
}

-(void)contactParse:(NSData *)data {
    NSDictionary *searchDataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *searchArray = searchDataDict[@"items"];
    [User generateContactsData:searchArray withContext:_dataContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveUsers" object:self];
    
}

@end
