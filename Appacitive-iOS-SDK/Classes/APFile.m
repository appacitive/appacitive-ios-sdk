//
//  APFile.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali Hafizji on 10/09/12.
//  Copyright (c) 2012 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APFile.h"
#import "Appacitive.h"
#import "APHelperMethods.h"
#import "APError.h"
#import "NSString+APString.h"
#import "APConstants.h"

//#define FILE_PATH @"file/"

@implementation APFile

#pragma mark UPLOAD_METHODS

+ (void) uploadFileWithName:(NSString *)name data:(NSData *)data validUrlForTime:(NSNumber *)minutes {
    [APFile uploadFileWithName:name data:data validUrlForTime:minutes contentType:nil successHandler:nil failureHandler:nil];
}

+ (void) uploadFileWithName:(NSString *)name data:(NSData *)data validUrlForTime:(NSNumber *)minutes contentType:(NSString *)contentType {
    [APFile uploadFileWithName:name data:data validUrlForTime:minutes contentType:contentType successHandler:nil failureHandler:nil];
}

+ (void) uploadFileWithName:(NSString *)name data:(NSData *)data validUrlForTime:(NSNumber *)minutes contentType:(NSString *)contentType successHandler:(APResultSuccessBlock)successBlock {
    [APFile uploadFileWithName:name data:data validUrlForTime:minutes contentType:contentType successHandler:successBlock failureHandler:nil];
}

+ (void) uploadFileWithName:(NSString *)name data:(NSData *)data validUrlForTime:(NSNumber *)minutes contentType:(NSString *)contentType successHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APResultSuccessBlock successBlockCopy = [successBlock copy];
        
        NSURL *url = [NSURL URLWithString:@"https://apis.appacitive.com/file/uploadurl"];
        
        NSMutableDictionary *params = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest),
                                             @"filename":name,
                                             @"expires":minutes,
                                             @"apiKey":[Appacitive getApiKey]}.mutableCopy;
        
        if(contentType) {
            [params setObject:contentType forKey:@"contenttype"];
        }
        
        if(NSClassFromString(@"NSURLSession")) {
            NSURLSessionConfiguration *sessionConfig =
            [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.allowsCellularAccess = YES;
            [sessionConfig setHTTPAdditionalHeaders: params];
            sessionConfig.timeoutIntervalForRequest = 30.0;
            sessionConfig.timeoutIntervalForResource = 60.0;
            sessionConfig.HTTPMaximumConnectionsPerHost = 1;
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
            
            [[session dataTaskWithURL:url
                    completionHandler:^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                        if(!error) {
                            NSError *jsonError;
                            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                            if(!jsonError) {
                                APError *error = [APHelperMethods checkForErrorStatus:response];
                                
                                BOOL isErrorPresent = (error != nil);
                                
                                if (!isErrorPresent) {
                                    NSDictionary *fetchUploadUrlResponse = response;
                                    NSString *url = [fetchUploadUrlResponse objectForKey:@"url"];
                                    
                                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                                    [request setURL:[NSURL URLWithString:url]];
                                    [request setHTTPMethod:@"PUT"];
                                    
                                    NSString *stringContentType = @"application/octet-stream";
                                    if (contentType) {
                                        stringContentType = contentType;
                                    }
                                    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                                    
                                    NSMutableData *body = [NSMutableData data];
                                    [body appendData:[NSData dataWithData:data]];
                                    [request setHTTPBody:body];
                                    
                                    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                                    
                                    [NSURLConnection sendAsynchronousRequest:request
                                                                       queue:queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error){
                                                                           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)res;
                                                                           if ([httpResponse statusCode] == 200 && successBlockCopy != nil) {
                                                                               successBlockCopy(response);
                                                                           }
                                                                       }];
                                } else {
                                    if (failureBlockCopy != nil) {
                                        failureBlockCopy(error);
                                    }
                                }                            } else {
                                DLog(@"%@", jsonError);
                                if (failureBlockCopy != nil) {
                                    failureBlockCopy((APError*) error);
                                }
                            }
                        } else {
                            DLog(@"%@", error);
                            if (failureBlockCopy != nil) {
                                failureBlockCopy((APError*) error);
                            }
                        }
                    }] resume];
        } else {
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if(!error) {
                    NSError *jsonError;
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    if(!jsonError) {
                        APError *error = [APHelperMethods checkForErrorStatus:response];
                        
                        BOOL isErrorPresent = (error != nil);
                        
                        if (!isErrorPresent) {
                            NSDictionary *fetchUploadUrlResponse = response;
                            NSString *url = [fetchUploadUrlResponse objectForKey:@"url"];
                            
                            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                            [request setURL:[NSURL URLWithString:url]];
                            [request setHTTPMethod:@"PUT"];
                            
                            NSString *stringContentType = @"application/octet-stream";
                            if (contentType) {
                                stringContentType = contentType;
                            }
                            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                            
                            NSMutableData *body = [NSMutableData data];
                            [body appendData:[NSData dataWithData:data]];
                            [request setHTTPBody:body];
                            
                            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                            
                            [NSURLConnection sendAsynchronousRequest:request
                                                               queue:queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error){
                                                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)res;
                                                                   if ([httpResponse statusCode] == 200 && successBlockCopy != nil) {
                                                                       successBlockCopy(response);
                                                                   }
                                                               }];
                        } else {
                            if (failureBlockCopy != nil) {
                                failureBlockCopy(error);
                            }
                        }                    } else {
                        DLog(@"%@", jsonError);
                        if (failureBlockCopy != nil) {
                            failureBlockCopy((APError*) error);
                        }
                    }
                } else {
                    DLog(@"%@", error);
                    if (failureBlockCopy != nil) {
                        failureBlockCopy((APError*) error);
                    }
                }
            }];
        }
        
