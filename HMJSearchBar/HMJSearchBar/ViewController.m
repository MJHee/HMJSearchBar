//
//  ViewController.m
//  HMJSearchBar
//
//  Created by MJHee on 16/8/31.
//  Copyright © 2016年 MJHee. All rights reserved.
//

#import "ViewController.h"
#import "HMJSearchViewController.h"

@interface ViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *pushBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.titleView = self.titleView;

    [self.view addSubview:self.pushBtn];
}

#pragma mark - pushToController

- (void)pushToController:(UIButton *)sender {
    [self pushToSearchViewController];
}

#pragma mark - 懒加载

- (UIButton *)pushBtn {
    if (_pushBtn == nil) {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pushBtn.backgroundColor = [UIColor redColor];
        _pushBtn.frame = CGRectMake(kScreenW - 100, 20, 80, 30);
        [_pushBtn setTitle:@"跳转" forState:UIControlStateNormal];
        [_pushBtn addTarget:self action:@selector(pushToController:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushBtn;
}

- (UIView *)titleView {

    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 28)];
        UIColor *color = self.navigationController.navigationBar.backgroundColor;
        _titleView.backgroundColor = color;
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.frame = CGRectMake(0, 0, 300, 28);
        searchBar.backgroundColor = color;
        searchBar.delegate = self;
        searchBar.layer.cornerRadius  = 14;
        searchBar.layer.masksToBounds = YES;
        searchBar.keyboardType = UIKeyboardTypeDefault;
        searchBar.placeholder  = @"输入中文、英文名或分子式";
        [_titleView addSubview:searchBar];
    }
    return _titleView;
}

@end
