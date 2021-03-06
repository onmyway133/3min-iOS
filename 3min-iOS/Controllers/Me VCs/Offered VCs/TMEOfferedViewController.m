//
//  TMEOfferedViewController.m
//  PhotoButton
//
//  Created by Toan Slan on 2/13/14.
//
//

#import "TMEOfferedViewController.h"
#import "TMEOfferedTableViewCell.h"

@interface TMEOfferedViewController()

@property (strong, nonatomic) TMEBaseArrayDataSourceWithLoadMore * offeredConversationArrayDataSource;

@end

@implementation TMEOfferedViewController

#pragma mark - VC cycle life

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Offer I Made", nil);
    [self enablePullToRefresh];
    [self paddingScrollWithTop];
    
    [self getCachedOfferedConversation];
    [self.pullToRefreshView beginRefreshing];
    [self loadListOfferedConversationWithPage:1];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setEdgeForExtendedLayoutTop];
}

- (void)setUpTableView{
    LoadMoreCellHandleBlock handleCell = ^(){
        [self loadListOfferedConversationWithPage:++self.currentPage];
    };
    
    self.offeredConversationArrayDataSource = [[TMEBaseArrayDataSourceWithLoadMore alloc] initWithItems:self.dataArray cellIdentifier:[TMEOfferedTableViewCell kind] paging:self.paging handleCellBlock:handleCell];
    
    self.tableView.dataSource = self.offeredConversationArrayDataSource;
    [self refreshTableViewAnimated:NO];
}

- (void)registerNibForTableView{
    self.arrayCellIdentifier = @[[TMEOfferedTableViewCell kind]];
    self.registerLoadMoreCell = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.paging && indexPath.row == self.dataArray.count) {
        return [TMELoadMoreTableViewCell getHeight];
    }
    return [TMEOfferedTableViewCell getHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TMESubmitViewController *submitController = [[TMESubmitViewController alloc] init];
    
    TMEConversation *conversation = self.dataArray[indexPath.row];
    submitController.product = conversation.product;
    submitController.conversation = conversation;
    
    [self.navigationController pushViewController:submitController animated:YES];
}

- (void)loadListOfferedConversationWithPage:(NSInteger)page{
    if (![self isReachable]) {
        return;
    }
    
    [TMEConversationManager getOfferedConversationWithPage:page
                                            onSuccessBlock:^(NSArray *arrayOfferedConversation)
     {
         [self handlePagingWithResponseArray:arrayOfferedConversation currentPage:page];
         [self.dataArray addObjectsFromArray:arrayOfferedConversation];
         [self reloadTableViewOfferedConversation];
     }
                                              failureBlock:^(NSError *error)
     {
         [self failureBlockHandleWithError:error];
         [self finishLoading];
     }];
}

- (void)getCachedOfferedConversation{
//    NSArray *arrayOfferedConversationCached = [TMEConversation MR_findAllSortedBy:@"latest_update" ascending:NO];
//    
//    for (TMEConversation *conversation in arrayOfferedConversationCached) {
//        if (![conversation.offer isEqualToNumber:@0] && ![conversation.offer isEqual:[NSNull null]] && ![conversation.product.user isEqual:[[TMEUserManager sharedInstance] loggedUser]]) {
//            [self.dataArray addObject:conversation];
//        }
//    }
//    
//    if (self.dataArray.count) {
//        [self reloadTableViewOfferedConversation];
//    }
}

- (void)reloadTableViewOfferedConversation{
    [self setUpTableView];
    [self finishLoading];
}

- (void)pullToRefreshViewDidStartLoading
{
    if (![self isReachable]) {
        return;
    }
    [self loadListOfferedConversationWithPage:1];
}


@end
