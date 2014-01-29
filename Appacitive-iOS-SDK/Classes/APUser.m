//
//  APUser.m
//  Appacitive-iOS-SDK
//
//  Created by Kauserali on 07/01/13.
//  Copyright (c) 2013 Appacitive Software Pvt. Ltd. All rights reserved.
//

#import "APUser.h"
#import "Appacitive.h"
#import "APHelperMethods.h"
#import "NSString+APString.h"
#import "APConstants.h"
#import "APNetworking.h"

#define USER_PATH @"v1.0/user/"

static APUser* currentUser = nil;
static NSDictionary *headerParams;

@implementation APUser

+ (NSDictionary*)getHeaderParams
{
    headerParams = [NSDictionary dictionaryWithObjectsAndKeys:
                    [Appacitive getApiKey], APIkeyHeaderKey,
                    [Appacitive environmentToUse], EnvironmentHeaderKey,
                    currentUser.userToken, UserAuthHeaderKey,
                    @"application/json", @"Content-Type",
                    nil];
    return headerParams;
}

-(instancetype)init {
    return self = [super initWithTypeName:@"user"];
}

+ (APUser *) currentUser {
    return currentUser;
}

+ (void) setCurrentUser:(APUser *)user {
    currentUser = user;
}

#pragma mark - Authenticate methods

+ (void) authenticateUserWithUserName:(NSString*) userName password:(NSString*) password successHandler:(APUserSuccessBlock) successBlock {
    [APUser authenticateUserWithUserName:userName password:password successHandler:successBlock failureHandler:nil];
}

+ (void) authenticateUserWithUserName:(NSString*) userName password:(NSString*) password successHandler:(APUserSuccessBlock) successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingString:@"authenticate"];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSError *jsonError = nil;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   userName, @"username",
                                                                   password, @"password",
                                                                   nil]
                                                          options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPBody:requestBody];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        currentUser = [[APUser alloc] initWithTypeName:@"user"];
        [currentUser setPropertyValuesFromDictionary:result];
        if (successBlock) {
            successBlock(currentUser);
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

+ (void) authenticateUserWithFacebook:(NSString *)accessToken successHandler:(APUserSuccessBlock)successBlock {
    [APUser authenticateUserWithFacebook:accessToken successHandler:successBlock failureHandler:nil];
}

+ (void) authenticateUserWithFacebook:(NSString *) accessToken successHandler:(APUserSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingString:@"authenticate"];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSError *jsonError = nil;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   @"true",@"createNew",
                                                                   @"facebook",@"type",
                                                                   accessToken, @"accesstoken",
                                                                   nil] options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPBody:requestBody];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest
                              successHandler:^(NSDictionary *result) {
                                  currentUser = [[APUser alloc] initWithTypeName:@"user"];
                                  [currentUser setPropertyValuesFromDictionary:result];
                                  [currentUser setLoggedInWithFacebook:YES];
                                  if (successBlock) {
                                      successBlock(currentUser);
                                  }
                              } failureHandler:^(APError *error) {
                                  if (failureBlock != nil) {
                                      failureBlock(error);
                                  }
                              }];
}

+ (void) authenticateUserWithTwitter:(NSString*) oauthToken oauthSecret:(NSString*) oauthSecret successHandler:(APUserSuccessBlock) successBlock {
    [APUser authenticateUserWithTwitter:oauthToken oauthSecret:oauthSecret successHandler:successBlock failureHandler:nil];
}

+ (void) authenticateUserWithTwitter:(NSString*) oauthToken oauthSecret:(NSString*) oauthSecret successHandler:(APUserSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingString:@"authenticate"];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSError *jsonError = nil;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   @"true",@"createNew",
                                                                   @"twitter",@"type",
                                                                   oauthToken, @"oauthtoken",
                                                                   oauthSecret, @"oauthsecret",
                                                                   nil] options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPBody:requestBody];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest
                              successHandler:^(NSDictionary *result) {
                                  currentUser = [[APUser alloc] initWithTypeName:@"user"];
                                  [currentUser setPropertyValuesFromDictionary:result];
                                  [currentUser setLoggedInWithFacebook:YES];
                                  if (successBlock) {
                                      successBlock(currentUser);
                                  }
                              } failureHandler:^(APError *error) {
                                  if (failureBlock != nil) {
                                      failureBlock(error);
                                  }
                              }];
}

