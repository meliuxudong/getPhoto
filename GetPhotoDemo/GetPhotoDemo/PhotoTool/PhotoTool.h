//
//  PhotoTool.h
//  GetPhotoDemo
//
//  Created by 刘旭东 on 2017/10/18.
//  Copyright © 2017年 GetPhoto. All rights reserved.
//
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define NavHeight self.navigationController.navigationBar.frame.size.height
#define StatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define topViewHight ((NavHeight > 0 ? NavHeight : 44) + StatusHeight)
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoGroupModel : NSObject

@property (nonatomic, copy) NSString *title; //相册名字
@property (nonatomic, assign) NSInteger count; //该相册内相片数量
@property (nonatomic, strong) PHAsset *headImageAsset; //相册第一张图片缩略图
@property (nonatomic, strong) PHAssetCollection *assetCollection; //相册集，通过该属性获取该相册集下所有照片

@end

@interface PhotoGroupDetailModel : NSObject
@property (nonatomic ,strong) PHAsset *asset;
@property (nonatomic ,assign) BOOL isSelectState;
@property (nonatomic ,assign) NSInteger selectNumber;

@end

@interface PhotoTool : NSObject
+ (instancetype)sharePhotoTool;

/**
 * @brief 获取用户所有相册列表
 */
- (NSMutableArray<PhotoGroupModel *> *)getPhotoAblumList;


/**
 * @brief 获取相册内所有图片资源
 * @param ascending 是否按创建时间正序排列 YES,创建时间正（升）序排列; NO,创建时间倒（降）序排列
 */
- (NSMutableArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;


/**
 * @brief 获取指定相册内的所有图片
 */
- (NSMutableArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending;


/**
 * @brief 获取每个Asset对应的图片
 */
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion;


@end