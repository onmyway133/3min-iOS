//
//  TMEViewController.m
//  ThreeMin
//
//  Created by Triệu Khang on 22/9/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "TMEOtherTopProfileViewController.h"

@interface TMEOtherTopProfileViewController ()

@property (weak, nonatomic) IBOutlet UIView *loadingScreen;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet KHRoundAvatar *imgUserAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;

@property (weak, nonatomic) IBOutlet UILabel *lblPositive;
@property (weak, nonatomic) IBOutlet UILabel *lblFollower;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *followingProgressIndicator;

@end

@implementation TMEOtherTopProfileViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self _loadingUserInformation];
	[self _configTheButton];
}

- (void)_loadingUserInformation {
	self.loadingScreen.hidden = NO;
	TMEUserNetworkClient *client = [[TMEUserNetworkClient alloc] init];
	[client getFullInformationWithUserID:[self.user.userID integerValue] success: ^(TMEUser *user) {
	    [self _configWithUser:user];
	    self.loadingScreen.hidden = YES;
	} failure: ^(NSError *error) {
	    self.loadingScreen.hidden = YES;
	}];
}

#pragma mark - Private method

- (void)_configTheButton {
	self.btnFollow.layer.borderWidth = 1;
	self.btnFollow.layer.borderColor = [UIColor orangeMainColor].CGColor;
	self.btnFollow.layer.cornerRadius = 14.0f;
	self.btnFollow.layer.masksToBounds = YES;
}

- (void)_configWithUser:(TMEUser *)user {
	self.lblUsername.text = user.fullName;
	[self.imgUserAvatar setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:nil];

    self.lblPositive.text = [[user.positive_percent stringValue] stringByAppendingString:@"%"];
    self.lblFollower.text = [user.follower_count stringValue];
    self.lblFollowing.text = [user.following_count stringValue];

	NSString *buttonTitle = [user.followed boolValue] ? @"Unfollow" : @"Follow";
	[self.btnFollow setTitle:buttonTitle forState:UIControlStateNormal];
}

- (void)updateViewConstraints {
	[super updateViewConstraints];

	[self.view mas_remakeConstraints: ^(MASConstraintMaker *make) {
	    make.leading.equalTo(self.view.superview).with.offset(0);
	    make.top.equalTo(self.view.superview).with.offset(0);
	    make.width.equalTo(@(self.view.width));
	}];

	[self.view.superview layoutIfNeeded];
}

- (void)_followOrUnfollowUser:(void (^)(NSError *error))finishBlock {
	TMEUserNetworkClient *userClient = [[TMEUserNetworkClient alloc] init];

	// unfollow
	if ([self.user.followed boolValue]) {
		[userClient unfollowUser:self.user finishBlock: ^(NSError *error) {
		    if (finishBlock) {
		        finishBlock(error);
			}
		}];
		return;
	}

	// follow
	[userClient followUser:self.user finishBlock: ^(NSError *error) {
	    if (finishBlock) {
	        finishBlock(error);
		}
	}];
	return;
}

#pragma mark - Action

- (IBAction)btmMyItems:(id)sender {
}

- (IBAction)btnMyLikes:(id)sender {
}

- (IBAction)btnEdit:(id)sender {
}

- (IBAction)onBtnFollow:(id)sender {
	self.btnFollow.hidden = YES;
	self.followingProgressIndicator.hidden = NO;
	[self _followOrUnfollowUser: ^(NSError *error) {
	    if (!error) {
            self.user.followed = @(![self.user.followed boolValue]);
		}

	    [self _configWithUser:self.user];
	    self.btnFollow.hidden = NO;
	    self.followingProgressIndicator.hidden = YES;
	}];
}

@end
