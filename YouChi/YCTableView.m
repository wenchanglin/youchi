//
//  YCTableView.m
//  YouChi
//
//  Created by sam on 15/6/10.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCTableView.h"

@implementation YCTableView 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc{
    //ok
}

- (void)awakeFromNib
{
    __weak UITableView<UITableViewDataSource,UITableViewDelegate> *ws = self;
  
    self.dataSource = ws;
    self.delegate = ws;
    self.pagingEnabled = YES;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell0 forIndexPath:indexPath];
    self.updateBlock(cell,self.photos[indexPath.row]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightBlock) {
        return self.heightBlock(indexPath);
    }
    return tableView.rowHeight;
}

- (void)scrollViewDidEndDecelerating:(UITableView *)scrollView
{
    NSIndexPath *idp = [scrollView indexPathsForVisibleRows].lastObject;
    if (self.pageBlock) {
        self.pageBlock(idp,self.photos[idp.row]);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock(indexPath,self.photos?self.photos[indexPath.row]:nil);
    }
}

@end
