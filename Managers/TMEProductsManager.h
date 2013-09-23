//
//  TMEProductsManager.h
//  PhotoButton
//
//  Created by Triệu Khang on 23/9/13.
//
//

#import "TMEHTTPClient.h"

@interface TMEProductsManager : BaseManager

- (NSArray *)fakeGetAllStoredProducts;
- (void)getAllProductsOnSuccessBlock:(TMEJSONRequestSuccessBlock)successBlock
                     andFailureBlock:(TMEJSONRequestFailureBlock)failureBlock;

@end
