//
//  TMEProductDetailsViewController.m
//  PhotoButton
//
//  Created by Triệu Khang on 21/9/13.
//
//

#import "TMEProductDetailsViewController.h"
#import "TMESubmitViewController.h"

@interface TMEProductDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIButton     * btnFollow;
@property (weak, nonatomic) IBOutlet UIButton     * btnComment;
@property (weak, nonatomic) IBOutlet UIButton     * btnShare;
@property (weak, nonatomic) IBOutlet UIImageView  * imgUserAvatar;
@property (weak, nonatomic) IBOutlet UILabel      * lblUserName;
@property (weak, nonatomic) IBOutlet UILabel      * lblTimestamp;
@property (weak, nonatomic) IBOutlet UIImageView  * imgProductImage;
@property (weak, nonatomic) IBOutlet UILabel      * lblProductName;
@property (weak, nonatomic) IBOutlet UILabel      * lblProductPrice;
@property (weak, nonatomic) IBOutlet UIView       * viewChatToBuyWrapper;

@end

@implementation TMEProductDetailsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  self.title = self.product.name;
  
  [self loadProductDetail:self.product];
  [self setUpView];
}

- (void)loadProductDetail:(TMEProduct *)product{
  
  self.product = product;
  
  // Follow button
  self.btnFollow.layer.borderWidth = 1;
  self.btnFollow.layer.borderColor = [UIColor grayColor].CGColor;
  self.btnFollow.layer.cornerRadius = 3;
  
  // Comment button
  self.btnComment.layer.borderWidth = 1;
  self.btnComment.layer.borderColor = [UIColor grayColor].CGColor;
  self.btnComment.layer.cornerRadius = 3;
  
  // Share button
  self.btnShare.layer.borderWidth = 1;
  self.btnShare.layer.borderColor = [UIColor grayColor].CGColor;
  self.btnShare.layer.cornerRadius = 3;
  
  // for now when we get product, we get all imformantion about this product like user, category, etc.
  
  // user
  self.imgUserAvatar.image = nil;
  [self.imgUserAvatar setImageWithURL:[NSURL URLWithString:product.user.photo_url] placeholderImage:nil];
  self.lblUserName.text = product.user.username;
  self.lblTimestamp.text = [product.created_at relativeDate];
  
  TMEProductImages *img = [product.images anyObject];
  [self.imgProductImage setImageWithURL:[NSURL URLWithString:img.medium] placeholderImage:nil];
  [self.imgProductImage clipsToBounds];
  
  self.lblProductName.text = product.name;
  self.lblProductPrice.text = [NSString stringWithFormat:@"$%@", [product.price stringValue]];
  
  TMEUser *currentLoginUser = [[TMEUserManager sharedInstance] loggedUser];
  
  if([product.user.id isEqual:currentLoginUser.id])
    self.viewChatToBuyWrapper.hidden = YES;
  
  [self autoAdjustScrollViewContentSize];
}

- (void)setUpView
{
  UIScrollView *scrollView = (UIScrollView *)self.view;
  scrollView.bounces = NO;
  scrollView.showsVerticalScrollIndicator = NO;
}

- (IBAction)chatButtonAction:(id)sender {
  TMESubmitViewController *submitController = [[TMESubmitViewController alloc] init];
  submitController.product = self.product;
  [self.navigationController pushViewController:submitController animated:YES];
}

@end