+ (void) authenticateUserWithTwitter:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APUserSuccessBlock)successBlock {
    [APUser authenticateUserWithTwitter:oauthToken oauthSecret:oauthSecret consumerKey:consumerKey consumerSecret:consumerSecret successHandler:successBlock failureHandler:nil];
}

+ (void) authenticateUserWithTwitter:(NSString *)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APUserSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingString:@"authenticate"];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSError *jsonError = nil;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   @"true",@"createNew",
                                                                   @"twitter",@"type",
                                                                   oauthToken, @"oauthtoken",
                                                                   oauthSecret, @"oauthsecret",
                                                                   consumerKey, @"consumerKey",
                                                                   consumerSecret, @"consumerSecret",
                                                                   nil] options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPBody:requestBody];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        currentUser = [[APUser alloc] initWithTypeName:@"user"];
        [currentUser setPropertyValuesFromDictionary:result];
        [currentUser setLoggedInWithFacebook:YES];
        if (successBlock) {
            successBlock(currentUser);
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Create methods

- (void) createUser {
    [self createUserWithSuccessHandler:nil failureHandler:nil];
}

- (void) createUserWithSuccessHandler:(APSuccessBlock) successBlock {
    [self createUserWithSuccessHandler:successBlock failureHandler:nil];
}

- (void) createUserWithSuccessHandler:(APSuccessBlock) successBlock failureHandler:(APFailureBlock) failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingString:@"create"];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSError *jsonError = nil;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:[self postParameters] options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPBody:requestBody];
    [urlRequest setHTTPMethod:@"PUT"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if (successBlock) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

- (void) createUserWithFacebook:(NSString*)token {
    
}

- (void) createUserWithFacebook:(NSString*)token failureHandler:(APFailureBlock)failureBlock {
    
}

- (void) createUserWithFacebook:(NSString*)token successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"create"];
    
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"PUT"];
    NSError *jsonError = nil;
    NSMutableDictionary *bodyDict = [self postParameters];
    NSDictionary *facebookdata = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"facebook",@"authtype",
                                  token,@"accesstoken",
                                  self.username,@"name",
                                  self.firstName,@"username",
                                  nil];
    [bodyDict setObject:facebookdata forKey:@"__link"];
    
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    [urlRequest setHTTPBody:requestBody];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if(successBlock != nil) {
            successBlock(result);
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

- (void) createUserWithTwitter:(NSString*)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret {
    
}

- (void) createUserWithTwitter:(NSString*)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret failureHandler:(APFailureBlock)failureBlock {
    
}

- (void) createUserWithTwitter:(NSString*)oauthToken oauthSecret:(NSString *)oauthSecret consumerKey:(NSString*)consumerKey consumerSecret :(NSString*) consumerSecret successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"create"];
    
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"PUT"];
    NSError *jsonError = nil;
    NSMutableDictionary *bodyDict = [self postParameters];
    NSDictionary *facebookdata = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"twitter",@"authtype",
                                  oauthToken,@"oauthtoken",
                                  oauthSecret,@"oauthtokensecret",
                                  consumerKey,@"consumerkey",
                                  consumerSecret,@"consumersecret",
                                  self.username,@"name",
                                  self.firstName,@"username",
                                  nil];
    [bodyDict setObject:facebookdata forKey:@"__link"];
    
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    [urlRequest setHTTPBody:requestBody];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if(successBlock != nil) {
            successBlock(result);
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Save methods

- (void) saveObject {
    [self saveObjectWithSuccessHandler:nil failureHandler:nil];
}

- (void) saveObjectWithFailureHandler:(APFailureBlock)failureBlock {
    [self saveObjectWithSuccessHandler:nil failureHandler:failureBlock];
}

- (void) saveObjectWithSuccessHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    NSString *path = [USER_PATH stringByAppendingFormat:@"create"];
    
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"PUT"];
    NSError *jsonError = nil;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:[self postParameters] options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    [urlRequest setHTTPBody:requestBody];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if(successBlock != nil) {
            successBlock(result);
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}


