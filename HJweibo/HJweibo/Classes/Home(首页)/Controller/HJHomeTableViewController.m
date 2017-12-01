//
//  HJHomeTableViewController.m
//  HJweibo
//
//  Created by Jermy on 2017/6/9.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJHomeTableViewController.h"
#import "HJCameraViewController.h"
#import "HJViewControllerTransition.h"
#import "HJWeiboTableViewCell.h"

@interface HJHomeTableViewController ()

//相机相关
@property(nonatomic, strong)AVCaptureStillImageOutput *output;
@property(nonatomic, strong)AVCaptureSession *session;

@property(nonatomic, strong)NSMutableArray *weiboArr;   //存放微博信息的数组

@end

@implementation HJHomeTableViewController

#pragma mark 懒加载
-(NSMutableArray *)weiboArr
{
    if(_weiboArr == nil){
        _weiboArr = [NSMutableArray array];
    }
    
    return _weiboArr;
}

#pragma mark 初始化

- (void)viewDidLoad {
    [super viewDidLoad];

    if (iPhoneX) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.tableView.contentInset = UIEdgeInsetsMake(iPhoneXTopPadding, 0, 0, 0);
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    
    self.tableView.mj_header = [[MJRefreshNormalHeader alloc] init];
    __weak id weakSelf = self;
    self.tableView.mj_header.refreshingBlock = ^{
        [weakSelf requestDataFromServer];
    };
    
    //去掉cell与cell之间的分隔样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加导航栏按钮
    [self setupBarButtons];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HJWeiboTableViewCell class]) bundle:nil] forCellReuseIdentifier:homeViewWeiboCellID];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView.mj_header beginRefreshing];
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

#pragma mark 转场动画

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if(operation == UINavigationControllerOperationPop){
        
        return [HJViewControllerTransition ViewControllerTransitionWithType:HJViewControllerTransitionTypeDismiss];
    }else{
        
        return [HJViewControllerTransition ViewControllerTransitionWithType:HJViewControllerTransitionTypePresent];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.weiboArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HJWeiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeViewWeiboCellID];
    
    cell.status = self.weiboArr[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HJStatus *status = self.weiboArr[indexPath.row];
        
    return status.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HJWeiboTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectedBackgroundView.frame = cell.bounds;
}

#pragma mark 服务器数据请求

//请求服务器数据
-(void)requestDataFromServer
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    HJAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountCachePath];
    
    NSDictionary *para = @{
                           @"access_token" : account.access_token
                           };
    
    [manager GET:homeTimeline parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSLog(@"%@", responseObject);
        
        //将微博信息数组转成模型数组
        NSArray *status = responseObject[@"statuses"];
//        self.weiboArr = [HJStatus mj_objectArrayWithKeyValuesArray:status];
        
        NSArray *statusArr = [HJStatus mj_objectArrayWithKeyValuesArray:status];
        if(statusArr.count == 0){
            [self.tableView.mj_header endRefreshing];
            return;
        }

        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, statusArr.count)];
        [self.weiboArr insertObjects:statusArr atIndexes:indexSet];

        for (HJStatus *status in self.weiboArr) {
            //提前计算cell高度和View的frame
            status.cellHeight;
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
