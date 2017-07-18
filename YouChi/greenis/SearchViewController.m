//
//  SearchViewController.m
//  Fruit_juice_iOS6_Masonry_Version
//
//  Created by LICAN LONG on 15/8/27.
//  Copyright (c) 2015年 LICAN LONG. All rights reserved.
//

#import "SearchViewController.h"
#import "AppConstants.h"
#import "Masonry.h"
#import "ProgressHUD.h"
#import "PlistEditor.h"

#import "AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

#import "CollectionContainer.h"
#import "SearchResultViewController.h"
#import "UIViewController+Action.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CollectionContainerDelegate>

@property (strong, nonatomic) UISearchBar                       *searchBar;
//热门搜索的（西瓜等）
@property (strong, nonatomic) CollectionContainer               *hotListCollectionContainer;
@property (strong, nonatomic) NSArray                           *tagsArray;
@property (strong, nonatomic) NSMutableArray                    *historySearchArray;
@property (strong, nonatomic) UITableView                       *historySearchTableView;
@property (strong, nonatomic) SearchResultViewController        *searchResultViewController;
@property (nonatomic) BOOL                                      isSearching;
/*
@property (strong, nonatomic) NSMutableArray                    *effectArray;
@property (strong, nonatomic) NSMutableArray                    *formulaIDArray;
@property (strong, nonatomic) NSMutableArray                    *formulaNameArray;
@property (strong, nonatomic) NSMutableArray                    *imageArray;
@property (strong, nonatomic) NSMutableArray                    *ingredientsArray;
@property (strong, nonatomic) NSMutableArray                    *introductionArray;
@property (strong, nonatomic) NSMutableArray                    *stepsArray;
@property (strong, nonatomic) NSMutableArray                    *userNickNameArray;
@property (strong, nonatomic) NSMutableArray                    *videoUrlArray;
@property (strong, nonatomic) NSMutableArray                    *albumsTotalArray;
@property (strong, nonatomic) NSMutableArray                    *commentTotalArray;
@property (strong, nonatomic) NSMutableArray                    *friendsTotalArray;
@property (strong, nonatomic) NSMutableArray                    *stepTotalArray;
@property (strong, nonatomic) NSMutableArray                    *tagsTotalArray;
@property (strong, nonatomic) NSMutableArray                    *shareUrlArray;
*/
@property (strong, nonatomic) NSMutableArray                    *IntroduceDataDics;
@property (strong, nonatomic) NSMutableArray                    *IntroduceDatas;
@end

@implementation SearchViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:234.0/255.0 blue:232.0/255.0 alpha:1.0];
    
    
    _isSearching = NO;
    /*
    _effectArray = [NSMutableArray arrayWithCapacity:100];
    _formulaIDArray = [NSMutableArray arrayWithCapacity:100];
    _formulaNameArray = [NSMutableArray arrayWithCapacity:100];
    _imageArray = [NSMutableArray arrayWithCapacity:100];
    _ingredientsArray = [NSMutableArray arrayWithCapacity:100];
    _introductionArray = [NSMutableArray arrayWithCapacity:100];
    _stepsArray = [NSMutableArray arrayWithCapacity:100];
    _userNickNameArray = [NSMutableArray arrayWithCapacity:100];
    _videoUrlArray = [NSMutableArray arrayWithCapacity:100];
    _albumsTotalArray = [NSMutableArray arrayWithCapacity:100];
    _commentTotalArray = [NSMutableArray arrayWithCapacity:100];
    _friendsTotalArray = [NSMutableArray arrayWithCapacity:100];
    _stepTotalArray = [NSMutableArray arrayWithCapacity:100];
    _tagsTotalArray = [NSMutableArray arrayWithCapacity:100];
    _shareUrlArray = [NSMutableArray arrayWithCapacity:100];
    */
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initSearchBar];
    
    [self getHotList];
    
//    [self initHistoryList];
}

- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    _searchBar.placeholder = NSLocalizedString(@"searchPlaceholder", @"");
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    
    // Change search bar text color
    searchField.textColor = [UIColor whiteColor];
    
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
}


- (void)hideSearchBarKeyboard {
    [_searchBar setShowsCancelButton:FALSE animated:YES];
    [_searchBar resignFirstResponder];
}

