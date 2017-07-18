
//
//  OFTableViewController.m
//  OrderingFood
//
//  Created by Mallgo on 15-3-20.
//  Copyright (c) 2015年 mall-go. All rights reserved.
//

#import "YCTableViewController.h"
#import "YCLoadControl.h"
#import "MobClick.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImageCompat.h>
#import "YCTableVIewCell.h"
#import "YCLoginVC.h"

@implementation YCStaticViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    YCPageViewModel *vm = [self onCreateViewModel];
    YCStaticViewController *vc = [super initWithCoder:aDecoder];
    [vc onSetupBackButton];
    vc.viewModel = vm;
    return vc;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    YCPageViewModel *vm = [self onCreateViewModel];
    YCStaticViewController *vc = [super initWithStyle:style];
    [vc onSetupBackButton];
    vc.viewModel = vm;
    
    return vc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
    [MobClick endLogPageView:NSStringFromClass(self.class)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak UINavigationController *nav = self.navigationController;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)nav;
    


    
    [self onSetupRefreshControl];
    [self onSetupCell];
    [self onSetupHeaderFooter];
    [self onMainSignalExecute:nil];
    
    
}

#pragma mark -on
- (id)onCreateViewModel
{
    return nil;
}


- (void)onSetupRefreshControl
{
    ;
}

- (void)onSetupActivityIndicatorView
{

}

- (void)onSetupCell
{
    
}
- (void)onSetupHeaderFooter
{
    
}

- (void)onKeyboardDone:(id)sender
{
    ;
}

-(void)onRegisterNibName:(NSString *)name Identifier:(NSString *)identifier{
    
    UINib * nib = [UINib nibWithNibName:name bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}


-(void)onRegisterNibName:(NSString *)name HeaderFooterViewIdentifier:(NSString *)identifier{
    UINib *nibHeader = [UINib nibWithNibName:name bundle:nil];
    [self.tableView registerNib:nibHeader forHeaderFooterViewReuseIdentifier:identifier];
}


#pragma mark -delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    @try {
        if (textField.returnKeyType == UIReturnKeyNext) {
            NSInteger idx = [self.nextResponders indexOfObject:textField];
            if (idx == NSNotFound || idx >= self.nextResponders.count) {
                [textField resignFirstResponder];
                return YES;
            }
            UIResponder *tf = self.nextResponders[idx+1];
            
            [tf becomeFirstResponder];
            return NO;
        } else if (textField.returnKeyType == UIReturnKeyDone) {
            [self onKeyboardDone:textField];
            [textField resignFirstResponder];
            
        }
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
    return YES;
}

#pragma mark -block
- (YCErrorBlock)errorBlock
{
    if (!_errorBlock) {
        WSELF;
        _errorBlock = ^(NSError *e){
            SSELF;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.viewModel respondsToSelector:@selector(pageInfo)]) {
                   
                    self.viewModel.pageInfo.status = YCLoadingStatusDefault;
                    
                }
                

                if ([e isKindOfClass:[NSError class]] && self.viewModel.isActive) {
                    [self showMessage:e.localizedDescription];
                }

                if (e.code == 805 || e.code == 806 || e.code ==  818 || e.code == 816) {
                    if (self.viewModel.isActive) {
                        YCLoginVC *vc = [YCLoginVC vcClass:[YCLoginVC class]];
                        [self presentViewController:vc animated:YES completion:nil];
                    }
                }
            });
        };
    }
    return _errorBlock;
}

- (YCExecutingBlock)executingBlock
{
    if (!_executingBlock) {
        _executingBlock = ^(BOOL isExecuting){
            
        };
    }
    return _executingBlock;
}

- (YCCompleteBlock)completeBlock
{
    if (!_completeBlock) {
        _completeBlock = ^(void) {
        };
    }
    return _completeBlock;
}

@end


