//
//  TMENetworkManager.m
//  ThreeMin
//
//  Created by Khoa Pham on 8/3/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "TMENetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@interface TMENetworkManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@end

@implementation TMENetworkManager

OMNIA_SINGLETON_M(sharedManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *baseURLString = [NSString stringWithFormat:@"%@%@", API_BASE_URL, API_PREFIX];
        NSURL *baseURL = [NSURL URLWithString:baseURLString];
        _requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];

        _requestManager.completionQueue = dispatch_queue_create("AFNetworkingCallbackQueue", DISPATCH_QUEUE_CONCURRENT);
        _requestManager.responseSerializer = [AFJSONResponseSerializer serializer];

        // Authorization
        NSString *access_token = [[TMEUserManager sharedInstance] getAccessToken];
        if (access_token) {
            NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", access_token];
            [_requestManager.requestSerializer setValue:authHeader
                                     forHTTPHeaderField:@"Authorization"];
        }

    }

    return self;
}

- (void)get:(NSString *)path
     params:(NSDictionary *)params
    success:(TMENetworkManagerJSONResponseSuccessBlock)success
    failure:(TMENetworkManagerFailureBlock)failure
{
    [self.requestManager GET:path
                  parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getModels:(Class)modelClass
             path:(NSString *)path
           params:(NSDictionary *)params success:(TMENetworkManagerArraySuccessBlock)success
          failure:(TMENetworkManagerFailureBlock)failure
{
    [[TMENetworkManager sharedManager] get:path
                                    params:params
                                   success:^(id responseObject)
     {
         NSArray *models = [modelClass tme_modelsFromJSONResponse:responseObject];
         if (success) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 success(models);
             });
         }
     } failure:^(NSError *error) {
         if (failure) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 failure(error);
             });
         }
     }];
}

@end
