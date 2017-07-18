//
//  YCNewSkillYM.h
//  YouChi
//
//  Created by 李李善 on 15/5/20.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCMaterialVM.h"
#import "YCRecipeStepListM.h"
@interface YCRecipeStepListVM : YCPageViewModel
@property (nonatomic,strong) YCMaterialVM *materialVM;

@property (nonatomic,strong) YCRecipeStepListM *editModel;

@property (nonatomic,assign) BOOL isEditMode; //是否编辑模式

@property (nonatomic,strong) UIImage *coverImage;
@property (nonatomic,assign) BOOL isCoverImageChanged;

- (RACSignal *)uploadSignal;
- (RACSignal *)editSignal;

@end
