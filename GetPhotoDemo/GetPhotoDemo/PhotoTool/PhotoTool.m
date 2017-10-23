//
//  PhotoTool.m
//  iOS9Sample-Photos
//
//  Created by admin on 2017/10/13.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import "PhotoTool.h"
#import "MBProgressHUD.h"

@implementation PhotoGroupModel

@end

@implementation PhotoGroupDetailModel

@end

@implementation PhotoTool
static PhotoTool *sharePhotoTool = nil;
+ (instancetype)sharePhotoTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePhotoTool = [[self alloc] init];
    });
    return sharePhotoTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePhotoTool = [super allocWithZone:zone];
    });
    return sharePhotoTool;
}

#pragma mark - 获取所有相册列表
- (void)getPhotoAblumList:(void(^)(NSMutableArray<PhotoGroupModel *> * array))block
{
    //    // 判断授权状态
    //    [self requestAuthorizatio:vc];
    //
//    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray<PhotoGroupModel *> *photoAblumList = [NSMutableArray array];
        [photoAblumList addObjectsFromArray:[self getSmartAlbums]];
        
        [photoAblumList addObjectsFromArray:[self getAlbums]];
        
        
        if (block) block(photoAblumList);
//    });
   
    
    
}
#pragma mark - 后续增加
//- (NSMutableArray<PhotoGroupModel *> *)getMomentAlbums{
//    //Photos 为我们自动生成的时间分组的相册
//    PHFetchResult<PHAssetCollection *> *collectionResultMoment = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeMoment subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    [collectionResultMoment enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
//        //过滤掉视频和最近删除
//        if (!([collection.localizedTitle isEqualToString:@"Recently Deleted"] ||
//              [collection.localizedTitle isEqualToString:@"Videos"])) {
//            NSArray<PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:NO];
//            if (assets.count > 0) {
//                PhotoGroupModel *ablum = [[PhotoGroupModel alloc] init];
//                ablum.title = [self transformAblumTitle:collection.localizedTitle];
//                ablum.count = assets.count;
//                ablum.headImageAsset = assets.firstObject;
//                ablum.assetCollection = collection;
//                [photoAblumList addObject:ablum];
//            }
//        }
//    }];

//}
#pragma mark - 获取所有智能相册
- (NSMutableArray<PhotoGroupModel *> *)getSmartAlbums{
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSMutableArray *photoAblumList = @[].mutableCopy;
    for (PHAssetCollection *collection in smartAlbums) {
    
//    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        //过滤掉视频或最近删除
        if (!(/*[collection.localizedTitle isEqualToString:@"Recently Deleted"] ||*/
              [collection.localizedTitle isEqualToString:@"Videos"])) {
            NSArray<PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:NO];
            if (assets.count > 0) {
                
                PhotoGroupModel *ablum = [[PhotoGroupModel alloc] init];
                ablum.title = collection.localizedTitle;
                ablum.count = assets.count;
                ablum.headImageAsset = assets.firstObject;
                ablum.assetCollection = collection;
                [photoAblumList addObject:ablum];
                
            }
        }
//    }];
    }
    return photoAblumList;
}
#pragma mark - 从 iTunes 同步来的相册，以及用户在 Photos 中自己建立的相册
- (NSMutableArray<PhotoGroupModel *> *)getAlbums{
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    NSMutableArray *photoAblumList = @[].mutableCopy;
    
    for (PHAssetCollection *collection in userAlbums) {
  
//    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<PHAsset *> *assets = [self getAssetsInAssetCollection:collection ascending:NO];
        if (assets.count > 0) {
            
            PhotoGroupModel *ablum = [[PhotoGroupModel alloc] init];
            ablum.title = collection.localizedTitle;
            ablum.count = assets.count;
            ablum.headImageAsset = assets.firstObject;
            ablum.assetCollection = collection;
            [photoAblumList addObject:ablum];
            
        }
//    }];
    }
    return photoAblumList;
}
/*
 Localized resources can be mixed YES
 //或者右键plist文件Open As->Source Code 添加
 <key>CFBundleAllowMixedLocalizations</key>
 <true/>
 */
