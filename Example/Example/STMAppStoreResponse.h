//
//  STMAppStoreResponse.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 21/03/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "STMUnsavedModel.h"

@interface STMAppStoreResponse : STMUnsavedModel
@property (nonatomic,strong) NSArray* movies;
@property (nonatomic,strong) NSNumber* resultCount;
@end
