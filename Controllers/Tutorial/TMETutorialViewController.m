//
//  TMETutorialViewController.m
//  PhotoButton
//
//  Created by Hoang Ta on 9/28/13.
//
//

#import "AppDelegate.h"
#import "TMETutorialViewController.h"

#define NUMBER_OF_TUTORIAL_PAGES  3
#define PAGE_CONTROL_HEIGHT       44

NSString *const TUTORIAL_HAS_BEEN_PRESENTED = @"tutorial_has_been_presented";

@interface TMETutorialViewController ()

@property (strong, nonatomic) iCarousel *iCarousel;
@property (strong, nonatomic) UIButton *doneButton;
@property (strong, nonatomic) UIPageControl *tutorialPageControl;

@end

@implementation TMETutorialViewController

+ (id)hasBeenPresented
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:TUTORIAL_HAS_BEEN_PRESENTED];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.iCarousel];
    [self.view addSubview:self.tutorialPageControl];
}

- (iCarousel *)iCarousel
{
  if (!_iCarousel) {
    _iCarousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    _iCarousel.type = iCarouselTypeLinear;
    _iCarousel.dataSource = self;
    _iCarousel.delegate = self;
    _iCarousel.bounceDistance = 0.2f;
    _iCarousel.decelerationRate = 0.5f;
  }
  return  _iCarousel;
}

- (UIButton *)doneButton
{
  if (!_doneButton) {
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(90, self.view.height - 64, self.view.bounds.size.width - 180, 44);
    _doneButton.backgroundColor = [UIColor blueTextColor];
    [_doneButton addTarget:self action:@selector(closeTutorial) forControlEvents:UIControlEventTouchDown];
  }
  return _doneButton;
}

- (UIPageControl *)tutorialPageControl
{
  if (!_tutorialPageControl) {
    CGRect frame = self.view.bounds;
    frame.origin.y = self.view.height - PAGE_CONTROL_HEIGHT;
    frame.size.height = PAGE_CONTROL_HEIGHT;
    _tutorialPageControl = [[UIPageControl alloc] initWithFrame:frame];
    _tutorialPageControl.currentPage = 0;
    _tutorialPageControl.numberOfPages = NUMBER_OF_TUTORIAL_PAGES;
    _tutorialPageControl.enabled = NO;
  }
  return _tutorialPageControl;
}

- (void)closeTutorial
{
  [[AppDelegate sharedDelegate] showHomeViewController];
  [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:TUTORIAL_HAS_BEEN_PRESENTED];
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
  return NUMBER_OF_TUTORIAL_PAGES;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
  UIView *carouselView = [[UIView alloc] initWithFrame:self.view.bounds];
  int c1 = rand(), c2 = rand(), c3 = rand(), c4 = rand(), c5 = rand(), c6 = rand();
  float red = MIN(c1, c2) / (float)MAX(c1, c2), green =  MIN(c3, c4) / (float)MAX(c3, c4), blue = MIN(c5, c6) / (float)MAX(c5, c6);
  carouselView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
  
  //Add Start Button if this is the last page.
  if (index == NUMBER_OF_TUTORIAL_PAGES - 1) {
    [carouselView addSubview:self.doneButton];
  }
  return carouselView;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
  self.tutorialPageControl.currentPage = carousel.currentItemIndex;
}
@end