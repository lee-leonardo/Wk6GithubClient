//
//  User.h
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/29/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * followersURL;
@property (nonatomic, retain) NSString * followingURL;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * organizationsURL;
@property (nonatomic, retain) NSNumber * publicRepos;
@property (nonatomic, retain) NSString * repos;
@property (nonatomic, retain) NSString * subscriptionsURL;

@end