#pragma mark - Retrieve User methods

- (void)fetchUserById:(NSString *)userId {
    [self fetchUserById:userId successHandler:nil failureHandler:nil];
}

- (void) fetchUserById:(NSString *)userId successHandler:(APSuccessBlock) successBlock {
    [self fetchUserById:userId successHandler:successBlock failureHandler:nil];
}

- (void) fetchUserById:(NSString *)userId successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"%@",userId];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if (successBlock) {
            successBlock();
        }
        
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

- (void) fetchUserByUserName:(NSString *)userName {
    [self fetchUserByUserName:userName successHandler:nil failureHandler:nil];
}

- (void) fetchUserByUserName:(NSString *)userName successHandler:(APSuccessBlock)successBlock {
    [self fetchUserByUserName:userName successHandler:successBlock failureHandler:nil];
}

- (void) fetchUserByUserName:(NSString *)userName successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"%@?useridtype=username",userName];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if (successBlock) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

- (void) fetchUserWithUserToken:(NSString *)userToken {
    [self fetchUserWithUserToken:userToken successHandler:nil failureHandler:nil];
}

- (void) fetchUserWithUserToken:(NSString*)userToken successHandler:(APSuccessBlock)successBlock {
    [self fetchUserWithUserToken:userToken successHandler:successBlock failureHandler:nil];
}

- (void) fetchUserWithUserToken:(NSString*)userToken successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"me?useridtype=token&token=%@",userToken];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        APUser *user = [[APUser alloc] initWithTypeName:@"user"];
        [user setPropertyValuesFromDictionary:result];
        
        if (successBlock) {
            successBlock();
        }
        
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Update methods

- (void) updateObject {
    [self updateObjectWithRevisionNumber:nil successHandler:nil failureHandler:nil];
}

- (void) updateObjectWithSuccessHandler:(APUserSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self updateObjectWithRevisionNumber:nil successHandler:successBlock failureHandler:failureBlock];
}

- (void) updateObjectWithRevisionNumber:(NSNumber *)revision successHandler:(APUserSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"%@",self.objectId];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSError *jsonError = nil;
    NSMutableDictionary *updateData = [[NSMutableDictionary alloc] initWithDictionary:[self postParametersUpdate]];
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:updateData options:kNilOptions error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPBody:requestBody];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        APUser *user = [[APUser alloc] initWithTypeName:@"user"];
        [user setPropertyValuesFromDictionary:result];
        
        if (successBlock) {
            successBlock(user);
        }
    } failureHandler:^(APError *error) {
        
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            
            failureBlock(error);
        }
    }];
}

#pragma mark - Delete methods

- (void) deleteObject {
    [self deleteObjectWithSuccessHandler:nil failureHandler:nil];
}

- (void) deleteObjectWithConnectingConnections {
    [self deleteObjectWithSuccessHandler:nil failureHandler:nil deleteConnectingConnections:YES];
}

- (void) deleteObjectWithConnectingConnections:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:nil failureHandler:failureBlock deleteConnectingConnections:YES];
}

- (void) deleteObjectWithConnectingConnectionsSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self deleteObjectWithSuccessHandler:successBlock failureHandler:failureBlock deleteConnectingConnections:YES];
}

- (void) deleteObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock deleteConnectingConnections:(BOOL)deleteConnections {
    
    NSString *path = [[NSString alloc] init];
    
    path = [USER_PATH stringByAppendingFormat:@"%@", self.objectId];
    
    NSDictionary *queryParams = @{@"deleteconnections":deleteConnections?@"true":@"false"};
    path = [path stringByAppendingQueryParameters:queryParams];
    
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"DELETE"];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if(successBlock != nil) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

