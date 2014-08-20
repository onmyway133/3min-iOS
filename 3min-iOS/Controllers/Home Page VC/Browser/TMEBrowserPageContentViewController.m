//
//  TMEBrowserPageContentViewController.m
//  ThreeMin
//
//  Created by Triệu Khang on 4/8/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "TMEBrowserPageContentViewController.h"
#import "TMEProductCollectionViewCell.h"
#import "TMEPaginationCollectionViewDataSource.h"
#import "TMEBrowserProductViewModel.h"
#import "TMELoadMoreCollectionCell.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@interface TMEBrowserPageContentViewController ()
<
    UICollectionViewDelegateFlowLayout
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewProducts;
@property (strong, nonatomic) CHTCollectionViewWaterfallLayout *layout;
@property (strong, nonatomic) TMEBrowserProductViewModel *viewModel;
@property (strong, nonatomic) FBKVOController *kvoController;
@property (strong, nonatomic) AIMultiDelegate *chainDelegate;

@end

@implementation TMEBrowserPageContentViewController

#pragma mark - VC cycle

- (AIMultiDelegate *)chainDelegate {
	if (!_chainDelegate) {
		_chainDelegate = [[AIMultiDelegate alloc] init];
		[_chainDelegate addDelegate:self.viewModel.datasource];
		[_chainDelegate addDelegate:self];
	}
	return _chainDelegate;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.

	[self.collectionViewProducts registerNib:[TMELoadMoreCollectionCell defaultNib] forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([TMELoadMoreCollectionCell class])];
	[self.collectionViewProducts registerNib:[TMEProductCollectionViewCell defaultNib]
	              forCellWithReuseIdentifier:NSStringFromClass([TMEProductCollectionViewCell class])];

	[self configCollectionProducts];

	self.kvoController = [FBKVOController controllerWithObserver:self];

	[self.kvoController observe:self.viewModel keyPath:@"state" options:NSKeyValueObservingOptionNew block: ^(id observer, id object, NSDictionary *change) {
	    typeof(self) innerSelf = observer;
	    innerSelf.collectionViewProducts.dataSource = innerSelf.viewModel.datasource;

//	    innerSelf.collectionViewProducts.delegate = innerSelf.viewModel.datasource;
	    innerSelf.collectionViewProducts.delegate = (id <UICollectionViewDelegate> )innerSelf.chainDelegate;
	    [innerSelf.collectionViewProducts reloadData];
	}];
}

- (TMEBrowserProductViewModel *)viewModel {
	if (!_viewModel) {
		_viewModel = [[TMEBrowserProductViewModel alloc] initWithCollectionView:self.collectionViewProducts];
	}

	return _viewModel;
}

#pragma mark -

- (void)configCollectionProducts {
	self.layout = [self waterFlowLayout];
	self.collectionViewProducts.delegate = self.viewModel.datasource;
	self.collectionViewProducts.dataSource = self.viewModel.datasource;
	self.collectionViewProducts.collectionViewLayout = self.layout;
	[self.collectionViewProducts setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
}

#pragma mark -

- (CHTCollectionViewWaterfallLayout *)waterFlowLayout {
	CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
	layout.columnCount = 2;
	layout.minimumColumnSpacing = 5;
	layout.minimumInteritemSpacing = 6;
	return layout;
}

- (IBAction)reload:(id)sender {
	[self.viewModel getProducts:nil failure:nil];
}

#pragma mark - Collection datasource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

@end
