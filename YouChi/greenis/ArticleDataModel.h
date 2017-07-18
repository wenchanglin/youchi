//
//  ArticleDataModel.h
//
//
//  Created by LICAN LONG on 15/7/16.
//
//

#import <Foundation/Foundation.h>

@interface ArticleDataModel : BaseModel

@property (strong,nonatomic) NSString * imageUrl;
@property (strong,nonatomic) NSString * userName;
@property (strong,nonatomic) NSString * addtime;
@property (strong,nonatomic) NSString * articleid;
@property (strong,nonatomic) NSString * click;
@property (strong,nonatomic) NSString * commentTotal;
@property (strong,nonatomic) NSString * formulasTotal;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * zhaiyao;

@end

@interface ArticleDatas : NSObject
@property (nonatomic, strong) NSArray *datas;
@end