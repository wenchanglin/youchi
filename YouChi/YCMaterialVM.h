//
//  YCMuchFruitVM.h
//  YouChi
//
//  Created by 李李善 on 15/5/22.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCViewModel.h"
#import "YCRecipeDetailVM.h"

#import "YCMaterialAddM.h"

@interface YCMaterialVM : YCPageViewModel
@property (nonatomic,strong) NSString *name,*categoryName,*tips,*html5Path,*desc,*describe;

@property (nonatomic,assign) NSInteger difficultyType,spendTimeType;

@property (nonatomic,strong) NSMutableArray *recipeSteps,*recipeMaterials,*recipeMaterial,*recipeAssistant;

@property (nonatomic,strong) NSArray *difficultys,*spendTimes;

///编辑食材时候的model
@property (nonatomic,strong) YCMaterialList *editModel;

@property (nonatomic,assign) BOOL isEditMode; //是否编辑模式

@property (nonatomic,strong) YCRecipeDetailVM *editRecipeDetailVM;

@property (nonatomic,strong) NSString *relativeMaterial;

- (void )updateMyData:(YCChihuoyingM_1_2 *)x;

- (NSDictionary *)getSpendTimeByIndex:(NSInteger)index;
- (NSString *)getSpendTimeStringByTime:(int)miniTime;
- (NSString *)getDifficultyByType:(NSInteger)index;
@end