- (void) deleteObjectWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock) failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"%@",self.objectId];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"DELETE"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if(currentUser != nil) {
            if(self.objectId == currentUser.objectId) {
                currentUser = nil;
            }
        }
        if(successBlock != nil) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

- (void) deleteObjectWithUserName:(NSString*)userName
{
    [self deleteObjectWithUserName:userName successHandler:nil failureHandler:nil];
}

- (void) deleteObjectWithUserName:(NSString*)userName successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock
{
    NSString *path = [USER_PATH stringByAppendingFormat:@"%@?useridtype=username",userName];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"DELETE"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if (successBlock) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

+ (void) deleteCurrentlyLoggedInUser{
    [self deleteCurrentlyLoggedInUserWithSuccessHandler:nil failureHandler:nil];
}

+ (void) deleteCurrentlyLoggedInUserWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [currentUser deleteObjectWithSuccessHandler:successBlock failureHandler:failureBlock];
    currentUser = nil;
}

#pragma mark - Fetch methods

- (void) fetch {
    [self fetchWithQueryString:nil successHandler:nil failureHandler:nil];
}

- (void) fetchWithFailureHandler:(APFailureBlock)failureBlock {
    [self fetchWithQueryString:nil successHandler:nil failureHandler:failureBlock];
}

- (void) fetchWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    [self fetchWithQueryString:nil successHandler:successBlock failureHandler:failureBlock];
}

- (void) fetchWithQueryString:(NSString*)queryString successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [OBJECT_PATH stringByAppendingFormat:@"%@/%@", self.type, self.objectId];
    
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    
    if (queryString) {
        NSDictionary *queryStringParams = [queryString queryParameters];
        [queryStringParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [queryParams setObject:obj forKey:key];
        }];
    }
    
    path = [path stringByAppendingQueryParameters:queryParams];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        [self setPropertyValuesFromDictionary:result];
        if (successBlock != nil) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
        if(failureBlock != nil) {
            failureBlock(error);
        }
    }];
}


#pragma mark - Location Tracking Methods

+ (void) setUserLocationToLatitude:(NSString *)latitude longitude:(NSString *)longitude forUserWithUserId:(NSString *)userId {
    [self setUserLocationToLatitude:latitude longitude:longitude forUserWithUserId:userId successHandler:nil failureHandler:nil];
}

+ (void) setUserLocationToLatitude:(NSString *)latitude longitude:(NSString *)longitude forUserWithUserId:(NSString *)userId failureHandler:(APFailureBlock)failureBlock {
    [self setUserLocationToLatitude:latitude longitude:longitude forUserWithUserId:userId successHandler:nil failureHandler:failureBlock];
}

+ (void) setUserLocationToLatitude:(NSString *)latitude longitude:(NSString *)longitude forUserWithUserId:(NSString *)userId successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"%@/checkin?lat=%@&long=%@",userId,latitude,longitude];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if (successBlock) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Session management methods

+ (void) validateCurrentUserSessionWithSuccessHandler:(APResultSuccessBlock)successBlock {
    [self validateCurrentUserSessionWithSuccessHandler:successBlock failureHandler:nil];
}

+ (void) validateCurrentUserSessionWithSuccessHandler:(APResultSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"validate"];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        NSString *responseJSON = [NSString stringWithFormat:@"%@",[result objectForKey:@"result"]];
        if([responseJSON isEqualToString:@"1"])
        {
            if (successBlock) {
                successBlock(result);
            }
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

+ (void) logOutCurrentUser {
    [self logOutCurrentUserWithSuccessHandler:nil failureHandler:nil];
}

+ (void) logOutCurrentUserWithFailureHandler:(APFailureBlock)failureBlock {
    [self logOutCurrentUserWithSuccessHandler:nil failureHandler:failureBlock];
}

+(void) logOutCurrentUserWithSuccessHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"invalidate"];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        currentUser = nil;
        if (successBlock) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Password management methods

- (void) changePasswordFromOldPassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword {
    [self changePasswordFromOldPassword:oldPassword toNewPassword:newPassword successHandler:nil failureHandler:nil];
}