- (void)clearArrays {
    /*
    [_effectArray removeAllObjects];
    [_effectArray removeAllObjects];
    [_formulaIDArray removeAllObjects];
    [_formulaNameArray removeAllObjects];
    [_imageArray removeAllObjects];
    [_ingredientsArray removeAllObjects];
    [_introductionArray removeAllObjects];
    [_stepsArray removeAllObjects];
    [_userNickNameArray removeAllObjects];
    [_videoUrlArray removeAllObjects];
    [_albumsTotalArray removeAllObjects];
    [_commentTotalArray removeAllObjects];
    [_friendsTotalArray removeAllObjects];
    [_stepTotalArray removeAllObjects];
    [_tagsTotalArray removeAllObjects];*/
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([AppConstants downloadButtonPress2Pop]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (void)sendSearchRequestByKeyword:(NSString*)keyword {
    
    if (_isSearching) {
        return;
    }
    
    _isSearching = YES;
    
    [ProgressHUD show:NSLocalizedString(@"searching", @"")];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@resource/formula/keyword/list/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"page":@"1", @"pageSize":@"30", @"Keyword":keyword};
    
    [HTTP_CLIENT POST:urlString parameters:parameters
          progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSLog(@"22222success urlString = 11111111%@", urlString);
              NSLog(@"Success: %@", responseObject);
              
              _isSearching = NO;
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSLog(@"搜索成功 %@", responseObject);
                  
                  _IntroduceDataDics = [[NSMutableArray alloc] init];
                  _IntroduceDatas = [[NSMutableArray alloc] init];
                  
                  if ([[responseObject valueForKey:@"total"] intValue] != 0) {
                      
                      NSArray *formulas = [responseObject objectForKey:@"formulas"];
                      //所有的数据
                      [_IntroduceDataDics addObjectsFromArray:formulas];
                      
                      for (int i = 0; i < _IntroduceDataDics.count; i++) {
                          IntroduceDataModel *dataModel = [[IntroduceDataModel alloc] init];
                          dataModel.effect = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Effect"];
                          dataModel.formulaID = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"FormulaID"];
                          dataModel.formulaName = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"FormulaName"];
                          dataModel.imageUrl = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"ImgUrl"];
                          dataModel.ingredients = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Ingredients"];
                          dataModel.introduction = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Introduction"];
                          dataModel.steps = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"Steps"];
                          dataModel.userNickName = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"UserNickName"];
                          dataModel.videoUrl = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"VideoUrl"];
                          dataModel.albumsTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"albums_total"];
                          dataModel.commentTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"comment_total"];
                          dataModel.friendsTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"friends_total"];
                          dataModel.stepTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"step_total"];
                          dataModel.tagsTotal = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"tags_total"];
                          dataModel.shareUrl = [[_IntroduceDataDics objectAtIndex:i] objectForKey:@"share_url"];
                          
                          [_IntroduceDatas addObject:dataModel];
                      }
                      
                      [ProgressHUD dismiss];
                      
                      [self showSearchResultWithSearchKeyword:keyword];
                  }
                  else {
                      [ProgressHUD showError:NSLocalizedString(@"searchNothing", @"")];
                  }
                  
              }
              else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                  NSLog(@"搜索失败 %@", urlString);
                  
                  [ProgressHUD showError:NSLocalizedString(@"searchFail", @"")];
                  
                  _tagsArray = nil;
                  
                  [self showHotList];
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"false urlString = %@", urlString);
              NSLog(@"Error: %@", error);
              
              _isSearching = NO;
              
              [ProgressHUD showError:NSLocalizedString(@"badNetwork", @"")];
              
          }];
}

- (void)showSearchResultWithSearchKeyword:(NSString*)Keyword {
    _searchResultViewController = [[SearchResultViewController alloc] initWithSearchKeyword:Keyword andDatas:_IntroduceDatas];
    [_searchResultViewController onSetupBackButton];
    [self.navigationController pushViewController:_searchResultViewController animated:YES];
    
    _searchResultViewController = nil;
}

- (void)sendSearchRequestByTagId:(NSString*)tagId {
    
    NSString *urlString = [NSString stringWithFormat:@"%@resource/formula/tag/list/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = @{@"page":@"1", @"pageSize":@"10", @"TagId":tagId};
    
    [HTTP_CLIENT POST:urlString parameters:parameters
          progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSLog(@"success urlString = %@", urlString);
              NSLog(@"Success: %@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSLog(@"获取搜索列表成功 %@", responseObject);
                  
                  //_tagsArray = [responseObject objectForKey:@"tags"];
                  
                  //                  [ProgressHUD showError:@"获取热门搜索列表失败。。。"];
                  
                  [self showHotList];
              }
              else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                  NSLog(@"获取搜索列表失败 %@", urlString);
                  
                  [ProgressHUD showError:@"获取热门搜索列表失败。。。"];
                  
                  _tagsArray = nil;
                  
                  [self showHotList];
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"false urlString = %@", urlString);
              NSLog(@"Error: %@", error);
              
          }];
}

- (void)getHotList {
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@resource/tag/hot/list/index.ashx", [AppConstants httpHeader]];
    
    NSDictionary *parameters = nil;//@{@"page":@"1", @"pageSize":@"10"};
    
    [HTTP_CLIENT POST:urlString parameters:parameters
          progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
//              NSLog(@"success urlString = %@", urlString);
//              NSLog(@"Success: %@", responseObject);
              
              if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 1) {
                  NSLog(@"获取搜索列表成功 %@", responseObject);
                  
                  _tagsArray = [responseObject objectForKey:@"tags"];
                  
              }
              else if ([((NSNumber*)[responseObject objectForKey:@"ok"]) intValue] == 0) {
                  NSLog(@"获取搜索列表失败 %@", urlString);
                  
                  [ProgressHUD showError:NSLocalizedString(@"getTopSearchesListFail", @"")];
                  
                  _tagsArray = nil;
              }
              
              [self showHotList];
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"false urlString = %@", urlString);
              NSLog(@"Error: %@", error);
              
              [ProgressHUD showError:NSLocalizedString(@"badNetwork", @"")];
          }];
}