//- (NSString *)transformAblumTitle:(NSString *)title
//{
//    if ([title isEqualToString:@"Slo-mo"]) {
//        return @"慢动作";
//    } else if ([title isEqualToString:@"Recently Added"]) {
//        return @"最近添加";
//    } else if ([title isEqualToString:@"Favorites"]) {
//        return @"最爱";
//    } else if ([title isEqualToString:@"Recently Deleted"]) {
//        return @"最近删除";
//    } else if ([title isEqualToString:@"Videos"]) {
//        return @"视频";
//    } else if ([title isEqualToString:@"All Photos"]) {
//        return @"所有照片";
//    } else if ([title isEqualToString:@"Selfies"]) {
//        return @"自拍";
//    } else if ([title isEqualToString:@"Screenshots"]) {
//        return @"屏幕快照";
//    } else if ([title isEqualToString:@"Camera Roll"]) {
//        return @"相机胶卷";
//    } else if ([title isEqualToString:@"Panoramas"]) {
//        return @"全景照片";
//    }
//    return nil;
//}

- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return result;
}

#pragma mark - 获取相册内所有照片资源
- (NSMutableArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    for (id obj in result) {

    
//    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        [assets addObject:asset];
//    }];

    }
    return assets;
}

#pragma mark - 获取指定相册内的所有图片
- (NSMutableArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    for (id obj in result) {
   //    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((PHAsset *)obj).mediaType == PHAssetMediaTypeImage) {
            [arr addObject:obj];
        }
//    }];
    }
    return arr;
}

#pragma mark - 获取asset对应的图片
- (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    option.resizeMode = resizeMode;//控制照片尺寸
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;//控制照片质量
    option.synchronous = YES;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        completion(image);
    }];
}

//  创建新的相册
- (PHAssetCollection *)createAssetCollection:(NSString *)alumTitle viewController:(UIViewController *)vc{
    NSMutableArray *albums = [self getAlbums];
    for (PhotoGroupModel *model in albums) {
        if ([model.assetCollection.localizedTitle isEqualToString:alumTitle]) {
            //说明已经有对象了
            return model.assetCollection;
        }
    }
    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:alumTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        [self showHint:[NSString stringWithFormat:@"创建相册【%@】失败", alumTitle] viewController:vc];
        return nil;
    }
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
    
}
#pragma mark - 保存图片到系统相册
- (PHObjectPlaceholder *)saveImageToPhotosAlum:(UIImage *)img viewcontroller:(UIViewController *)vc isShow:(BOOL)show{
    
    NSError *error = nil;
    
    // 保存相片到相机胶卷
    __block PHObjectPlaceholder *createdAsset = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:img].placeholderForCreatedAsset;
    } error:&error];

        if (show) {
            if(!error) {
                
                [self showHint:@"成功保存到相册" viewController:vc];
                
            }else{
                
                [self showHint:error.localizedDescription viewController:vc];
                
            }
            
        }

    return createdAsset;
    
    
}
#pragma mark - 保存图片到自定义相册
- (void)saveImageToCustomPhotosAlum:(UIImage *)img alumTitle:(NSString *)alumTitle viewcontroller:(UIViewController *)vc{
    
    __block PHAssetCollection *createdAssetCollection = nil;
    __block PHObjectPlaceholder *createdAsset = nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
        createdAssetCollection = [self createAssetCollection:alumTitle viewController:vc];
        if (createdAssetCollection == nil) {
            NSLog(@"(创建相簿失败!)");
            return;
        }
        
        createdAsset = [self saveImageToPhotosAlum:img viewcontroller:vc isShow:NO];
        NSError *error = nil;
        // 3.将刚刚添加到"相机胶卷"中的图片到"自己创建相簿"中
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        } error:&error];
            if(error){
                [self showHint:[NSString stringWithFormat:@"保存图片到相册【%@】成功", alumTitle] viewController:vc];
            }else{
                [self showHint:error.localizedDescription viewController:vc];
            }
    
//    });
    
}

- (void)requestAuthorizatio:(UIViewController *)vc comeplete:(void (^)(BOOL))comeplete{    // 判断授权状态
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (comeplete) {
            comeplete(status == PHAuthorizationStatusAuthorized);
        }
    
        //            NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        //            NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        //
        //            dispatch_sync(dispatch_get_main_queue(), ^{
        //                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.navigationController.view animated:YES];
        //                hud.label.text = @"温馨提示";
        //                hud.detailsLabel.text = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        //                hud.mode = MBProgressHUDModeText;
        //                [hud hideAnimated:YES afterDelay:2.0f];
        //
        //            });
        
    }];

    
}

- (void)showHint:(NSString *)hint viewController:(UIViewController *)vc{
    
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:hint preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        
        [alertControl addAction:action];
        
        [vc presentViewController:alertControl animated:YES completion:nil];
   

    
}
@end
