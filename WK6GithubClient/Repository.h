//
//  Repository.h
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Repository : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * language;

@end