- (void) changePasswordFromOldPassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword failureHandler:(APFailureBlock)failureBlock {
    [self changePasswordFromOldPassword:oldPassword toNewPassword:newPassword successHandler:nil failureHandler:failureBlock];
}

- (void) changePasswordFromOldPassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"%@/changePassword",self.objectId];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSError *jsonError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                oldPassword, @"oldpassword",
                                                                newPassword, @"newpassword", nil]
                                                       options:0 error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if (successBlock) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

- (void) sendResetPasswordEmailWithSubject:(NSString *)emailSubject {
    [self sendResetPasswordEmailWithSubject:emailSubject successHandler:nil failureHandler:nil];
}

- (void) sendResetPasswordEmailWithSubject:(NSString *)emailSubject failureHandler:(APFailureBlock)failureBlock {
    [self sendResetPasswordEmailWithSubject:emailSubject successHandler:nil failureHandler:failureBlock];
}

- (void) sendResetPasswordEmailWithSubject:(NSString *)emailSubject successHandler:(APSuccessBlock)successBlock failureHandler:(APFailureBlock)failureBlock {
    
    NSString *path = [USER_PATH stringByAppendingFormat:@"sendresetpasswordemail"];
    path = [HOST_NAME stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:path];
    
    NSError *jsonError = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                self.username, @"username",
                                                                emailSubject,@"subject", nil]
                                                       options:0 error:&jsonError];
    if(jsonError != nil)
        DLog(@"\n––––––––––JSON-ERROR–––––––––\n%@",jsonError);
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];
    [urlRequest setAllHTTPHeaderFields:[APUser getHeaderParams]];
    
    APNetworking *nwObject = [[APNetworking alloc] init];
    [nwObject makeAsyncRequestWithURLRequest:urlRequest successHandler:^(NSDictionary *result) {
        if (successBlock) {
            successBlock();
        }
    } failureHandler:^(APError *error) {
		DLog(@"\n––––––––––––ERROR––––––––––––\n%@", error);
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

#pragma mark - Private methods

- (void) setLoggedInWithFacebook:(BOOL)loggedInWithFacebook {
    _loggedInWithFacebook = YES;
}

- (void) setLoggedInWithTwitter:(BOOL)loggedInWithTwitter {
    _loggedInWithTwitter = YES;
}

- (void) setPropertyValuesFromDictionary:(NSDictionary*) dictionary {
    if(dictionary[@"token"] != nil)
        _userToken = dictionary[@"token"];
    NSDictionary *object = [[NSDictionary alloc] init];
    if([[dictionary allKeys] containsObject:@"user"])
        object = dictionary[@"user"];
    else
        object = dictionary;
    self.createdBy = (NSString*) object[@"__createdby"];
    _objectId = object[@"__id"];
    _lastModifiedBy = (NSString*) object[@"__lastmodifiedby"];
    _revision = (NSNumber*) object[@"__revision"];
    self.typeId = object[@"__typeid"];
    _utcDateCreated = [APHelperMethods deserializeJsonDateString:object[@"__utcdatecreated"]];
    _utcLastUpdatedDate = [APHelperMethods deserializeJsonDateString:object[@"__utclastupdateddate"]];
    _attributes = [object[@"__attributes"] mutableCopy];
    self.tags = object[@"__tags"];
    self.type = object[@"__type"];
    
    self.username = object[@"username"];
    self.firstName = object[@"firstname"];
    self.lastName = object[@"lastname"];
    self.email = object[@"email"];
    self.birthDate = object[@"birthdate"];
    self.isEnabled = object[@"isenabled"];
    self.location = object[@"location"];
    self.phone = object[@"phone"];
    self.secretQuestion = object[@"secretquestion"];
    self.isEmailVerified = object[@"isemailverified"];
    self.isOnline = object[@"isonline"];
    
    _properties = [APHelperMethods arrayOfPropertiesFromJSONResponse:object].mutableCopy;
}

- (NSMutableDictionary*) postParameters {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];

    if (self.username)
        [postParams setObject:self.username forKey:@"username"];
    if (self.password)
        [postParams setObject:self.password forKey:@"password"];
    if (self.firstName)
        [postParams setObject:self.firstName forKey:@"firstname"];
    if (self.email)
        [postParams setObject:self.email forKey:@"email"];
    if (self.birthDate)
        [postParams setObject:self.birthDate forKey:@"birthdate"];
    if (self.lastName)
        [postParams setObject:self.lastName forKey:@"lastname"];
    if (self.location)
        [postParams setObject:self.location forKey:@"location"];
    if (self.isEnabled)
        [postParams setObject:self.isEnabled forKey:@"isenabled"];
    if (self.secretQuestion)
        [postParams setObject:self.secretQuestion forKey:@"secretquestion"];
    if (self.isEmailVerified)
        [postParams setObject:self.isEmailVerified forKey:@"isemailverified"];
    if (self.phone)
        [postParams setObject:self.phone forKey:@"phone"];
    if (self.isOnline)
        [postParams setObject:self.isOnline forKey:@"isonline"];
    if (self.objectId)
        postParams[@"__id"] = self.objectId;
    if (self.attributes)
        postParams[@"__attributes"] = self.attributes;
    if (self.createdBy)
        postParams[@"__createdby"] = self.createdBy;
    if (self.revision)
        postParams[@"__revision"] = self.revision;
    if (self.type)
        postParams[@"__type"] = self.type;
    if (self.tags)
        postParams[@"__tags"] = self.tags;
    for(NSDictionary *prop in self.properties) {
        [prop enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [postParams setObject:obj forKey:key];
            *stop = YES;
        }];
    }
    return postParams;
}

