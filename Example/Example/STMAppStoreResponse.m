//
//  STMAppStoreResponse.m
//  STMQuickRestKit
//
//  Created by Stefano Mondino on 21/03/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <RestKit.h>
#import "STMAppStoreResponse.h"
#import "STMAppStoreModel.h"
@implementation STMAppStoreResponse
+ (void)setupMapping:(RKEntityMapping *)mapping forBaseurl:(NSString *)baseurl {
 [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"results" toKeyPath:@"movies" withMapping:[STMAppStoreModel mappingForBaseurl:baseurl]]];
    [mapping addAttributeMappingsFromArray:@[@"resultCount"]];
}
@end
