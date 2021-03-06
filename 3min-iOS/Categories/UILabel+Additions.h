//
//  UILabel+Additions.h
//  FashTag
//
//  Created by Torin on 19/3/13.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (Additions)

- (void)sizeToFitKeepHeight;
- (void)sizeToFitKeepHeightAlignRight;
- (void)sizeToFitKeepWidth;
- (CGFloat)expectedHeight;
- (CGFloat)expectedWidth;

@end
