//
//  LX_AVSeparation.m
//  AVSeparation
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 apple. All rights reserved.
//

#import "LX_AVSeparation.h"

@implementation LX_AVSeparation

/**
 *  获取视频的缩略图方法
 *
 *  @param filePath 视频的本地路径
 *
 *  @return 视频截图
 */
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return shotImage;
    
}

/**
*  获取视频中的音频
*
*  @param videoUrl 视频的本地路径
*  @param newFile 导出音频的路径
*  @completionHandle 完成回调
*/
+ (void)VideoManagerGetBackgroundMiusicWithVideoUrl:(NSURL *)videoUrl newFile:(NSString*)newFile completion:(void(^)(BOOL success))completionHandle{
    
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];;
    NSArray *keys = @[@"duration",@"tracks"];
    [videoAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus status = [videoAsset statusOfValueForKey:@"tracks" error:&error];
        if(status ==AVKeyValueStatusLoaded) {//数据加载完成
            AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
            // 2 - Video track
            //Audio Recorder
            //创建一个轨道,类型是AVMediaTypeAudio
            AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            //获取videoAsset中的音频,插入轨道
            [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            NSURL *url = [NSURL fileURLWithPath:newFile];
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];//输出为M4A音频
            exporter.outputURL = url;
            exporter.outputFileType = @"com.apple.m4a-audio";//类型和输出类型一致
            exporter.shouldOptimizeForNetworkUse = YES;
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (exporter.status == AVAssetExportSessionStatusCompleted) {
                        completionHandle(YES);
                    }else{
                        NSLog(@"提取失败原因：%@",exporter.error);
                        completionHandle(NO);
                    }
                });
            }];
        }
    }];

}


/*
 *  获取视频播放时长
 *  @param urlString 视频路径
 */
+ (NSInteger)getVideoTimeByUrlString:(NSString*)urlString {

    NSURL*videoUrl = [NSURL URLWithString:urlString];

    AVURLAsset *avUrl = [AVURLAsset assetWithURL:videoUrl];

    CMTime time = [avUrl duration];

    int seconds = ceil(time.value/time.timescale);

    return seconds;
}

@end
