//
//  SMAppStoreModel.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "SMAppStoreModel.h"

@implementation SMAppStoreModel
+ (void)setupMapping:(RKObjectMapping *)mapping forBaseurl:(NSString *)baseurl {
    [mapping addAttributeMappingsFromDictionary:@{@"trackName":@"name",@"artworkUrl100":@"artworkUrl"}];
}
- (NSString*) description {
    return self.name;
}
@end