@interface YCTableViewController ()
{
    YCNextBlock _nextBlock;
    YCExecutingBlock _executingBlock;
    YCCompleteBlock _completeBlock;
}
@end

@implementation YCTableViewController
@dynamic viewModel;

#pragma mark - init
- (void)dealloc
{
    //ok
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:style];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}

#pragma mark - view
- (void)viewDidLoad {
    //self.viewModel.width = [UIScreen mainScreen].bounds.size.width;
    
    [self onSetupFooter];
    [self onSetupActivityIndicatorView];

    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.tableView.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.backgroundColor = [UIColor colorWithHex:0xeeeeee];


}

- (YCEmptyView *)emptyView{
    if (!_emptyView) {

        _emptyView = [YCEmptyView viewByClass:[YCEmptyView class]];

        _emptyView.bounds = self.tableView.bounds;

    }
    return _emptyView;
}



- (void)onSetupCommentButton:(NSArray *)arr{

    if (arr.count>10) {
        self.tableView.tableFooterView = self.moreButton;
    }else{
        self.tableView.tableFooterView = nil;
    };
}


- (void)onSetupFooter
{
    self.tableView.tableFooterView = self.loadControl;
}

- (void)onSetupRefreshControl
{
    MUKCirclePullToRefreshControl *refreshControl = [[MUKCirclePullToRefreshControl alloc]init];
    UIView *circle = [refreshControl valueForKey:@"circleView"];
    CAShapeLayer *layer = (CAShapeLayer *)circle.layer;
    layer.strokeColor = color_yellow.CGColor;

    [refreshControl addTarget:self action:@selector(onReload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    self.refresh = refreshControl;
}

- (void)onSetupActivityIndicatorView
{
    JDFNavigationBarActivityIndicator *indicator = [[JDFNavigationBarActivityIndicator alloc]init];
    indicator.color = color_yellow;
    indicator.highlightColor = [UIColor whiteColor];
    UINavigationBar *bar = self.navigationController.navigationBar;

    [indicator addToNavigationBar:bar startAnimating:YES];
    self.indicator = indicator;
}

- (void)onSetupEmptyView
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.indicator.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.indicator.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.viewModel numberOfItemsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [self.viewModel cellIDAtIndexPath:indexPath];

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    //cell.pushedViewController = self;
    // Configure the cell...
    
    [self onUpdateCell:cell model:[self.viewModel modelForItemAtIndexPath:indexPath] atIndexPath:indexPath];

    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = ([self.viewModel heightForRowAtIndexPath:indexPath width:CGRectGetHeight(tableView.frame)]);
    return h;
}

#pragma mark - event

- (id)onCreateViewModel
{
    return nil;
}

///刷新单元格
- (void)onReloadItems:(NSInteger)itemCount
{
    if ([NSThread isMainThread]) {
        [self.tableView reloadData];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
 
}


- (void)onInsertItemsIntoBack:(NSInteger)itemCount
{
    if (0 == itemCount) {
        return;
    }
    NSInteger section = self.viewModel.insertBackSection;
    NSInteger rowCount = [self.tableView numberOfRowsInSection:section];

    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:itemCount];
    for (int n = 0; n < itemCount; n++) {
        NSIndexPath *idxp = [NSIndexPath indexPathForItem:n+rowCount inSection:section];
        [arr addObject:idxp];
    }
    if ([NSThread isMainThread]) {
        [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade ];
        });
    }
    

}

- (void)onInsertSectionsIntoBack:(NSInteger)sectionCount
{
    if (0 == sectionCount) {
        return;
    }
    NSInteger section = self.viewModel.insertBackSection;
    
    
    NSIndexSet *ids = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(section, sectionCount)];
    
    if ([NSThread isMainThread]) {
        [self.tableView insertSections:ids withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView insertSections:ids withRowAnimation:UITableViewRowAnimationBottom];
        });
    }
    
    
}