- (NSMutableDictionary*) postParametersUpdate {
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    if (self.username)
        [postParams setObject:self.username forKey:@"username"];
    if (self.password)
        [postParams setObject:self.password forKey:@"password"];
    if (self.firstName)
        [postParams setObject:self.firstName forKey:@"firstname"];
    if (self.email)
        [postParams setObject:self.email forKey:@"email"];
    if (self.birthDate)
        [postParams setObject:self.birthDate forKey:@"birthdate"];
    if (self.lastName)
        [postParams setObject:self.lastName forKey:@"lastname"];
    if (self.location)
        [postParams setObject:self.location forKey:@"location"];
    if (self.isEnabled)
        [postParams setObject:self.isEnabled forKey:@"isenabled"];
    if (self.secretQuestion)
        [postParams setObject:self.secretQuestion forKey:@"secretquestion"];
    if (self.isEmailVerified)
        [postParams setObject:self.isEmailVerified forKey:@"isemailverified"];
    if (self.phone)
        [postParams setObject:self.phone forKey:@"phone"];
    if (self.isOnline)
        [postParams setObject:self.isOnline forKey:@"isonline"];
    if (self.attributes && [self.attributes count] > 0)
        postParams[@"__attributes"] = self.attributes;
    for(NSDictionary *prop in self.properties) {
        [prop enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [postParams setObject:obj forKey:key];
            *stop = YES;
        }];
    }
    if(self.tagsToAdd && [self.tagsToAdd count] > 0)
        postParams[@"__addtags"] = [self.tagsToAdd allObjects];
    if(self.tagsToRemove && [self.tagsToRemove count] > 0)
        postParams[@"__removetags"] = [self.tagsToRemove allObjects];
    return postParams;
}

- (NSString*) description {
    NSString *description = [NSString stringWithFormat:@"User Token:%@, Object Id:%@, Created by:%@, Last modified by:%@, UTC date created:%@, UTC date updated:%@, Revision:%d, Properties:%@, Attributes:%@, TypeId:%d, type:%@, Tag:%@", self.userToken, self.objectId, self.createdBy, self.lastModifiedBy, self.utcDateCreated, self.utcLastUpdatedDate, [self.revision intValue], self.properties, self.attributes, [self.typeId intValue], self.type, self.tags];
    return description;
}

@end
