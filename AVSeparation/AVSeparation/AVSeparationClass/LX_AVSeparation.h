//
//  LX_AVSeparation.h
//  AVSeparation
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h> //音视频库
#import <AudioToolbox/AudioToolbox.h> //音视频处理

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnTextBlock)(NSString *showText);

typedef void (^ReturnVideoPath)(NSString *newPath);

@interface LX_AVSeparation : UIView

/**
*  获取视频的缩略图方法
*
*  @param filePath 视频的本地路径
*
*  @return 视频截图
*/
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath;

/**
*  获取视频中的音频
*
*  @param videoUrl 视频的本地路径
*  @param newFile 导出音频的路径
*  @completionHandle 完成回调
*/
+ (void)VideoManagerGetBackgroundMiusicWithVideoUrl:(NSURL *)videoUrl newFile:(NSString*)newFile completion:(void(^)(BOOL success))completionHandle;

/*
 *  获取视频播放时长
 *  @param urlString 视频路径
 */
+ (NSInteger)getVideoTimeByUrlString:(NSString*)urlString;

@end

NS_ASSUME_NONNULL_END