- (void)onInsertItemsIntoFront:(NSInteger)itemCount
{
    if (0 == itemCount) {
        return;
    }
    NSInteger section = self.viewModel.insertFrontSection;
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:itemCount];
    for (int n = 0; n < itemCount; n++) {
        NSIndexPath *idxp = [NSIndexPath indexPathForItem:n inSection:section];
        [arr addObject:idxp];
    }
    if ([NSThread isMainThread]) {
        [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic ];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic ];
        });
    }

}


- (void)onUpdateCell:(UITableViewCell *)cell model:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    [cell update:model atIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForCell:(id)cell
{
    return [self.tableView indexPathForCell:cell];
}

- (NSIndexPath *)indexPathForSelectedCell
{
    return [self.tableView indexPathForSelectedRow];
}

- (id )cellForindexPath:(NSIndexPath *)indexPath
{
    return [self.tableView cellForRowAtIndexPath:indexPath];
}



- (YCNextBlock)nextBlock
{
    if (!_nextBlock) {
        WSELF;
        _nextBlock = ^(NSArray *x) {
            SSELF;
            YCPageInfo *pageInfo = self.viewModel.pageInfo;
            if (pageInfo.status == YCLoadingStatusRefresh) {
                pageInfo.status = YCLoadingStatusDefault;

                //TODO:改了一下
//                [self onReloadItems:x.count];
                [self onReloadItems:0];
                if (pageInfo.lastPage) {
                    [self.loadControl hideLoading];
                } else {
                    [self.loadControl showLoading];
                }


            }
            
            else if (pageInfo.status == YCLoadingStatusLoadMore) {
                [self onInsertItemsIntoBack:x.count];
            }
            
            else {
              //TODO:这里我改了一下
//                [self onReloadItems:x.count];
                
                [self onReloadItems:0];
                if (pageInfo.lastPage) {
                    [self.loadControl hideLoading];
                }

            }


        };
    }
    return _nextBlock;
}

- (YCExecutingBlock)executingBlock
{
    if (!_executingBlock) {
        WSELF;
        _executingBlock = ^(BOOL isExecuting){
            SSELF;
            dispatch_async_on_main_queue(^{
                if (isExecuting) {
                    [self.indicator startAnimating];
                    
                }
                
                else {
                    [self.indicator stopAnimating];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.refresh coverAnimated:YES];
                    });
                }
            });

        };
    }
    return _executingBlock;
}

- (YCCompleteBlock)completeBlock
{
    if (!_completeBlock) {
        WSELF;
        _completeBlock = ^(void) {
            SSELF;
            [self onSetupEmptyView];
            
        };
    }
    return _completeBlock;
}

- (void)onScrollToBottom:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;

    CGFloat height = CGRectGetHeight(scrollView.bounds);

    CGSize size = scrollView.contentSize;

    UIEdgeInsets inset = scrollView.contentInset;

    CGFloat currentOffset = offset.y + height - inset.bottom;

    CGFloat maximumOffset = size.height;

    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情

    if((maximumOffset - currentOffset)<= 5.f)
    {

        if (scrollView.isTracking) {
            return;
        }
        YCPageInfo *pageInfo = self.viewModel.pageInfo;
        if (pageInfo.status != YCLoadingStatusDefault) {
            return;
        }


        if (!pageInfo.loadmoreId) {
            return;
        }
        
        
        if (pageInfo.lastPage) {
            self.tableView.bounces = YES;
            [self.loadControl hideLoading];
            return;
        }

        pageInfo.status = YCLoadingStatusLoadMore;

        //self.tableView.bounces = NO;
        [self.loadControl showLoading];
        
        WSELF;
        [self executeSignal:self.viewModel.mainSignal next:^(NSArray *next) {
            SSELF;
            if (self.nextBlock) {
                self.nextBlock(next);
                self.tableView.bounces = YES;
                if (pageInfo.lastPage) {
                    [self.loadControl hideLoading];
                }
            }

            pageInfo.status = YCLoadingStatusDefault;
        } error:^(NSError *error) {
            SSELF;
            if (self.errorBlock) {
                self.errorBlock(error);
                self.tableView.bounces = YES;
                if (pageInfo.lastPage) {
                    [self.loadControl hideLoading];
                } else {
                    [self.loadControl errorLoading];
                }
                
                pageInfo.status = YCLoadingStatusDefault;
            }
        } completed:nil executing:nil];

        NSLog(@"-----加载数据-----");

    }
}

