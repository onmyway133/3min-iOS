//
//  TMEProductCommentCell.h
//  ThreeMin
//
//  Created by Khoa Pham on 10/6/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMEProductComment;

@interface TMEProductCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
- (void)configureForModel:(TMEProductComment *)comment;

@end
