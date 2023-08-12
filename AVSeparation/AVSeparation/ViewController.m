//
//  ViewController.m
//  AVSeparation
//
//  Created by apple on 2019/12/12.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ViewController.h"
#import "LX_AVSeparation.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LX_AVSeparation VideoManagerGetBackgroundMiusicWithVideoUrl:[NSURL URLWithString:@"视频路径"] newFile:@"音频导出路径" completion:^(BOOL success) {
        
    }];
}


@end
