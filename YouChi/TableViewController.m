//
//  TableViewController.m
//  YouChi
//
//  Created by sam on 16/8/8.
//  Copyright © 2016年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "TableViewController.h"
@interface TableCellStyleValue1 : TableCell
@end
@implementation TableCellStyleValue1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}
@end
@interface TableCellStyleValue2 : TableCell
@end
@implementation TableCellStyleValue2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}
@end
@interface TableCellStyleSubtitle : TableCell
@end
@implementation TableCellStyleSubtitle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}
@end


@interface TableViewController ()

@end

@implementation TableViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _datas = [[NSMutableArray alloc]initWithCapacity:10];
        self.tableView.tableFooterView = [UIView new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)_setupWith:(NSArray *)cellInfos
{
    _cellInfos = cellInfos;
    for (CellInfo *cellInfo in _cellInfos) {
        if (cellInfo.style == UITableViewCellStyleDefault) {
            [self.tableView registerClass:[TableCell class] forCellReuseIdentifier:cellInfo.Id];
        } else if (cellInfo.style == UITableViewCellStyleValue1) {
            [self.tableView registerClass:[TableCellStyleValue1 class] forCellReuseIdentifier:cellInfo.Id];
        } else if (cellInfo.style == UITableViewCellStyleValue2) {
            [self.tableView registerClass:[TableCellStyleValue2 class] forCellReuseIdentifier:cellInfo.Id];
        } else if (cellInfo.style == UITableViewCellStyleSubtitle) {
            [self.tableView registerClass:[TableCellStyleSubtitle class] forCellReuseIdentifier:cellInfo.Id];
        }
        
    }
}

- (void)registerCellInfos:(NSArray<CellInfo *> *)cellInfos
{
    [self _setupWith:cellInfos];
}

- (void)setCellInfosBlock:(CellInfosBlock)cellInfosBlock
{
    NSParameterAssert(cellInfosBlock);
    [self registerCellInfos:cellInfosBlock(self.datas)];
}

- (id)modelForIndexPath:(NSIndexPath *)indexPath
{
    CellInfo *info = _cellInfos[indexPath.section];
    return info.modelBlock(indexPath);
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cellInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CellInfo *info = _cellInfos[section];
    return info.numberBlock(section);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellInfo *info = _cellInfos[indexPath.section];
    NSParameterAssert(info.Id);
    
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:info.Id forIndexPath:indexPath];
    cell.edge = info.edgeBlock(indexPath);
    NSParameterAssert([cell isKindOfClass:[TableCell class]]);
    if (cell.tableView != tableView) {
        cell.tableView = tableView;
        cell.initialIndexPath = indexPath;
        
        if ([_configureDelegate respondsToSelector:@selector(onConfigureCell:reuseIdentifier:tableView:)]) {
            [_configureDelegate onConfigureCell:cell reuseIdentifier:cell.reuseIdentifier tableView:tableView];
        }
        
    }
    
    
    [cell executeUpdate:indexPath];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellInfo *info = _cellInfos[indexPath.section];
    UIEdgeInsets edge = info.edgeBlock(indexPath);
    return info.heightBlock(indexPath)+edge.top+edge.bottom;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSParameterAssert([cell isKindOfClass:[TableCell class]]);
    [cell executeSelect:indexPath];
    
}

#pragma mark - headerFooter
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CellInfo *info = _cellInfos[section];
    return info.headInfo?info.headInfo.heightBlock([NSIndexPath indexPathForRow:0 inSection:section]):0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CellInfo *info = _cellInfos[section];
    return info.footInfo?info.footInfo.heightBlock([NSIndexPath indexPathForRow:0 inSection:section]):0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CellInfo *info = _cellInfos[section];
    
    if (!info.headInfo) {
        return nil;
    }
    NSString *headerFooterId = info.headInfo.Id;
    NSParameterAssert(headerFooterId);
    
    TableHeaderFooter *headerFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterId];
    if (!headerFooter) {
        headerFooter = [[TableHeaderFooter alloc]initWithReuseIdentifier:headerFooterId];
    }
    NSParameterAssert([headerFooter isKindOfClass:[TableHeaderFooter class]]);
    headerFooter.section = section;
    if (headerFooter.tableView != tableView && [_configureDelegate respondsToSelector:@selector(onConfigureHeader:reuseIdentifier:)]) {
        headerFooter.tableView = tableView;
        [_configureDelegate onConfigureHeader:headerFooter reuseIdentifier:headerFooterId];
    }
    
    [headerFooter executeUpdate:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    return headerFooter;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CellInfo *info = _cellInfos[section];
    
    if (!info.headInfo) {
        return nil;
    }
    NSString *headerFooterId = info.headInfo.Id;
    NSParameterAssert(headerFooterId);
    
    TableHeaderFooter *headerFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterId];
    if (!headerFooter) {
        headerFooter = [[TableHeaderFooter alloc]initWithReuseIdentifier:headerFooterId];
    }
    NSParameterAssert([headerFooter isKindOfClass:[TableHeaderFooter class]]);
    headerFooter.section = section;
    if (headerFooter.tableView != tableView && [_configureDelegate respondsToSelector:@selector(onConfigureFooter:reuseIdentifier:)]) {
        headerFooter.tableView = tableView;
        [_configureDelegate onConfigureFooter:headerFooter reuseIdentifier:headerFooterId];
    }
    [headerFooter executeUpdate:[NSIndexPath indexPathForRow:0 inSection:section]];
    return headerFooter;
}


@end
