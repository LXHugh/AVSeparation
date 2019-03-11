//
//  ViewController.m
//  提取视频中的音频
//
//  Created by 刘宣 on 2019/1/17.
//  Copyright © 2019 刘宣. All rights reserved.
//

#import "ViewController.h"

#import "ringModel.h"
#import "RingManager.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导入三个库:libiconv.tbd   libbz2.tbd    libz.tbd   不导入则会报错，无法使用fmpeg
    
    //记得添加权限
    
    //事件触发按钮
    UIButton *getImageB = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 300, 100)];
    getImageB.backgroundColor = [UIColor purpleColor];
    [getImageB addTarget:self action:@selector(getMyimg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getImageB];
}

-(void)getMyimg{
    
    //获取相册文件
    if ([UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.allowsEditing = NO;
        pick.videoMaximumDuration = 20.0;
        pick.videoQuality = UIImagePickerControllerQualityTypeMedium;
        
        //媒体类型：@"public.movie" 为视频  @"public.image" 为图片
        pick.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
        pick.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pick.delegate = self;
        [self presentViewController:pick animated:YES completion:nil];
        
    }
    
}

#pragma mark - 获取视频信息后回调，进行分离操作

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    NSLog(@"视频信息:%@",info);
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]) {
        
        NSURL *url = info[UIImagePickerControllerMediaURL];//获得视频的URL
        
        NSString *videoStr = [url  absoluteString];
        
        NSArray *arr = [videoStr componentsSeparatedByString:@"/"];
        
        NSString *name = arr[arr.count - 1];
        
        NSString *tmpDir = NSTemporaryDirectory();
        
        NSString *fileName = [tmpDir stringByAppendingString:name];
        
        [[RingManager share] fileSizeAtPath:fileName];
        
        ringModel *model = [[ringModel alloc]init];
        
        NSString *time = [[RingManager share]  getVideoInfowithPath:info[UIImagePickerControllerMediaURL]];
        
        NSString *path = [[RingManager share] getAudioFromVideo:fileName];
        
        long long size = [[RingManager share] fileSizeAtPath:fileName];
        
        NSDictionary *dic = @{@"ringPath":path,
                              @"ringName":[NSString stringWithFormat:@"铃声-%@",[[RingManager share] getNowTime]],
                              @"ringTime":time,
                              @"ringSize":@(size)
                              };
        
        [model setValuesForKeysWithDictionary:dic];
        
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self getBell];
}

#pragma mark - 背景音乐提取成功

-(void)getBell{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提取成功，是否立即前往设置铃声" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //添加按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    
    
    //展示提示框
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
