//
//  RKObjectManager+ReactiveExtension.m
//  Pods
//
//  Created by Stefano Mondino on 13/03/14.
//
//
#import "CoreData.h"
#import "RKObjectManager+ReactiveExtension.h"
#import "ReactiveCocoa.h"
#import "EXTScope.h"
#import <objc/runtime.h>
#import <RACPassthroughSubscriber.h>
#import "RACSubscriber+Private.h"

static const NSString* kSMReactiveRestKitMultipartData = @"kSMReactiveRestKitMultipartData";
static const NSString* kSMReactiveRestKitMultipartName = @"kSMReactiveRestKitMultipartName";
static const NSString* kSMReactiveRestKitMultipartFilename = @"kSMReactiveRestKitMultipartFilename";
static const NSString* kSMReactiveRestKitMultipartMIMEType = @"kSMReactiveRestKitMultipartMIMEType";



/**
 Extension for base subscriber
 */
@interface RACSubscriber (SMReactiveRestkit)
@property (nonatomic, copy) void (^SM_progress)(id value);
- (void) SM_sendProgress:(NSNumber*) SM_progress;
@end

@implementation RACSubscriber(SMReactiveRestkit)
static const NSString* kSMReactiveRestKitAssociatedProgressBlock = @"kSMReactiveRestKitAssociatedProgressBlock";

- (void)setSM_progress:(void (^)(id))progress {
    objc_setAssociatedObject(self, &kSMReactiveRestKitAssociatedProgressBlock, progress, OBJC_ASSOCIATION_COPY);
}
- (void (^)(id))SM_progress {
    return objc_getAssociatedObject(self, &kSMReactiveRestKitAssociatedProgressBlock);
}
- (void)SM_sendProgress:(NSNumber *)progress {
    @synchronized (self) {
        self.SM_progress(progress);
    }
}
@end
/**

 */
@protocol RACSubscriberSMProgress
@optional
- (void) SM_sendProgress:(NSNumber*) progress;
@end


/**
 Make innerSubscriber visible (is private).
 @warning this could be dangerous!
 */
@interface RACPassthroughSubscriber (SMReactiveRestkit)
@property (nonatomic, strong, readonly) id<RACSubscriber, RACSubscriberSMProgress> innerSubscriber;
@end


@implementation RACSignal (SMReactiveRestkit)
- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock  progress:(void (^)(NSNumber *progress))progressBlock {
	NSCParameterAssert(nextBlock != NULL);
	NSCParameterAssert(errorBlock != NULL);
	NSCParameterAssert(progressBlock != NULL);	
	RACSubscriber *o = [RACSubscriber subscriberWithNext:nextBlock error:errorBlock completed:NULL];
    o.SM_progress = progressBlock;
	return [self subscribe:o];
}
@end


@implementation RKObjectManager (ReactiveExtension)

- (RACSignal*) rac_getPath:(NSString*) path parameters:(NSDictionary*) parameters {
    return [self rac_requestPath:path parameters:parameters method:RKRequestMethodGET];
}

- (RACSignal*) rac_postPath:(NSString*) path parameters:(NSDictionary*) parameters {
    return [self rac_requestPath:path parameters:parameters method:RKRequestMethodPOST];
}
- (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);

        RKObjectRequestOperation* operation = [self appropriateObjectRequestOperationWithObject:nil method:method path:path parameters:parameters];
        [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [subscriber sendNext:mappingResult];
            [subscriber sendCompleted];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        [operation.HTTPRequestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            if ([subscriber isKindOfClass:[RACPassthroughSubscriber class]] && [[(RACPassthroughSubscriber*)subscriber innerSubscriber] respondsToSelector:@selector(SM_sendProgress:)]){
            [[(RACPassthroughSubscriber*)subscriber innerSubscriber] SM_sendProgress:@((CGFloat)totalBytesRead/(CGFloat)totalBytesExpectedToRead)];
            }
        }];
        [self enqueueObjectRequestOperation:operation];
        return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
    }];
}

- (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method multipartDictionary:(NSDictionary*) multipartDataDictionary managed:(BOOL) isManaged {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RKObjectRequestOperation *operation = nil;
                    @strongify(self);
        NSURLRequest* request = [self multipartFormRequestWithObject:nil method:method path:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:multipartDataDictionary[kSMReactiveRestKitMultipartData] name:multipartDataDictionary[kSMReactiveRestKitMultipartName] fileName:multipartDataDictionary[kSMReactiveRestKitMultipartFilename] mimeType:multipartDataDictionary[kSMReactiveRestKitMultipartMIMEType]];
        }];
        
        if (isManaged){
            operation =  (id)[self managedObjectRequestOperationWithRequest:request managedObjectContext: self.managedObjectStore.mainQueueManagedObjectContext success:nil failure:nil];
        }
        else {
            operation = [self objectRequestOperationWithRequest:request success:nil failure:nil];
        }
        
        [self enqueueObjectRequestOperation:operation];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}
@end


