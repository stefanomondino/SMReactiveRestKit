//
//  STMAppDelegate.h
//  STMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMAppStoreModel.h"
#import "STMAppStoreResponse.h"
#define BASEURL @"https://itunes.apple.com/"
#define SEARCH_PATH @"search"



@interface STMAppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic,strong) UIWindow* window;


@end