//        //Using MKNetworkKit
//        NSString *path = [FILE_PATH stringByAppendingString:@"uploadurl"];
//        
//        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest),
//                                             @"filename":name,
//                                             @"expires":minutes}.mutableCopy;
//        if(contentType) {
//            [queryParams setObject:contentType forKey:@"contenttype"];
//        }
//        path = [path stringByAppendingQueryParameters:queryParams];
//        
//        MKNetworkOperation *fetchUploadUrl = [sharedObject operationWithPath:path params:nil httpMethod:@"GET" ssl:YES];
//        [APHelperMethods addHeadersToMKNetworkOperation:fetchUploadUrl];
//        
//        [fetchUploadUrl onCompletion:^(MKNetworkOperation *completedOperation) {
//            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
//            
//            BOOL isErrorPresent = (error != nil);
//            
//            if (!isErrorPresent) {
//                NSDictionary *fetchUploadUrlResponse = completedOperation.responseJSON;
//                NSString *url = [fetchUploadUrlResponse objectForKey:@"url"];
//        
//                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//                [request setURL:[NSURL URLWithString:url]];
//                [request setHTTPMethod:@"PUT"];
//                
//                NSString *stringContentType = @"application/octet-stream";
//                if (contentType) {
//                    stringContentType = contentType;
//                }
//                [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//                
//                NSMutableData *body = [NSMutableData data];
//                [body appendData:[NSData dataWithData:data]];
//                [request setHTTPBody:body];
//                
//                NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//                
//                [NSURLConnection sendAsynchronousRequest:request
//                                 queue:queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error){
//                                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)res;
//                                     if ([httpResponse statusCode] == 200 && successBlockCopy != nil) {
//                                         successBlockCopy(completedOperation.responseJSON);
//                                     }
//                                 }];
//            } else {
//                if (failureBlockCopy != nil) {
//                    failureBlockCopy(error);
//                }
//            }
//
//        } onError:^(NSError *error) {
//            if (failureBlockCopy != nil) {
//                failureBlockCopy((APError*)error);
//            }
//        }];
//        
//        [sharedObject enqueueOperation:fetchUploadUrl];

    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}

#pragma mark DOWNLOAD_METHODS

+ (void) downloadFileWithName:(NSString*)name validUrlForTime:(NSNumber*)minutes successHandler:(APFileDownloadSuccessBlock) successBlock {
    [APFile downloadFileWithName:name validUrlForTime:minutes successHandler:successBlock failureHandler:nil];
}

