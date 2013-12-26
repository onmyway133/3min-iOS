//
//  TMETransactionManager.m
//  PhotoButton
//
//  Created by Toan Slan on 12/23/13.
//
//

#import "TMETransactionManager.h"

@implementation TMETransactionManager

SINGLETON_MACRO

- (void)getListMessageOfProduct:(TMEProduct *)product
                      fromBuyer:(TMEUser *)fromBuyer
                         toUser:(TMEUser *)toUser
                 onSuccessBlock:(void (^)(NSArray *))successBlock
                andFailureBlock:(TMEJSONRequestFailureBlock)failureBlock{

    NSDictionary *params = [[NSDictionary alloc] init];
    if (toUser) {
        params = @{
                   @"to" : toUser.id,
                   @"access_token" : [[TMEUserManager sharedInstance] getAccessToken]
                   };
    }
    else{
       params = @{
                  @"access_token" : [[TMEUserManager sharedInstance] getAccessToken]
                  };
    }
    
    NSString *path = [NSString stringWithFormat:@"%@%@%@/%@%@",API_SERVER_HOST,API_PREFIX,API_PRODUCTS,product.id,API_CHATS];
    
    [[TMEHTTPClient sharedClient] getPath:path
                               parameters:params
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSArray *arrTransaction = [TMETransaction arrayTransactionFromArray:responseObject andProduct:product withBuyer:fromBuyer];
                                          successBlock(arrTransaction);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        return;
    }];
    
    
}

- (void)postMessageTo:(TMEUser *)user
           forProduct:(TMEProduct *)product
          withMessage:(NSString *)message
       onSuccessBlock:(void (^)(TMETransaction*))successBlock
      andFailureBlock:(TMEJSONRequestFailureBlock)failureBlock{
    
    NSDictionary *params = @{
                             @"to"     : user.id,
                             @"access_token" : [[TMEUserManager sharedInstance] getAccessToken],
                             @"message" : message
                             };
    NSString *path = [NSString stringWithFormat:@"%@%@%@/%@%@", API_SERVER_HOST,API_PREFIX, API_PRODUCTS, product.id, API_CHATS];
    [[TMEHTTPClient sharedClient] postPath:path
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        TMETransaction *transaction = [TMETransaction alloc];
        if (responseObject) {
            transaction = [TMETransaction transactionWithMessage:message andProduct:product atTimestamp:[responseObject[@"timestamp"] doubleValue] toUser:user];
        }
        if (successBlock) {
             successBlock(transaction);
        }
    }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        return;
    }];
    
}

@end
