//
//  YCEditAddressVC.m
//  YouChi
//
//  Created by 朱国林 on 15/12/24.
//  Copyright © 2015年 Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//
/**
 TODO: + 说明：
 如果代码中有该标识，说明在标识处有功能代码待编写，待实现的功能在说明中会简略说明。
 
 FIXME: + 说明：
 如果代码中有该标识，说明标识处代码需要修正，甚至代码是错误的，不能工作，需要修复，如何修正会在说明中简略说明。
 
 MARK: + 说明：
 如果代码中有该标识，说明标识处代码虽然实现了功能，但是实现的方法有待商榷，希望将来能改进，要改进的地方会在说明中简略说明。
 */
#import "YCRecipientAddressVC.h"
#import "YCTableViewController.h"
#import "YCEditAddressVC.h"
#import "YCRecipientAddressVM.h"
@interface YCEditAddressVCP ()
PROPERTY_STRONG_VM(YCEditAddressVM);

@end
@implementation YCEditAddressVCP
SYNTHESIZE_VM;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.title;
    
}
- (id)onCreateViewModel{
    
    return [YCEditAddressVM new];
}

#pragma mark - 保存
- (IBAction)onSaveAddress:(UIButton *)sender {
    
    if (self.viewModel.isEdit==NO) {
        CHECK(!self.viewModel.consigneeName.length, @"没有填写名字");
        CHECK(!self.viewModel.phoneNumber.length,@"没有填写电话号码");
        CHECK(!self.viewModel.postcode.length,@"没有填写邮编号码");
        CHECK(!self.viewModel.detailAddress.length,@"没有填写详细地址");
        CHECK(!self.viewModel.provinceModel.provinceId,@"选择填写省份");
        CHECK(!self.viewModel.cityModel.cityId,@"选择填写城市");
        CHECK(!self.viewModel.districtModel.townId,@"选择填写区号");
        WSELF;
        [self executeSignal:self.viewModel.addAddressSignal next:^(YCRecipientAddressM *m){
            SSELF;
            [self showMessage:@"成功添加地址"];
            [self onSetDefaultAddress:m];
            
        }error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
    }
    else
    {
        CHECK(!self.viewModel.model.receiverName.length, @"没有填写名字");
        CHECK(!self.viewModel.model.receiverPhone.length,@"没有填写电话号码");
        CHECK(!self.viewModel.model.receiverZip.length,@"没有填写邮编号码");
        CHECK(!self.viewModel.model.receiverAddress.length,@"没有填写详细地址");
        CHECK(!self.viewModel.model.provinceName.length,@"选择填写省份");
        CHECK(!self.viewModel.model.cityName.length,@"选择填写城市");
        CHECK(!self.viewModel.model.townName.length,@"选择填写区号");
        CHECK(!self.viewModel.model.provinceId,@"选择填写省份");
        CHECK(!self.viewModel.model.cityId,@"选择填写城市");
        CHECK(!self.viewModel.model.townId,@"选择填写区号");
        WSELF;
        [self executeSignal:self.viewModel.updateAddressSignal next:^(YCRecipientAddressM *m){
            SSELF;
            [self showMessage:@"成功修改地址"];
            [self onSetDefaultAddress:m];
        }error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
    }
    
}

/// 修改或者添加新地址时，，设置为默认地址
- (void)onSetDefaultAddress:(YCRecipientAddressM *)m{
    
    NSArray *vcs = self.navigationController.viewControllers;
    
    YCRecipientAddressVC *recipientAddressVC;
    
    for (YCRecipientAddressVC *vc in vcs) {
        
        if ([vc isKindOfClass:[YCRecipientAddressVC class]]) {
            recipientAddressVC = vc;
            [recipientAddressVC.viewModel.addressChangedSignal sendNext:m];
            
        }
    }
    
    if (recipientAddressVC) {
        
        
        // 把原来的默认地址去掉，把新修改或者添加的地址设置为默认
        NSInteger index = [vcs indexOfObject:recipientAddressVC] - 1;
        
        [self.navigationController popToViewController:vcs[index] animated:YES];
    } else {
        [self.viewModel.addressDidUpdateSignal sendNext:m];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)onMainSignalExecute:(UIRefreshControl *)sender
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setViewModel:self.viewModel];
}

@end

@interface YCEditAddressVC ()<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>

PROPERTY_STRONG_VM(YCEditAddressVM);

///pickerView
@property(nonatomic,strong)IBOutlet UIPickerView *PickerView;
@property(nonatomic,strong)IBOutlet UIView *supView;
///定位按钮
@property(nonatomic,strong)IBOutlet UIButton *btnProvince;
@property(nonatomic,strong)IBOutlet UIButton *btnDistrict;
@property(nonatomic,strong)IBOutlet UIButton *btnCity;

///new
@property(nonatomic,strong) NSString *newtitle;
///old
@property(nonatomic,strong) NSString *oldtitle;
///是否隐藏键盘
@property(nonatomic,assign) BOOL isHiddenKeyBoard;
///保存定位的位置
@property(nonatomic,strong) YCLocationInfo *meLocation;



@end

@implementation YCEditAddressVC
SYNTHESIZE_VM;

-(void)dealloc{
    
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
/**
 isEdit
 YES:是收货地址编辑
 NO:添加地址
 
 _update
 NO:不更新
 YES:更新
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    WSELF;
    
    self.PickerView.delegate = self;
    self.PickerView.dataSource = self;
    if (self.viewModel.isEdit) {
        ///名字
        YCRecipientAddressM *m = self.viewModel.model;
        RACChannelTo(m,receiverName) = self.name.rac_newTextChannel;
        ///电话号码
        RACChannelTo(m,receiverPhone) = self.phone.rac_newTextChannel;
        ///邮编号码
        RACChannelTo(m,receiverZip) = self.postcode.rac_newTextChannel;
        ///详细地址
        RACChannelTo(m,receiverAddress) = self.detailAddress.rac_newTextChannel;
        ///输入框赋值
        self.name.text = m.receiverName;
        self.phone.text = m.receiverPhone;
        self.postcode.text = m.receiverZip;
        self.detailAddress.text = m.receiverAddress;
        ///按钮
        [self.btnProvince setTitle:m.provinceName forState:UIControlStateNormal];
        [self.btnCity setTitle:m.cityName forState:UIControlStateNormal];
        [self.btnDistrict setTitle:m.townName forState:UIControlStateNormal];
        
    }
    
    
    else{
        
        [self.viewModel.getLocationInformationSignal.deliverOnMainThread subscribeNext:^(YCLocationInfo *x) {
            SSELF;
            //当定位没有失败
            if (x) {
                self.meLocation =x;
                [self.btnProvince setTitle:x.lastProvince forState:UIControlStateNormal];
                [self.btnCity setTitle:x.lastCity forState:UIControlStateNormal];
                [self.btnDistrict setTitle:x.lastDistrict forState:UIControlStateNormal];
                [[[[self.viewModel.getProvinceList flattenMap:^RACStream *(NSArray<YCRecipientAddressM *> *value) {
                    __block NSNumber *provinceId = 0;
                    [value enumerateObjectsUsingBlock:^(YCRecipientAddressM * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.name isEqualToString:x.lastProvince]) {
                            provinceId = obj.provinceId;
                            self.viewModel.provinceModel = obj;
                            *stop = YES;
                        }
                    }];
                    return [self.viewModel getCityListWithFrmoProvince:provinceId];
                }]
                 flattenMap:^RACStream *(NSArray<YCRecipientAddressM *> *value) {
                    __block NSNumber *cityId = 0;
                    [value enumerateObjectsUsingBlock:^(YCRecipientAddressM * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.name isEqualToString:x.lastCity]) {
                            cityId = obj.cityId;
                            self.viewModel.cityModel = obj;
                            *stop = YES;
                        }
                    }];
                     return [self.viewModel getTownListWithFrmoCity:cityId];
                }]
                 flattenMap:^RACStream *(NSArray<YCRecipientAddressM *> *value) {
                     __block NSNumber *townId = 0;
                     [value enumerateObjectsUsingBlock:^(YCRecipientAddressM * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         if ([obj.name isEqualToString:x.lastDistrict]) {
                             townId = obj.townId;
                             self.viewModel.districtModel = obj;
                             *stop = YES;
                         }
                     }];
                     return [RACSignal empty];
                 }].deliverOnMainThread subscribeNext:^(id x) {
                     ;
                 } error:self.errorBlock];
                
                
            }
            
        } error:self.errorBlock];
        ///名字
        RAC(self.viewModel,consigneeName) =self.name.rac_textSignal ;
        ///电话号码
        RAC(self.viewModel,phoneNumber) =self.phone.rac_textSignal ;
        ///邮编号码
        RAC(self.viewModel,postcode) =self.postcode.rac_textSignal ;
        ///详细地址
        RAC(self.viewModel,detailAddress)= self.detailAddress.rac_textSignal;
    }
    
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification object:nil];
    
    [center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
    
}

#pragma mark-------键盘的监听方法
- (void)keyboardWillShow:(NSNotification*)aNotification{
    if (self.supView.hidden==NO){
        self.supView.hidden=YES;
    }
    self.isHiddenKeyBoard =YES;
}
- (void)keyboardWillHide:(NSNotification*)aNotification{
    if (self.supView.hidden==NO){
        self.supView.hidden=YES;
    }
    self.isHiddenKeyBoard =NO;
}


#pragma mark - 点击省市区
-(IBAction)onBtnLocation:(UIButton *)sender{
    if (self.supView.hidden){
        self.supView.hidden=NO;
    }
    if (self.viewModel.provinceS.count==0) {
        [self onSelectProvince];
    } else {
        [self.PickerView reloadAllComponents];
        @try {
            if (self.viewModel.provinceModel) {
                [self.PickerView selectRow:[self.viewModel.provinceS indexOfObject:self.viewModel.provinceModel] inComponent:0 animated:NO];
                if (self.viewModel.cityModel) {
                    [self.PickerView selectRow:[self.viewModel.cityS indexOfObject:self.viewModel.cityModel] inComponent:1 animated:NO];
                    if (self.viewModel.districtModel) {
                        [self.PickerView selectRow:[self.viewModel.townS indexOfObject:self.viewModel.districtModel] inComponent:2 animated:NO];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            ;
        }
    }
    if (self.isHiddenKeyBoard==YES) {
        [self.view endEditing:YES];
    }
    
    
}

#pragma mark-------确定按钮和取消按钮
-(IBAction)onSureAndCancel:(UIButton *)btn{
    
    switch (btn.tag) {
        case 10:
        {
            [self keyboardWillHide:nil];
        }
            break;
            
        default:{
            {
                //省份
                NSString *provinceName = self.viewModel.provinceModel.name;
                self.viewModel.model.provinceId =self.viewModel.provinceModel.provinceId;
                [self.btnProvince setTitle:provinceName forState:UIControlStateNormal];
                //城市
                NSString *cityName = self.viewModel.cityModel.name;
                self.viewModel.model.cityId =self.viewModel.cityModel.cityId;
                [self.btnCity setTitle:cityName forState:UIControlStateNormal];
                //区
                NSString *district =self.viewModel.districtModel.name;
                self.viewModel.model.townId =self.viewModel.districtModel.townId;
                [self.btnDistrict setTitle:district forState:UIControlStateNormal];
                [self keyboardWillHide:nil];
            }
        }
            break;
    }
    
    
}
#pragma mark-------开始编辑的时候
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.supView.hidden==NO){
        self.supView.hidden=YES;
    }
    return YES;
}



- (void)onSetupActivityIndicatorView{
    
}




#pragma mark-------网络请求
/**
 *  获取城市列表
 *
 *  @return CityId:所在的省份ID
 */
-(void)onGetCityWithFrmoProvince:(NSNumber *)provinceId{
    if (provinceId) {
        WSELF;
        [self executeSignal:[self.viewModel getCityListWithFrmoProvince:provinceId] next:^(id next) {
            SSELF;
            [self.PickerView reloadComponent:1];
            [self pickerView:self.PickerView didSelectRow:0 inComponent:1];
            
        }error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
    }
}



/**
 *  获取区列表
 *
 *  @return CityId:所在的城市ID
 */

-(void)onGetDistrictWithFrmoCity:(NSNumber *)CityId{
    if (CityId) {
        [self executeSignal:[self.viewModel getTownListWithFrmoCity:CityId] next:^(id next) {
            ///更新区
            [self.PickerView reloadComponent:2];
            [self pickerView:self.PickerView didSelectRow:0 inComponent:2];
            
        } error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
    }
}

- (void)onSelectProvince
{
    WSELF;
    [self executeSignal:self.viewModel.getProvinceList next:^(NSArray *next){
        SSELF;
        [self.PickerView reloadComponent:0];
        [self pickerView:self.PickerView didSelectRow:0 inComponent:0];
        
    }error:self.errorBlock completed:self.completeBlock executing:self.executingBlock];
    
}



#pragma mark-------PickerView代理方法
#pragma mark-------PickerView点击事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    @try {
        if (component==0) {
            self.viewModel.provinceModel=self.viewModel.provinceS[row];
            [self onGetCityWithFrmoProvince:self.viewModel.provinceModel.provinceId];
        }
        else if (component==1){
            self.viewModel.cityModel=self.viewModel.cityS[row];
            
            
            [self onGetDistrictWithFrmoCity:self.viewModel.cityModel.cityId];
        }
        else if (component == 2){
            
            self.viewModel.districtModel= self.viewModel.townS[row];
            
        }
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return  self.viewModel.provinceS.count;
    }
    else if (component==1){
        return self.viewModel.cityS.count;
    }
    else if (component==2){
        return  self.viewModel.townS.count;
    }
    return  0;
    
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0){
        YCRecipientAddressM *m =self.viewModel.provinceS[row];
        return m.name;
    }
    else if (component==1){
        YCRecipientAddressM *m = self.viewModel.cityS[row];
        return m.name;
    }
    else if (component==2){
        YCRecipientAddressM *m = self.viewModel.townS[row];
        return m.name;
    }
    return nil;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 60.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.f;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 
 */

@end