+ (void) downloadFileWithName:(NSString*)name validUrlForTime:(NSNumber*)minutes successHandler:(APFileDownloadSuccessBlock) successBlock failureHandler:(APFailureBlock)failureBlock {
    
    Appacitive *sharedObject = [Appacitive sharedObject];
    APFailureBlock failureBlockCopy = [failureBlock copy];
    
    if (sharedObject.session) {
        APFileDownloadSuccessBlock successBlockCopy = [successBlock copy];
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://apis.appacitive.com/file/download/%@",name]];
        
        NSMutableDictionary *params = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest),
                                        @"expires":minutes,
                                        @"apiKey":[Appacitive getApiKey]}.mutableCopy;
        
        if(NSClassFromString(@"NSURLSession")) {
            NSURLSessionConfiguration *sessionConfig =
            [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.allowsCellularAccess = YES;
            [sessionConfig setHTTPAdditionalHeaders: params];
            sessionConfig.timeoutIntervalForRequest = 30.0;
            sessionConfig.timeoutIntervalForResource = 60.0;
            sessionConfig.HTTPMaximumConnectionsPerHost = 1;
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
            
            [[session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                        if(!error) {
                            NSError *jsonError;
                            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:location options:NSJSONReadingAllowFragments error:&jsonError];
                            if(!jsonError) {
                                APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
                                
                                BOOL isErrorPresent = (error != nil);
                                
                                if (!isErrorPresent) {
                                    NSDictionary *result = completedOperation.responseJSON;
                                    NSString *uri = [result objectForKey:@"uri"];
                                    
                                    
                                } else {
                                    if (failureBlockCopy != nil) {
                                        failureBlockCopy(error);
                                    }
                                }                            } else {
                                    DLog(@"%@", jsonError);
                                    if (failureBlockCopy != nil) {
                                        failureBlockCopy((APError*) error);
                                    }
                                }
                        } else {
                            DLog(@"%@", error);
                            if (failureBlockCopy != nil) {
                                failureBlockCopy((APError*) error);
                            }
                        }
                    }] resume];
        } else {
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if(!error) {
                    NSError *jsonError;
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    if(!jsonError) {
                        APError *error = [APHelperMethods checkForErrorStatus:response];
                        
                        BOOL isErrorPresent = (error != nil);
                        
                        if (!isErrorPresent) {
                            NSDictionary *fetchUploadUrlResponse = response;
                            NSString *url = [fetchUploadUrlResponse objectForKey:@"url"];
                            
                            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                            [request setURL:[NSURL URLWithString:url]];
                            [request setHTTPMethod:@"PUT"];
                            
                            NSString *stringContentType = @"application/octet-stream";
                            if (contentType) {
                                stringContentType = contentType;
                            }
                            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
                            
                            NSMutableData *body = [NSMutableData data];
                            [body appendData:[NSData dataWithData:data]];
                            [request setHTTPBody:body];
                            
                            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                            
                            [NSURLConnection sendAsynchronousRequest:request
                                                               queue:queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error){
                                                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)res;
                                                                   if ([httpResponse statusCode] == 200 && successBlockCopy != nil) {
                                                                       successBlockCopy(response);
                                                                   }
                                                               }];
                        } else {
                            if (failureBlockCopy != nil) {
                                failureBlockCopy(error);
                            }
                        }                    } else {
                            DLog(@"%@", jsonError);
                            if (failureBlockCopy != nil) {
                                failureBlockCopy((APError*) error);
                            }
                        }
                } else {
                    DLog(@"%@", error);
                    if (failureBlockCopy != nil) {
                        failureBlockCopy((APError*) error);
                    }
                }
            }];
        }
        
        //Using MKNetworkKit
        NSString *path = [FILE_PATH stringByAppendingFormat:@"download/%@", name];
        
        NSMutableDictionary *queryParams = @{@"debug":NSStringFromBOOL(sharedObject.enableDebugForEachRequest),
                                            @"expires":minutes}.mutableCopy;

        path = [path stringByAppendingQueryParameters:queryParams];
        
        MKNetworkOperation *downloadOperation = [sharedObject operationWithPath:path params:nil httpMethod:@"GET" ssl:YES];
        [APHelperMethods addHeadersToMKNetworkOperation:downloadOperation];
        
        [downloadOperation onCompletion:^(MKNetworkOperation *completedOperation) {
            APError *error = [APHelperMethods checkForErrorStatus:completedOperation.responseJSON];
            
            BOOL isErrorPresent = (error != nil);
            
            if (!isErrorPresent) {
                NSDictionary *result = completedOperation.responseJSON;
                NSString *uri = [result objectForKey:@"uri"];
                
                MKNetworkOperation *downloadDataRequest = [[MKNetworkOperation alloc] initWithURLString:uri params:nil httpMethod:@"GET"];
                [downloadDataRequest onCompletion:^(MKNetworkOperation *completedOperation) {
                    if (successBlockCopy) {
                        successBlockCopy(completedOperation.responseData);
                    }
                } onError:^(NSError *error) {
                    if (failureBlockCopy != nil) {
                        failureBlockCopy((APError*)error);
                    }
                }];
                [sharedObject enqueueOperation:downloadDataRequest];
            } else {
                if (failureBlockCopy != nil) {
                    failureBlockCopy(error);
                }
            }
            
        } onError:^(NSError *error) {
            if (failureBlockCopy != nil) {
                failureBlockCopy((APError*)error);
            }
        }];
        
        [sharedObject enqueueOperation:downloadOperation];
    } else {
        DLog(@"Initialize the Appactive object with your API_KEY in the - application: didFinishLaunchingWithOptions: method of the AppDelegate");
        if (failureBlockCopy != nil) {
            failureBlockCopy([APHelperMethods errorForSessionNotCreated]);
        }
    }
}
@end
