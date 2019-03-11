//
//  RingManager.h
//  RingUIApp
//
//  Created by Tommy on 2018/10/24.
//  Copyright © 2018 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RingManager : NSObject

+(RingManager *)share;

-(void)setDefaultModeArray:(NSArray *)arr defaultKey:(NSString *)key1 arcKey:(NSString *)key2;


-(NSArray *)getDefaultArrByDefaultKey:(NSString *)key1 arcKey:(NSString *)key2;


-(NSString *)getNowTime;

- (long long)fileSizeAtPath:(NSString*)filePath;

-(NSString *)getAudioFromVideo:(NSString *)videoURL;

-(NSString *)getVideoInfowithPath:(NSURL*)path;


-(NSArray *)getAllFileNameWithDocmentPath:(NSArray *)documentPaths;

-(NSString *)getVideoInfowithName:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