- (void)onMoreComment:(UIButton *)sender
{
    
}


- (YCLoadControl *)loadControl
{
    if (!_loadControl) {
        _loadControl = [YCLoadControl creatDefaultLoadView];
    }
    return _loadControl;
}

- (YCMoreButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [YCMoreButton creatDefaultMoreButton];
        [_moreButton addTarget:self action:@selector(onMoreComment:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    UIViewController *vc = segue.sourceViewController;
//    vc.hidesBottomBarWhenPushed = YES;
//}
@end


@implementation YCBTableViewController
- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self onSetupHeaderFooter];
}

- (void)onSetupCell
{
    [self.viewModel.cellIds enumerateObjectsUsingBlock:^(NSString  *_Nonnull cellId, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tableView registerClass:[YCTableVIewCell class] forCellReuseIdentifier:cellId];
    }];
}

- (void)onSetupHeaderFooter
{
    [self.viewModel.headerFooterIds enumerateObjectsUsingBlock:^(NSString  *_Nonnull headerFooterId, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tableView registerClass:[YCTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterId];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.viewModel isKindOfClass:[YCAutoPageViewModel class]]) {
        YCAutoPageViewModel *apm = (YCAutoPageViewModel *)self.viewModel;
        [apm.cellInfos enumerateObjectsUsingBlock:^(YCCellInfo  *_Nonnull cellInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView registerClass:[YCTableVIewCell class] forCellReuseIdentifier:cellInfo.Id];
        }];
    }
    return [super numberOfSectionsInTableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.viewModel heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self.viewModel heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerId = [self.viewModel headerIDInSection:section];
    if (!headerId) {
        return nil;
    }
    YCTableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!header) {
        header = [[YCTableViewHeaderFooterView alloc]initWithReuseIdentifier:headerId];
    }
    NSParameterAssert([header isKindOfClass:[YCTableViewHeaderFooterView class]]);
    header.section = section;
    header.headerDelegate = self;
    if (header.updateBlock) {
        header.updateBlock(header,header.contentView,section);
    }
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *footerId = [self.viewModel headerIDInSection:section];
    if (!footerId) {
        return nil;
    }
    YCTableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerId];
    if (!footer) {
        footer = [[YCTableViewHeaderFooterView alloc]initWithReuseIdentifier:footerId];
    }
    NSParameterAssert([footer isKindOfClass:[YCTableViewHeaderFooterView class]]);
    footer.section = section;
    footer.footerDelegate = self;
    if (footer.updateBlock) {
        footer.updateBlock(footer,footer.contentView,section);
    }
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [self.viewModel cellIDAtIndexPath:indexPath];
    NSParameterAssert(cellId);
    
    YCTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.delegate = self;
    [cell updateAtIndexPath:indexPath];
    return cell;
}


- (void)onConfigureCell:(__weak YCTableVIewCell *)cell reuseIdentifier:(NSString *)reuseIdentifier
{
    
}

- (void)onConfigureHeader:(YCTableViewHeaderFooterView *)header reuseIdentifier:(NSString *)reuseIdentifier
{
    
}

- (void)onConfigureFooter:(YCTableViewHeaderFooterView *)footer reuseIdentifier:(NSString *)reuseIdentifier
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCTableVIewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSParameterAssert([cell isKindOfClass:[YCTableVIewCell class]]);
    if (cell.selectBlock) {
        cell.selectBlock(cell,cell.contentView,indexPath);
    }
}
@end