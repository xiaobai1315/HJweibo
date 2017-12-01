//
//  HJWebPage.m
//  HJweibo
//
//  Created by Jermy on 2017/7/21.
//  Copyright © 2017年 Jermy. All rights reserved.
//

#import "HJWebPage.h"

@interface HJWebPage()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation HJWebPage

//重写set方法
-(void)setInfoModel:(HJURLInfoModel *)infoModel
{
    _infoModel = infoModel;
    
//    //取出图片尺寸、URL地址
//    HJURLInfoImageModel *imageModel = infoModel.image;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
//    
//    //设置文字
//    self.titleLabel.text = infoModel.display_name;
//    self.detailLabel.text = infoModel.ext_summary;
}

@end
