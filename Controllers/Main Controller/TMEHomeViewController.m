//
//  ViewController.m
//  PhotoButton
//
//  Created by Triệu Khang on 08/09/13.
//  Copyright (c) 2013 hasBrain. All rights reserved.
//

typedef NS_ENUM(NSInteger, TMETabbarButtonType){
    TMETabbarButtonTypeBrowser  = 0,
    TMETabbarButtonTypeSearch   = 1,
    TMETabbarButtonTypeSell     = 2,
    TMETabbarButtonTypeActivity = 3,
    TMETabbarButtonTypeMe       = 4
};

#import "TMEBrowserCollectionViewController.h"
#import "TMEHomeViewController.h"
#import "TMEPublishProductViewController.h"
#import "TMEBrowserProductsViewController.h"
#import "TMEPhotoButton.h"
#import "AFPhotoEditorController.h"
#import "TMEBrowserProductsViewController.h"
#import "TMEPublishProductViewController.h"
#import "TMELoginViewController.h"
#import "PBImageHelper.h"
#import "HTKContainerViewController.h"
#import "TMEMeViewController.h"
#import "TMESearchViewController.h"

@interface TMEHomeViewController ()
<
AFPhotoEditorControllerDelegate,
UITabBarDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, strong) TMEBrowserProductsViewController *browser;

@end

@implementation TMEHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Main Menu";
    
    self.viewControllers = @[];
    
    [self addBrowserProductTab];
    [self addSearchButton];
    [self addPublishButton];
    [self addDummy2Button];
    [self addMeButton];
}

#pragma marks - UI helper

- (void)addViewController:(UIViewController *)viewController
              withIconName:(NSString *)iconName
{
    NSMutableArray *VCs = [self.viewControllers mutableCopy];
    
    if (!VCs)
        VCs = [@[] mutableCopy];
    
    [VCs addObject:viewController];
    self.viewControllers = VCs;

    NSInteger index = [self.viewControllers indexOfObject:viewController];
    [self createTabbarButtonWithIconName:iconName atIndex:index];
}

- (void)createTabbarButtonWithIconName:(NSString *)iconName
                             atIndex:(NSInteger)index
{
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *button = [tabBar.items objectAtIndex:index];
    button.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIImage *browserBtnBackground = [UIImage imageNamed:iconName];
    UIImage *browserSelectedBtnBackground = [UIImage imageNamed:[NSString stringWithFormat:@"%@-pressed", iconName]];
    [button setFinishedSelectedImage:browserSelectedBtnBackground withFinishedUnselectedImage:browserBtnBackground];
}

- (void)addBrowserProductTab
{
    HTKContainerViewController *browserContainerVC = [[HTKContainerViewController alloc] init];
    TMENavigationViewController *navigationViewController = [[TMENavigationViewController alloc] initWithRootViewController:browserContainerVC];

    [self addViewController:navigationViewController
               withIconName:@"tabbar-browser-icon"];
}

- (void)addSearchButton
{
    TMESearchViewController *searchVC = [[TMESearchViewController alloc] init];
    TMENavigationViewController *navigationViewController = [[TMENavigationViewController alloc] initWithRootViewController:searchVC];
  
    [self addViewController:navigationViewController
               withIconName:@"tabbar-search-icon"];
}

- (void)addDummy2Button
{
    UIViewController *browserVC = [[UIViewController alloc] init];

    [self addViewController:browserVC
               withIconName:@"tabbar-activity-icon"];
}

- (void)addMeButton
{
    TMEMeViewController *meVC = [[TMEMeViewController alloc] init];
    TMENavigationViewController *navigationViewController = [[TMENavigationViewController alloc] initWithRootViewController:meVC];
  
    [self addViewController:navigationViewController
               withIconName:@"tabbar-me-icon"];
}

- (void)addPublishButton
{
    TMEPublishProductViewController *publishVC = [[TMEPublishProductViewController alloc] init];
    TMENavigationViewController *navigationViewController = [[TMENavigationViewController alloc] initWithRootViewController:publishVC];
    [self addViewController:navigationViewController
               withIconName:@"tabbar-sell-icon"];
}

#pragma marks - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // close the picker VCs.
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    // Add that image to Publish VC
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

@end
