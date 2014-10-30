//
//  TMEViewController.m
//  ThreeMin
//
//  Created by Triệu Khang on 22/9/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "TMEMyTopProfileViewController.h"
#import <KHTableViewController/KHCollectionController.h>
#import "TMETopProfileCellFactory.h"

@interface TMEMyTopProfileViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionTop;
@property (strong, nonatomic) KHCollectionController *collectionController;
@property (strong, nonatomic) TMETopProfileCellFactory *cellFactory;

@end

@implementation TMEMyTopProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    KHCollectionController *collectionController = [[KHCollectionController alloc] init];
    KHBasicTableViewModel *basicSection = [[KHBasicTableViewModel alloc] init];
    KHLoadMoreSection *loadingSection = [[KHLoadMoreSection alloc] init];
    basicSection.sectionModel = loadingSection;

    self.collectionController = collectionController;
    self.collectionController.model = basicSection;

    self.cellFactory = [[TMETopProfileCellFactory alloc] init];
    self.collectionController.cellFactory = self.cellFactory;

    self.collectionTop.delegate = self.collectionController;
    self.collectionTop.dataSource = self.collectionController;

    [self.collectionTop reloadData];
}

- (void)updateViewConstraints {

    [super updateViewConstraints];

    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.superview).with.offset(0);
        make.top.equalTo(self.view.superview).with.offset(0);
        make.width.equalTo(@(self.view.superview.width));
    }];

    [self.view.superview layoutIfNeeded];
}

- (void)loadingUserInformation {
    [[TMEUserManager sharedManager] loggedUser];
}

@end
