//
//  RingManager.m
//  RingUIApp
//
//  Created by Tommy on 2018/10/24.
//  Copyright © 2018 Tommy. All rights reserved.
//

#import "RingManager.h"

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

#define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define DocumentPath(res) [DocumentDir stringByAppendingPathComponent:res]


extern int ffmpeg_main(int argc, char * argv[]);

@implementation RingManager


+ (RingManager *)share{
    static RingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RingManager alloc]init];
    });
    
    return manager;
}

//model值得存贮和获取
-(void)setDefaultModeArray:(NSArray *)arr defaultKey:(NSString *)key1 arcKey:(NSString *)key2{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key1];
    NSMutableData *data = [NSMutableData data];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [archiver encodeObject:arr forKey:key2];
    
    [archiver finishEncoding];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key1];
    
}


-(NSArray *)getDefaultArrByDefaultKey:(NSString *)key1 arcKey:(NSString *)key2{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:key1];
    if (data != nil  && data.length > 0) {
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        
        NSArray  *arr = [unarchiver decodeObjectForKey:key2];
        
        [unarchiver finishDecoding];
        
        return arr;
    }
    return 0;
}




#pragma mark 获取当前的时间
-(NSString *)getNowTime{
    
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyyMMddHHmmss"];
    return [format1 stringFromDate:date];
    
}



#pragma mark 获取文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        
        return  [[fileManager  attributesOfItemAtPath:filePath error:nil] fileSize]/1024;
    }
    
    return 0;
}

#pragma mark 背景音乐提取
-(NSString *)getAudioFromVideo:(NSString *)videoURL{
    
    NSString *ppp = CACHES;
    
    NSString *savePath = [ppp stringByAppendingString:FOLDER];
    
    //创建文件管理者
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:savePath]){
        
        //如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        
        [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    NSString *nameStr = [NSString stringWithFormat:@"%@",[self getNowTime]];
    
    NSString *str2 = [NSString stringWithFormat:@"/%@.m4a",nameStr];
    
    [self fileSizeAtPath:videoURL];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        char *movie = (char *)[videoURL UTF8String];
        char *outmp3 = (char *)[[savePath stringByAppendingString:str2] UTF8String];
        char* a[] = {
            "ffmpeg",
            "-i",
            movie,
            "-vn",
            "-y",
            "-acodec",
            "copy",
            outmp3
        };
        
        ffmpeg_main(sizeof(a)/sizeof(*a), a);
        
    });
    
    
    return [savePath stringByAppendingString:str2];
}


#pragma mark  获取播放的时间
-(NSString *)getVideoInfowithPath:(NSURL*)path{
    
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:path options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    
    NSInteger time = (int)audioDurationSeconds / 60;
    
    NSInteger  second = audioDurationSeconds - time * 60;
    
    return  [NSString stringWithFormat:@"%02ld:%02ld",(long)time,(long)second];
    
}


#pragma mark  获取播放的时间
-(NSString *)getVideoInfowithName:(NSString*)name{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSURL *url = [[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    
    NSURL *path = [url URLByAppendingPathComponent:name];
  
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:path options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    
    NSInteger time = (int)audioDurationSeconds / 60;
    
    NSInteger  second = audioDurationSeconds - time * 60;
    
    return  [NSString stringWithFormat:@"%02ld:%02ld",(long)time,(long)second];
    
}


#pragma mark 获取文件夹下所有文件名
-(NSArray *)getAllFileNameWithDocmentPath:(NSArray *)documentPaths{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    NSError *error = nil;
    
    NSArray *fileList = [[NSArray alloc]init];
    
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    return fileList;
    
}

@end
