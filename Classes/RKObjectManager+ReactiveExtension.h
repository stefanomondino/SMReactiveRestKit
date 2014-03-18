//
//  RKObjectManager+ReactiveExtension.h
//  Pods
//
//  Created by Stefano Mondino on 13/03/14.
//
//

#import "RKObjectManager.h"
#import "ReactiveCocoa.h"

/**
 Additions to RACSignal to include 'sendProgress' method to keep track of download progress during download.
*/
@interface RACSignal (SMReactiveRestkit)
- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock  progress:(void (^)(NSNumber *progress))progressBlock ;
- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock error:(void (^)(NSError *error))errorBlock  progress:(void (^)(NSNumber *progress))progressBlock completed:(void (^)(void))completedBlock  ;
@end


/**
    ReactiveRestkit implementations.
 */
@interface RKObjectManager (ReactiveExtension)

/**
 Performs an object request operation on specified path and parameters
 A next/completed message is sent to subscriber upon download and mapping completion, with a RKMappingResult as object result.
 An error message is sent to subscriber when any error occurs.
 A progress message is sent with a NSNumber* value to keep track of download progress.
 Returns a signal that will cancel the download operation upon disposal
 @param path: The path to be appended to the HTTP client's baseURL and set as the URL of the request. If nil, the router is consulted.
 @param parameters: The parameters to be either set as a query string for `GET` requests, or reverse merged with the parameterization of the object and set as the request HTTP body.
 @param method: The request method for the request.
 @param object: The object with which to construct the object request operation. May be nil.
 
 @return: A RACSignal that will cancel the download operation when manually disposed
 
 @see RACSignal(SMReactiveRestKit)
 
 */
- (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object;

/**
 Performs an object request operation on specified path,parameters and multipart data dictionary (for file upload).
 A next/completed message is sent to subscriber upon download and mapping completion, with a RKMappingResult as object result.
 An error message is sent to subscriber when any error occurs.
 A progress message is sent with a NSNumber* value to keep track of download progress.
 Returns a signal that will cancel the download operation upon disposal
 @param path: The path to be appended to the HTTP client's baseURL and set as the URL of the request. If nil, the router is consulted.
 @param parameters: The parameters to be either set as a query string for `GET` requests, or reverse merged with the parameterization of the object and set as the request HTTP body.
 @param method: The request method for the request.
 @param multipartDataDictionary: a multipart data dictionary that should always be created with RKObjectMapper multipartDataDictionaryWithData:formName:fileName:mimeType
 @param isManaged: A boolean to identify if resulting mapping will be stored in CoreData or not.
 @param object: The object with which to construct the object request operation. May be nil.
 
 @return: A RACSignal that will cancel the download operation when manually disposed
 
 @see RACSignal(SMReactiveRestKit)
 
 */
- (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method multipartDictionary:(NSDictionary*) multipartDataDictionary managed:(BOOL) isManaged object:(id)object;

/**
 Creates a NSDictionary to be sent with request as a multipart data dictionary
 
 @param data: Data to store on remote server
 @param formName: Name of form field
 @param fileName: Filename for file when stored on server
 @param mimeType: MimeType of data
 
 @return: A multipart dictionary.
 */
+ (NSDictionary*) multipartDataDictionaryWithData:(NSData*) data formName:(NSString*) formName fileName:(NSString*) fileName mimeType:(NSString*) mimeType;


/**
 Convenience method for GET
 @see (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object
 */
- (RACSignal*) rac_getPath:(NSString*) path parameters:(NSDictionary*) parameters;

/**
 Convenience method for POST
 @see (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object
 */
- (RACSignal*) rac_postPath:(NSString*) path parameters:(NSDictionary*) parameters;

/**
 Convenience method for DELETE
 @see (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object
 */
- (RACSignal*) rac_deletePath:(NSString*) path parameters:(NSDictionary*) parameters;

/**
 Convenience method for PUT
 @see (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object
 */
- (RACSignal*) rac_putPath:(NSString*) path parameters:(NSDictionary*) parameters;

/**
 Convenience method for PATCH
 @see (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object
 */
- (RACSignal*) rac_patchPath:(NSString*) path parameters:(NSDictionary*) parameters;

/**
 Convenience method for HEAD
 @see (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object
 */
- (RACSignal*) rac_headPath:(NSString*) path parameters:(NSDictionary*) parameters;

/**
 Convenience method for OPTIONS
 @see (RACSignal*) rac_requestPath:(NSString*) path parameters:(NSDictionary*) parameters method:(RKRequestMethod) method object:(id)object
 */
- (RACSignal*) rac_optionsPath:(NSString*) path parameters:(NSDictionary*) parameters;



@end
