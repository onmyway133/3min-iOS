//
//  TMESubmitTableCell.m
//  PhotoButton
//
//  Created by Toan Slan on 12/23/13.
//
//

#import "TMESubmitTableCell.h"

@interface TMESubmitTableCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end

@implementation TMESubmitTableCell

- (void)configCellWithMessage:(TMEReply *)reply
{
  self.lblUsername.text = reply.user_full_name;
  [self.imageViewAvatar setImageWithURL:[NSURL URLWithString:reply.user_avatar]];
  
  self.lblContent.text = reply.reply;
  [self.lblContent sizeToFitKeepWidth];
  [self.separatorView alignBelowView:self.lblContent offsetY:7 sameWidth:NO];
  
  if (reply.time_stamp) {
    [self.indicator stopAnimating];
    self.lblTime.text = [reply.time_stamp relativeDate];
    return;
  }
  
  self.indicator.hidden = YES;
//  self.lblTime.text = @"Pending...";
}

+ (CGFloat)getHeight{
  return 111;
}

- (CGFloat)getHeightWithContent:(NSString *)content{
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 295, 26)];
  label.text = content;
  [label sizeToFitKeepWidth];
  return [TMESubmitTableCell getHeight] + [label expectedHeight] - 26;
}

@end
