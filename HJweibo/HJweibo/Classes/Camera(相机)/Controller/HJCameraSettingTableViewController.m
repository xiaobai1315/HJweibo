//
//  HJCameraSettingController.m
//  HJweibo
//
//  Created by Jermy on 2017/6/21.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJCameraSettingTableViewController.h"

@interface HJCameraSettingTableViewController ()

@property(nonatomic, copy)NSArray *sectionTitles;       //分组的标题
@property(nonatomic, copy)NSArray *sectionOne;          //第一分组的内容
@property(nonatomic, copy)NSMutableArray *sectionTwo;   //第二分组的内容
@property(nonatomic, copy)NSArray *sectionThree;        //第三分组的内容
@property(nonatomic, copy)NSArray *sectionFooter;       //分组的尾标题

@property(nonatomic, assign)BOOL isHiden;               //是否隐藏section1

@property(nonatomic, copy)NSMutableArray *selectedIndexPath;    //选中cell对应的indexPath
@property(nonatomic, assign)NSInteger selectedSection;    //选中cell对应的Section

@end

@implementation HJCameraSettingTableViewController

#pragma mark 懒加载
-(NSArray *)sectionTitles
{
    if(_sectionTitles == nil){
        
        _sectionTitles = @[@"允许评论/私信", @"哪些人可以评论我的故事", @""];
    }
    
    return _sectionTitles;
}

-(NSArray *)sectionOne
{
    if(_sectionOne == nil){
        
        _sectionOne = @[@"评论", @"私信", @"关闭"];
    }
    
    return _sectionOne;
}

-(NSMutableArray *)sectionTwo
{
    if(_sectionTwo == nil){
        
        _sectionTwo = [NSMutableArray arrayWithObjects:@"我的粉丝", @"我关注的人", nil];
        
    }
    
    return _sectionTwo;
}

-(NSArray *)sectionThree
{
    if(_sectionThree == nil){
        
        _sectionThree = @[@"保存分享的内容"];
    }
    
    return _sectionThree;
}

-(NSArray *)sectionFooter
{
    if(_sectionFooter == nil){
        
        _sectionFooter = @[@"", @"", @"在故事中加入照片和视频时，自动保存这些照片和视频。"];
    }
    
    return _sectionFooter;
}

-(NSMutableArray *)selectedIndexPath
{
    if(_selectedIndexPath == nil){
        
        _selectedIndexPath = [NSMutableArray array];
    }
    
    return _selectedIndexPath;
}

#pragma mark 初始化
-(void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNavigation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置tableview距离顶部的距离
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(170, 0, 0, 0);
}

//设置导航栏
-(void)setupNavigation
{
    self.navigationItem.title = NSLocalizedString(@"故事设置", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) selectedColor:[UIColor orangeColor] target:self action:@selector(dismissVC)];
}

#pragma mark 按钮点击事件
//控制器消失
-(void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //隐藏后section数量 - 1
    if(_isHiden) return self.sectionTitles.count - 1;
    
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return self.sectionOne.count;
            break;
            
        case 1:
            //隐藏后，显示section 3的数量
            if(_isHiden) return self.sectionThree.count;
            
            return self.sectionTwo.count;
            break;
            
        case 2:
            return self.sectionThree.count;
            break;
            
        default:
            return 0;
            break;
    }
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cameraSettingcell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    if(indexPath.section == 0){
        
        cell.textLabel.text = self.sectionOne[indexPath.row];
    }else if (indexPath.section == 1){

        if(_isHiden)
        {
            cell.textLabel.text = self.sectionThree[indexPath.row];
        }else
        {
            cell.textLabel.text = self.sectionTwo[indexPath.row];
        }
        
    }else if (indexPath.section == 2){
        
        cell.textLabel.text = self.sectionThree[indexPath.row];
        cell.accessoryView = [[UISwitch alloc] init];
    }
    
    //设置cell的访问样式，防止cell重用出现问题
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_isHiden) {
        return;
    }
    
    //选择了关闭功能,隐藏section 1
    if(indexPath.section == 0 && indexPath.row == 2){
        
        _isHiden = YES;
    
        NSIndexPath *tempIndex = [NSIndexPath indexPathForRow:0 inSection:1];
        
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:tempIndex.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //将要选中的cell对应的section
    _selectedSection = indexPath.section;
    
    for(NSIndexPath *tempIndexPath in self.selectedIndexPath){
        
        //如果当前选中的cell和已选中的cell section相同
        if(tempIndexPath.section == indexPath.section){
            
            //取消tempIndexPath的选中状态
            [tableView cellForRowAtIndexPath:tempIndexPath].accessoryType = UITableViewCellAccessoryNone;
            
            //更新数组
            [self.selectedIndexPath removeObject:tempIndexPath];
            
            break;
        }
    }
    
    //设置cell选中样式
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.selectedIndexPath addObject:indexPath];

    
    return indexPath;
}

//取消选中cell
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选择关闭功能,显示section 1,只有选中第0个section的cell 才能取消选中关闭功能
    if(indexPath.section == 0 && indexPath.row == 2 && _selectedSection == 0){
        
        _isHiden = NO;
        
        NSIndexPath *tempIndex = [NSIndexPath indexPathForRow:0 inSection:1];
        
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:tempIndex.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//设置tableview headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1 && _isHiden){
        return nil;
    }
    
    if(section == 2){
        
        return nil;
    }
    
    return [self headerAndFooterViewInSection:section header:YES];
}

//设置tableview footerView
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1 && _isHiden){
        
        return [self headerAndFooterViewInSection:section header:NO];
    }
    
    if(section == 2){
        
        return [self headerAndFooterViewInSection:section header:NO];
    }
    
    return nil;
}

//section头和尾的自定义View
-(UIView *)headerAndFooterViewInSection:(NSInteger)section header:(BOOL)isHeader
{
    //背景颜色
    UIColor *commonColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1];
    //文字颜色
    UIColor *textColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1];
    
    NSInteger tableViewW = self.tableView.frame.size.width;
    NSInteger viewH = 20;
    
    //背景View
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, tableViewW, viewH);
    backView.backgroundColor = commonColor;
    
    //标题View
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 0, tableViewW, viewH);
    label.font = [UIFont systemFontOfSize:13];
    label.text = self.sectionTitles[section];
    label.textColor = textColor;
    label.backgroundColor = commonColor;
    
    if(!isHeader){
        label.text = self.sectionFooter[section];
    }
    
    [backView addSubview:label];
    
    return backView;
}

//section header 的行高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //删除section1之前，section2没有头标题
    if(section == 2){
        return 0;
    }
    
    //删除section1之后，原先的section2变成section1，没有头标题
    if((section == 1 && _isHiden) || (section == 2)){
        return 0;
    }
    
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //删除section1之前，section2有尾标题
    if(section == 2){
        
        return 20;
    }
    
    //删除section1之后，原先的section2变成section1，有尾标题
    if(section == 1 && _isHiden){
        return 20;
    }
    
    return 0;
}
@end
