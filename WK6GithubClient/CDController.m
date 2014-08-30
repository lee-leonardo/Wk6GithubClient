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

#pragma mark - Request and Sort
-(void)requestDataOfModelType:(NSString *)model {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:model];
    [request.sortDescriptors arrayByAddingObject:[self sortType:model]];
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                             managedObjectContext:_dataContext
                                                               sectionNameKeyPath:nil
                                                                        cacheName:nil];
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
-(void)repoParse:(NSData *)data {
    //NSLog(@"Repo data: %@", data);
    NSArray *repoDataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [Repository generateRepoData:repoDataArray withContext:_dataContext];
    
    //Below Subject to change:
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiveRepos" object:self];
}

@end
