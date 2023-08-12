```
//获取视频的缩略图
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath;

//获取视频中的音频
+ (void)VideoManagerGetBackgroundMiusicWithVideoUrl:(NSURL *)videoUrl newFile:(NSString*)newFile completion:(void(^)(NSString *data))completionHandle;

//获取视频播放时长
+ (NSInteger)getVideoTimeByUrlString:(NSString*)urlString;
```
