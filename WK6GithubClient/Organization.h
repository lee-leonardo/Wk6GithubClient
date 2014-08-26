//
//  Organization.h
//  WK6GithubClient
//
//  Created by Leonardo Lee on 8/25/14.
//  Copyright (c) 2014 Leonardo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Organization : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * sort;
@property (nonatomic, retain) NSString * direction;

@end
