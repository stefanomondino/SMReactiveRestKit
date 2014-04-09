//
//  STMAppDelegate.m
//  STMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "STMAppDelegate.h"
#import "STMQuickObjectMapper.h"
#import <RKNSJSONSerialization.h>
@implementation STMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [STMQuickObjectMapper initWithBaseurl:BASEURL shouldUseCoreData:YES];
    [STMQuickObjectMapper registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/javascript"];
    BOOL rootMapping = NO;
    
    /*FOR EXAMPLE PURPOSES ONLY!*/
    
    /* Take a look at this remote json : 
     https://itunes.apple.com/search?attribute=movieTerm&country=us&entity=movie&media=movie&term=the
     
     According to your needs, you can decide to map the result as a single STMAppStoreResponse object which will eventually contain the list of movies in a NSArray, or directly map the keypath "results" to the array. The choice is up to you, just switch the rootMapping flag to try them both.
     
     */
     
     
     
    if (rootMapping){
        [STMAppStoreResponse mappingWithKeyPath:@"" forBaseurl:BASEURL path:SEARCH_PATH];
    }
    else {
        [STMAppStoreModel mappingWithKeyPath:@"results" forBaseurl:BASEURL path:SEARCH_PATH];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or STMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

@end
