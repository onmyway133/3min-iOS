#import "_TMETransaction.h"

@interface TMETransaction : _TMETransaction {}
// Custom logic goes here.


+ (NSArray *)arrayTransactionFromArray:(NSArray *)arrData andProduct:(TMEProduct *)product withBuyer:(TMEUser *)buyer;
+ (TMETransaction *)transactionWithDictionary:(NSDictionary *)data andProduct:(TMEProduct *)product withBuyer:(TMEUser *)buyer;

@end
