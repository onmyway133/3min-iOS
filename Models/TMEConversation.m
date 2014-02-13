#import "TMEConversation.h"


@interface TMEConversation ()

// Private interface goes here.

@end


@implementation TMEConversation

// Custom logic goes here.

+ (NSArray *)arrayConversationFromArrayData:(NSArray *)arrayData{
  NSMutableArray *arrayConversation = [@[] mutableCopy];
  for (NSDictionary *data in arrayData) {
    TMEConversation *conversation = [TMEConversation conversationFromData:data];
    [arrayConversation addObject:conversation];
  }
  
  return arrayConversation;
}

+ (TMEConversation *)conversationFromData:(NSDictionary *)data{
  TMEConversation *conversation = [[TMEConversation MR_findByAttribute:@"id" withValue:data[@"id"]] lastObject];
  
  if (!conversation) {
    conversation = [TMEConversation MR_createEntity];
    conversation.id = data[@"id"];
    conversation.user_id = data[@"user"][@"id"];
    conversation.user_full_name = data[@"user"][@"full_name"];
    
    if (![data[@"user"][@"facebook_avatar"] isKindOfClass:[NSNull class]]) {
      conversation.user_avatar = data[@"user"][@"facebook_avatar"];
    }
    
    TMEProduct *product = [[TMEProduct MR_findByAttribute:@"id" withValue:data[@"product_id"]] lastObject];
    conversation.product = product;
  }
  
  if (data[@"replies"] && ![data[@"replies"] isKindOfClass:[NSNull class]]) {
    NSArray *arrayReplies = [TMEReply arrayRepliesFromArrayData:data[@"replies"] ofConversation:conversation];
    [conversation.repliesSet addObjectsFromArray:arrayReplies];
  }
  
  if (data[@"latest_message"] && ![data[@"latest_message"] isKindOfClass:[NSNull class]]) {
    conversation.latest_message = data[@"latest_message"];
  }
  
  if (data[@"latest_update"] && ![data[@"latest_update"] isKindOfClass:[NSNull class]]) {
    conversation.latest_update = [NSDate dateWithTimeIntervalSince1970:[data[@"latest_update"] doubleValue]];
  }
  
  conversation.offer = @0;
  if (data[@"offer"] && ![data[@"offer"] isKindOfClass:[NSNull class]]) {
    conversation.offer = data[@"offer"];
  }
  
  return conversation;
}

@end

