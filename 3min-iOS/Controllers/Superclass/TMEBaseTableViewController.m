//
//  TMEBaseTableViewController.m
//  PhotoButton
//
//  Created by Triệu Khang on 12/9/13.
//
//

#import "TMEBaseTableViewController.h"

@interface TMEBaseTableViewController ()

@property (strong, nonatomic) NSNumber * currentCellHeight;

@end

@implementation TMEBaseTableViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.lblInstruction alignVerticallyCenterToView:self.view];
    if ([self respondsToSelector:@selector(registerNibForTableView)]) {
        [self performSelector:@selector(registerNibForTableView)];
    }
    for (int i = 0; i < self.arrayCellIdentifier.count; i++) {
        NSString *cellIdentifier = self.arrayCellIdentifier[i];
        [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    if (self.registerLoadMoreCell) {
        [self.tableView registerNib:[TMELoadMoreTableViewCell defaultNib] forCellReuseIdentifier:[TMELoadMoreTableViewCell kind]];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 != self.arrayCellIdentifier.count)
        return 44;
    
    if(self.currentCellHeight)
        return self.currentCellHeight.floatValue;
    
    NSString * customCellIdentifier = self.arrayCellIdentifier[0];
    NSArray * nibViews = [[NSBundle mainBundle] loadNibNamed:customCellIdentifier
                                                       owner:nil
                                                     options:nil];
    UITableViewCell * cell = nibViews[0];
    self.currentCellHeight = @(cell.height);
    
    return cell.height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(didSelectCellAnimation)]) {
        [cell performSelector:@selector(didSelectCellAnimation)];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(didDeselectCellAnimation)]) {
        [cell performSelector:@selector(didDeselectCellAnimation)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.pullToRefreshView scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self.pullToRefreshView scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
}

#pragma mark - Helpers

- (void)enablePullToRefresh{
    self.pullToRefreshView = [[TMERefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    self.pullToRefreshView.tableView = self.tableView;
    
    __weak UIViewController *weakSelf = self;
    self.pullToRefreshView.refreshBlock = ^{
        if ([weakSelf respondsToSelector:@selector(pullToRefreshViewDidStartLoading)]) {
            [weakSelf performSelector:@selector(pullToRefreshViewDidStartLoading)];
        }
    };
}

- (void)deselectAllCellsAnimated:(BOOL)animated
{
    for (UITableViewCell *cell in self.tableView.visibleCells)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}
- (void)fadeInTableView
{
    [self fadeInTableViewOnCompletion:nil];
}

- (void)fadeInTableViewOnCompletion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 1;
    } completion:completion];
}

- (void)fadeOutTableView
{
    [self fadeOutTableViewOnCompletion:nil];
}

- (void)fadeOutTableViewOnCompletion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 0;
    } completion:completion];
}

- (void)refreshTableViewAnimated:(BOOL)animated
{
    if (animated == NO) {
        [self.tableView reloadData];
        
        if (self.dataArray != nil) {
            self.tableView.hidden = [self.dataArray count] <= 0;
            self.lblInstruction.hidden = !self.tableView.hidden;
        }
        return;
    }
    
    [self refreshTableViewOnCompletion:nil];
}

- (void)refreshTableViewOnCompletion:(void (^)(BOOL finished))completion
{
    [self fadeOutTableViewOnCompletion:^(BOOL finished) {
        [self.tableView reloadData];
        
        if (self.dataArray != nil) {
            self.tableView.hidden = [self.dataArray count] <= 0;
            self.lblInstruction.hidden = !self.tableView.hidden;
        }
        [self fadeInTableViewOnCompletion:completion];
    }];
}

- (void)handlePagingWithResponseArray:(NSArray *)array currentPage:(NSInteger)page{
    self.paging = YES;
    
    if (page == 1) {
        [self.dataArray removeAllObjects];
        self.currentPage = 1;
    }
    
    if (!self.currentPage) {
        self.currentPage = page;
    }
    
    if (!array.count) {
        self.paging = NO;
    }
    
}

- (void)paddingScrollWithTop
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 22, 0);
        
    }
}

- (BOOL)isReachable{
    if (![TMEReachabilityManager isReachable]) {
        [self.pullToRefreshView endRefreshing];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No connection!", nil)];
        return NO;
    }
    return YES;
}

- (void)finishLoading{
    [self.pullToRefreshView endRefreshing];
    [SVProgressHUD dismiss];
}

@end
