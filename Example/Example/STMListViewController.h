//
//  SMListViewController.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
/**
 Set in storyboard
 */
@property (nonatomic,assign) BOOL useCache;
@end
