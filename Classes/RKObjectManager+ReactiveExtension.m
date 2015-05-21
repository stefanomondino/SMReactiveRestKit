//
//  RKObjectManager+ReactiveExtension.m
//  Pods
//
//  Created by Stefano Mondino on 13/03/14.
//
//
#import <CoreData.h>
#import "RKObjectManager+ReactiveExtension.h"
#import <objc/runtime.h>


static const NSString* kSMReactiveRestKitMultipartData = @"kSMReactiveRestKitMultipartData";
static const NSString* kSMReactiveRestKitMultipartName = @"kSMReactiveRestKitMultipartName";
static const NSString* kSMReactiveRestKitMultipartFilename = @"kSMReactiveRestKitMultipartFilename";
static const NSString* kSMReactiveRestKitMultipartMIMEType = @"kSMReactiveRestKitMultipartMIMEType";



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

- (RACSignal*) rac_getObjectsAtPathForRouteNamed:(NSString*) routeName object:(id)object parameters:(NSDictionary*) parameters {
     NSURLRequest * request = [self requestWithPathForRouteNamed:routeName object:object parameters:parameters];
    return [self rac_getObjectsWithRequest:request];
}
- (RACSignal*) rac_getObjectsAtPathForRelationship:(NSString*) relationship object:(id)object method:(RKRequestMethod)method parameters:(NSDictionary*) parameters {
    NSURLRequest * request = [self requestWithPathForRelationship:relationship ofObject:object method:method parameters:parameters];
    return [self rac_getObjectsWithRequest:request];
}

- (RACSignal*) rac_getObjectsWithRequest:(NSURLRequest*) request {
    __weak RKObjectManager * manager = self;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RKObjectRequestOperation* operation = [manager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [subscriber sendNext:mappingResult];
            [subscriber sendCompleted];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        [manager enqueueObjectRequestOperation:operation];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];

}

- (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object{
    __weak RKObjectManager * manager = self;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        
        RKObjectRequestOperation* operation = [manager appropriateObjectRequestOperationWithObject:object method:method path:path parameters:parameters];
        [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [subscriber sendNext:mappingResult];
            [subscriber sendCompleted];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        
        [manager enqueueObjectRequestOperation:operation];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

- (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method multipartDictionary:(NSDictionary*) multipartDataDictionary managed:(BOOL) isManaged object:(id)object{
    __weak RKObjectManager * manager = self;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RKObjectRequestOperation *operation = nil;

        NSURLRequest* request = [manager multipartFormRequestWithObject:object method:method path:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:multipartDataDictionary[kSMReactiveRestKitMultipartData] name:multipartDataDictionary[kSMReactiveRestKitMultipartName] fileName:multipartDataDictionary[kSMReactiveRestKitMultipartFilename] mimeType:multipartDataDictionary[kSMReactiveRestKitMultipartMIMEType]];
        }];
        
        if (isManaged){
            operation =  (id)[manager managedObjectRequestOperationWithRequest:request managedObjectContext: manager.managedObjectStore.mainQueueManagedObjectContext success:nil failure:nil];
        }
        else {
            operation = [manager objectRequestOperationWithRequest:request success:nil failure:nil];
        }
        [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [subscriber sendNext:mappingResult];
            [subscriber sendCompleted];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        
        [manager enqueueObjectRequestOperation:operation];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}
@end


