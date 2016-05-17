//
//  ViewController.m
//  小文件下载
//
//  Created by 李胜营 on 16/5/17.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

/* filedata */
@property (strong, nonatomic) NSMutableData* fileData;
/* length */
@property (assign, nonatomic) NSInteger contentLength;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  创建请求路径
     *  发送请求
     *  实现代理方法进行获取数据
     */
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_15.mp4"];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    self.contentLength = [response.allHeaderFields[@"Content-Length"] integerValue];
    
    self.fileData = [NSMutableData data];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //接受数据
    [self.fileData appendData:data];
    //计算进度
    CGFloat progress = 1.0 * self.fileData.length / self.contentLength;
    
    self.progressView.progress = progress;
}
//finished 后存储数据到沙盒
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //获取沙盒路径 expandTilde 是否利用～代替/User/userName,no表示代替
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
   //文件保存到cache下的那个文件中。获取全路径
    NSString *file = [cache stringByAppendingString:@"minion_15.mp4"];
    NSLog(@"%@",file);
    //将数据写入到文件路径中
    
    [self.fileData writeToFile:file atomically:YES];
    
    self.fileData = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
