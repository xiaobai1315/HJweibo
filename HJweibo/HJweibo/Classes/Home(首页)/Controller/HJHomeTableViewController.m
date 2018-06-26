//
//  HJHomeTableViewController.m
//  HJweibo
//
//  Created by Jermy on 2017/6/9.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJHomeTableViewController.h"
#import "HJCameraViewController.h"
#import "HJWeiboTableViewCell.h"
#import "HJWeiboLayout.h"
#import "HJNetRequest.h"

@interface HJHomeTableViewController ()

//相机相关
@property(nonatomic, strong) AVCaptureStillImageOutput *output;
@property(nonatomic, strong) AVCaptureSession *session;

//@property(nonatomic, strong) NSMutableArray *weiboArr;   //存放微博信息的数组
@property (nonatomic, strong) NSMutableArray *layouts;
@end

@implementation HJHomeTableViewController

#pragma mark 懒加载

-(NSMutableArray *)layouts
{
    if(_layouts == nil){
        _layouts = [NSMutableArray array];
    }
    return _layouts;
}

#pragma mark 初始化

- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(iPhoneXTopPadding, 0, 0, 0);
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    
//    self.tableView.mj_header = [[MJRefreshNormalHeader alloc] init];
//    __weak id weakSelf = self;
//    self.tableView.mj_header.refreshingBlock = ^{
//        [weakSelf requestDataFromServer];
//    };
    
    //去掉cell与cell之间的分隔样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加导航栏按钮
    [self setupBarButtons];
    
    [self requestDataFromServer];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self.tableView.mj_header beginRefreshing];
}

//添加导航栏按钮
-(void)setupBarButtons
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:@"camera_overturn" selectedImage:@"camera_overturn_highlighted" target:self action:@selector(cameraBtnClick)];
}

#pragma mark 按钮点击事件
//打开相机
-(void)cameraBtnClick
{
    HJCameraViewController *cameraVC= [[HJCameraViewController alloc] init];
    cameraVC.modalPresentationStyle = UIModalPresentationCustom;
    [cameraVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cameraVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HJWeiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeViewWeiboCellID];
    
    if(cell == nil){
        cell = [[HJWeiboTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeViewWeiboCellID];
    }
    
    cell.layout = self.layouts[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HJWeiboLayout *layout = self.layouts[indexPath.row];
    return layout.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark 服务器数据请求

//请求服务器数据
-(void)requestDataFromServer
{
    NSDictionary *para = @{
                           @"access_token" :[[HJTools shareManager] getAccessToken]
                           };
    [[HJNetRequest shareInstance] get:friendTimeline parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSLog(@"%@", responseObject);
        
        //将微博信息数组转成模型数组
        NSArray *dataArr = responseObject[@"statuses"];
        for(id data in dataArr){
            HJWeiboLayout *layout = [[HJWeiboLayout alloc] initWithStatus:[HJStatus modelWithJSON:data]];
            [self.layouts addObject:layout];
        }
        //刷新tableView
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:error.description maskType:SVProgressHUDMaskTypeClear];
        [self.tableView.mj_header endRefreshing];
    }];
}

@end
