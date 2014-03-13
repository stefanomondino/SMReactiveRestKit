//
//  SMAppStoreModel.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import <SMUnsavedModel.h>

@interface SMAppStoreModel : SMUnsavedModel
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* artworkUrl;
@end
