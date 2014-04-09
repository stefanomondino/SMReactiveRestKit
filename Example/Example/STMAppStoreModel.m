//
//  SMAppStoreModel.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "STMAppStoreModel.h"

@implementation STMAppStoreModel
@dynamic name;
@dynamic artworkUrl;
@dynamic genre;
+ (void)setupMapping:(RKEntityMapping *)mapping forBaseurl:(NSString *)baseurl {
    [mapping addAttributeMappingsFromDictionary:@{@"primaryGenreName":@"genre",@"trackName":@"name",@"artworkUrl100":@"artworkUrl"}];
    
    //We could also map the "trackId" field from remote json and use it to uniquely identify a movie in the database instead of name + genre.
    [mapping setIdentificationAttributes:@[@"name",@"genre"]];
    
}
@end
