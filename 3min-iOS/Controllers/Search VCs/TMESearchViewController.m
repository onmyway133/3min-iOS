//
//  TMESearchViewController.m
//  PhotoButton
//
//  Created by Toan Slan on 1/2/14.
//
//

#import "TMESearchViewController.h"
#import "TMESearchTableViewCell.h"

@interface TMESearchViewController ()
<
UISearchBarDelegate
>

@end

@implementation TMESearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [@[] mutableCopy];
    
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Search Product", nil);
    self.shouldHandleKeyboardNotification = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setEdgeForExtendedLayoutTop];
}

- (void)registerNibForTableView{
    self.arrayCellIdentifier = @[[TMESearchTableViewCell kind]];
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TMESearchTableViewCell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TMESearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TMESearchTableViewCell kind] forIndexPath:indexPath];
    
    [cell configCellWithData:self.dataArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissKeyboard];
    TMEProductDetailsViewController *productDetailsController = [[TMEProductDetailsViewController alloc] init];
    productDetailsController.product = self.dataArray[indexPath.row];
    productDetailsController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetailsController animated:YES];
}

#pragma mark - Search View Controller
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.navigationItem.leftBarButtonItem = [self leftNavigationButtonCancel];
    self.navigationItem.rightBarButtonItem = [self rightNavigationButtonDone];
    self.navigationController.navigationBar.topItem.title = @"";
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [self addNavigationItems];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Search Product", nil);
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.dataArray removeAllObjects]; //clears the array from all the string objects it might contain from the previous searches
    self.dataArray = [self arrProductsForSearchText:searchText];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self dismissKeyboard];
}

- (NSMutableArray *)arrProductsForSearchText:(NSString *)searchText
{
#warning NEED HANDLE THIS PART LATER
    return [NSMutableArray array];
//    NSMutableArray *arrResultProduct = [[NSMutableArray alloc] init];
//    NSArray *arrProduct = [TMEProduct MR_findAllSortedBy:@"name" ascending:YES];
//    
//    for (TMEProduct *product in arrProduct) {
//        NSString *productNameWithoutUnicode = [[NSString alloc] initWithData:[product.name dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
//        NSRange nameRange = [productNameWithoutUnicode rangeOfString:searchText options:NSCaseInsensitiveSearch];
//        if (nameRange.location != NSNotFound && product.images.count) {
//            [arrResultProduct addObject:product];
//        }
//    }
//    
//    return arrResultProduct;
}

- (void)viewWillLayoutSubviews
{
    if(self.searchDisplayController.isActive)
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    [self paddingScrollWithTop];
    [super viewWillLayoutSubviews];
}

@end
