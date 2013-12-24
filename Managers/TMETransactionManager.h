//
//  TMETransactionManager.h
//  PhotoButton
//
//  Created by Toan Slan on 12/23/13.
//
//

#import "BaseManager.h"
#import "TMETransaction.h"

@interface TMETransactionManager : BaseManager

- (void)getListMessageOfProduct:(TMEProduct *)product
                         toUser:(TMEUser *)user
                 onSuccessBlock:(void (^) (NSArray *arrayProducts))successBlock
                andFailureBlock:(TMEJSONRequestFailureBlock)failureBlock;

- (void)postMessageTo:(TMEProduct*)product
          withMessage:(NSString *)message
       onSuccessBlock:(void (^) (TMETransaction *transaction))successBlock
      andFailureBlock:(TMEJSONRequestFailureBlock)failureBlock;

@end
