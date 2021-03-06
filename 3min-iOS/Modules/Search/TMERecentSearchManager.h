//
//  TMERecentSearchManager.h
//  ThreeMin
//
//  Created by Khoa Pham on 8/29/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMERecentSearchManager : NSObject

OMNIA_SINGLETON_H(sharedManager)

- (void)save;
- (void)load;

- (NSArray *)recentSearchTexts;
- (void)addSearchText:(NSString *)text;
- (void)clear;

@end
