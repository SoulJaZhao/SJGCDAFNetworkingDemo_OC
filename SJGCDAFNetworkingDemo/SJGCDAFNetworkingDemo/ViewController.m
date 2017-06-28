//
//  ViewController.m
//  SJGCDAFNetworkingDemo
//
//  Created by SoulJa on 2017/6/28.
//  Copyright © 2017年 sdp. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) dispatch_group_t group;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        _group = dispatch_group_create();
        
        dispatch_group_async(_group, queue, ^{
            [self requestWithFlag:@"0"];
        });
        
        dispatch_group_async(_group, queue, ^{
            [self requestWithFlag:@"1"];
        });
        
        dispatch_group_async(_group, queue, ^{
            [self requestWithFlag:@"2"];
        });
        
        dispatch_group_async(_group, queue, ^{
            [self requestWithFlag:@"3"];
        });
        
        //通知结束
        dispatch_group_notify(_group, queue, ^{
            NSLog(@"Done");
        });
    });
    
}

#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        self.manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 发送请求
- (void)requestWithFlag:(NSString *)flag {
    //进入线程组
    dispatch_group_enter(_group);
    
    NSString *urlString = @"http://localhost/php/index.php";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"flag"] = flag;
    
    //发送请求
    [self.manager GET:urlString parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //离开线程组
        dispatch_group_leave(_group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //离开线程组
        dispatch_group_leave(_group);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
