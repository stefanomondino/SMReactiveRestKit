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

#ifdef SM_EXPERIMENTAL_PROGRESS
#import <RACPassthroughSubscriber.h>
#import "RACSubscriber+Private.h"

#endif
static const NSString* kSMReactiveRestKitMultipartData = @"kSMReactiveRestKitMultipartData";
static const NSString* kSMReactiveRestKitMultipartName = @"kSMReactiveRestKitMultipartName";
static const NSString* kSMReactiveRestKitMultipartFilename = @"kSMReactiveRestKitMultipartFilename";
static const NSString* kSMReactiveRestKitMultipartMIMEType = @"kSMReactiveRestKitMultipartMIMEType";


#ifdef SM_EXPERIMENTAL_PROGRESS
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
 Make innerSubscriber visible (is private by default).
 @warning this could be dangerous if anything in RACPassthroughSubscriber will change in future!
 */
@interface RACPassthroughSubscriber (SMReactiveRestkit)
@property (nonatomic, strong, readonly) id<RACSubscriber, RACSubscriberSMProgress> innerSubscriber;
@end


@implementation RACSignal (SMReactiveRestkit)

- (RACDisposable *)subscribeNext:(void (^)(id))nextBlock error:(void (^)(NSError *))errorBlock progress:(void (^)(NSNumber *))progressBlock {
    return [self subscribeNext:nextBlock error:errorBlock progress:progressBlock completed:NULL];
}
- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock  progress:(void (^)(NSNumber *progress))progressBlock completed:(void (^)(void))completedBlock{
	RACSubscriber *subscriber = [RACSubscriber subscriberWithNext:nextBlock error:errorBlock completed:completedBlock];
    subscriber.SM_progress = progressBlock;
	return [self subscribe:subscriber];
}
@end
#endif

@implementation RKObjectManager (ReactiveExtension)

- (RACSignal*) rac_getPath:(NSString*) path parameters:(NSDictionary*) parameters{
    return [self rac_requestPath:path parameters:parameters method:RKRequestMethodGET object:nil ];
}

- (RACSignal*) rac_postPath:(NSString*) path parameters:(NSDictionary*) parameters {
    return [self rac_requestPath:path parameters:parameters method:RKRequestMethodPOST object:nil];
}
- (RACSignal*) rac_deletePath:(NSString*) path parameters:(NSDictionary*) parameters {
    return [self rac_requestPath:path parameters:parameters method:RKRequestMethodDELETE object:nil];
}
- (RACSignal*) rac_putPath:(NSString*) path parameters:(NSDictionary*) parameters {
    return [self rac_requestPath:path parameters:parameters method:RKRequestMethodPUT object:nil];
}
- (RACSignal*) rac_patchPath:(NSString*) path parameters:(NSDictionary*) parameters {
    return [self rac_requestPath:path parameters:parameters method:RKRequestMethodPATCH object:nil];
}
- (RACSignal*) rac_headPath:(NSString*) path parameters:(NSDictionary*) parameters {
    return [self rac_requestPath:path parameters:parameters method:RKRequestMethodHEAD object:nil];
}
- (RACSignal*) rac_optionsPath:(NSString*) path parameters:(NSDictionary*) parameters {
    return [self rac_requestPath:path parameters:parameters method:RKRequestMethodOPTIONS object:nil];
}
+ (NSDictionary*) multipartDataDictionaryWithData:(NSData*) data formName:(NSString*) formName fileName:(NSString*) fileName mimeType:(NSString*) mimeType {
    if (!data || !formName || !fileName || !mimeType) return nil;
    return  @{kSMReactiveRestKitMultipartData:data,kSMReactiveRestKitMultipartFilename:fileName,kSMReactiveRestKitMultipartName:formName,kSMReactiveRestKitMultipartMIMEType:mimeType};
    
}

- (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        RKObjectRequestOperation* operation = [self appropriateObjectRequestOperationWithObject:object method:method path:path parameters:parameters];
        [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [subscriber sendNext:mappingResult];
            [subscriber sendCompleted];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        
#ifdef SM_EXPERIMENTAL_PROGRESS
        [operation.HTTPRequestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            if ([subscriber isKindOfClass:[RACPassthroughSubscriber class]] && [[(RACPassthroughSubscriber*)subscriber innerSubscriber] respondsToSelector:@selector(SM_sendProgress:)]){
                [[(RACPassthroughSubscriber*)subscriber innerSubscriber] SM_sendProgress:@((CGFloat)totalBytesRead/(CGFloat)totalBytesExpectedToRead)];
            }
        }];
#endif
        [self enqueueObjectRequestOperation:operation];
        return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
    }];
}

- (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method multipartDictionary:(NSDictionary*) multipartDataDictionary managed:(BOOL) isManaged object:(id)object{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RKObjectRequestOperation *operation = nil;
        @strongify(self);
        NSURLRequest* request = [self multipartFormRequestWithObject:object method:method path:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:multipartDataDictionary[kSMReactiveRestKitMultipartData] name:multipartDataDictionary[kSMReactiveRestKitMultipartName] fileName:multipartDataDictionary[kSMReactiveRestKitMultipartFilename] mimeType:multipartDataDictionary[kSMReactiveRestKitMultipartMIMEType]];
        }];
        
        if (isManaged){
            operation =  (id)[self managedObjectRequestOperationWithRequest:request managedObjectContext: self.managedObjectStore.mainQueueManagedObjectContext success:nil failure:nil];
        }
        else {
            operation = [self objectRequestOperationWithRequest:request success:nil failure:nil];
        }
        [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [subscriber sendNext:mappingResult];
            [subscriber sendCompleted];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
#ifdef SM_EXPERIMENTAL_PROGRESS
        [operation.HTTPRequestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            if ([subscriber isKindOfClass:[RACPassthroughSubscriber class]] && [[(RACPassthroughSubscriber*)subscriber innerSubscriber] respondsToSelector:@selector(SM_sendProgress:)]){
                [[(RACPassthroughSubscriber*)subscriber innerSubscriber] SM_sendProgress:@((CGFloat)totalBytesRead/(CGFloat)totalBytesExpectedToRead)];
            }
        }];
#endif
        
        [self enqueueObjectRequestOperation:operation];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}
@end


