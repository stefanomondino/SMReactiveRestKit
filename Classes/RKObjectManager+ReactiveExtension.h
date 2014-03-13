//
//  RKObjectManager+ReactiveExtension.h
//  Pods
//
//  Created by Stefano Mondino on 13/03/14.
//
//

#import "RKObjectManager.h"
#import "ReactiveCocoa.h"


@interface RACSignal (SMReactiveRestkit)
- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock  progress:(void (^)(NSNumber *progress))progressBlock ;
@end

@interface RKObjectManager (ReactiveExtension)
- (RACSignal*) rac_getPath:(NSString*) path parameters:(NSDictionary*) parameters;
- (RACSignal*) rac_postPath:(NSString*) path parameters:(NSDictionary*) parameters;
@end