- (void)showHotList {
    _hotListCollectionContainer = [[CollectionContainer alloc] initWithTags:_tagsArray];
    _hotListCollectionContainer.backgroundColor = [UIColor grayColor];
    _hotListCollectionContainer.delegate = self;

    [self.view addSubview:_hotListCollectionContainer];
    
    [_hotListCollectionContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(10);
        make.left.equalTo(self.view).with.offset(10);
//        make.right.equalTo(self.view).with.offset(-10);
    }];
    
    
    _historySearchArray = [NSMutableArray arrayWithCapacity:1000];
    int historySearchCount = [[PlistEditor queryPlist:@"AppInfo" withKey:@"historySearchCount"] intValue];
    for (int i = 1; i <= historySearchCount; ++i) {
        [_historySearchArray addObject:[PlistEditor queryPlist:@"AppInfo" withKey:[NSString stringWithFormat:@"historySearch%d", i]]];
    }

    [self initHistorySearchList];
}

- (void)initHistorySearchList {
    _historySearchTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _historySearchTableView.delegate = self;
    _historySearchTableView.dataSource = self;
    
    [self.view addSubview:_historySearchTableView];
    
    [_historySearchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hotListCollectionContainer.mas_bottom).with.offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[PlistEditor queryPlist:@"AppInfo" withKey:@"historySearchCount"] intValue] + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell0];
    UILabel *label = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell0];
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        
        [cell addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(cell).with.offset(30);
        }];
    }
    
    
    if (indexPath.row == 0) {
        label.text = NSLocalizedString(@"clearSearchHistory", @"");
        label.textColor = [UIColor redColor];
    }
    else {
        label.text = [_historySearchArray objectAtIndex:indexPath.row - 1];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"select indexPath.row = %ld", (long)indexPath.row);
    
    if (indexPath.row == 0) {
        [[AppConstants UpdatingPlistLock] lock];
        
        [PlistEditor alterPlist:@"AppInfo" alertValue:@"0" forKey:@"historySearchCount"];
        [AppConstants writeDic2File];
        
        [[AppConstants UpdatingPlistLock] unlock];
        
        [_historySearchArray removeAllObjects];
        [_historySearchTableView reloadData];
    }
    else {
        [self sendSearchRequestByKeyword:[_historySearchArray objectAtIndex:indexPath.row - 1]];
        NSLog(@"search keyword = %@", [_historySearchArray objectAtIndex:indexPath.row - 1]);
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return NSLocalizedString(@"searchHistory", @"");
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideSearchBarKeyboard];
}

#pragma mark - CollectionContainerDelegate

- (void)collectionContainerClickAtKeyword:(NSString*)keyword {
//    NSLog(@"keyword = %@", keyword);
    
    [self sendSearchRequestByKeyword:keyword];
}

#pragma mark - UISearchBar delegate Method
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_searchBar setShowsCancelButton:TRUE animated:YES];
    
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:NSLocalizedString(@"quxiao", @"") forState:UIControlStateNormal];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
/*    [UIView animateWithDuration:0.3 animations:^ {
        _searchBar.frame = CGRectMake(10, [AppConstants searchBarY], [AppConstants searchBarWidth] + [AppConstants searchBarX] - 10, 0);
    }];*/
    
//    _blurView.hidden = FALSE;
    /*
    [_searchBar setShowsCancelButton:TRUE animated:YES];
    
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }*/
    
    return TRUE;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
/*    [UIView animateWithDuration:0.3 animations:^ {
        _searchBar.frame = CGRectMake([AppConstants searchBarX], [AppConstants searchBarY], [AppConstants searchBarWidth] , 0);
    }];*/
    
//    _blurView.hidden = TRUE;
    [self hideSearchBarKeyboard];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"%@", searchBar.text);
    
    [self hideSearchBarKeyboard];
    
    BOOL isHadSearched = NO;
    
    for (NSString *history in _historySearchArray) {
        NSLog(@"history = %@, search = %@", history, searchBar.text);
        if ([searchBar.text isEqualToString:history]) {
            isHadSearched = YES;
        }
    }
    
    if (!isHadSearched) {
        [[AppConstants UpdatingPlistLock] lock];
        
        int historySearchCount = [[PlistEditor queryPlist:@"AppInfo" withKey:@"historySearchCount"] intValue];
        [PlistEditor alterPlist:@"AppInfo" alertValue:[NSString stringWithFormat:@"%d", historySearchCount + 1] forKey:@"historySearchCount"];
        [PlistEditor alterPlist:@"AppInfo" alertValue:searchBar.text forKey:[NSString stringWithFormat:@"historySearch%d", historySearchCount + 1]];
        [AppConstants writeDic2File];
        
        [[AppConstants UpdatingPlistLock] unlock];
    }
    
    [_historySearchArray addObject:_searchBar.text];
    [_historySearchTableView reloadData];
    
    [self sendSearchRequestByKeyword:searchBar.text];
//    [self sendSearchRequestByTagId:@"27"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideSearchBarKeyboard];
}

@end
