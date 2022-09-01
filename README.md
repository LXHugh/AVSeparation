# 
获取视频中的音频（音视频分离）

/**
*  获取视频的缩略图
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
*  @completionHandle 音频路径的回调
*/

+ (void)VideoManagerGetBackgroundMiusicWithVideoUrl:(NSURL *)videoUrl newFile:(NSString*)newFile completion:(void(^)(NSString *data))completionHandle;


/*
 *  获取视频播放时长
 *  @param urlString 视频路径
 */
 
+ (NSInteger)getVideoTimeByUrlString:(NSString*)urlString;
