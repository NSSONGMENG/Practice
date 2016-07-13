//
//  ViewController.m
//  Pop
//
//  Created by songmeng on 16/6/10.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray   * imgArr;
@property (nonatomic, strong) UITableView   * tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    _imgArr = @[[UIImage imageNamed:@"earth.jpg"],
                [UIImage imageNamed:@"water.jpg"],
                [UIImage imageNamed:@"moutain.jpg"],
                [UIImage imageNamed:@"jobs.jpg"]];
    
    _tableView = [UITableView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
    }];
}
#pragma  mark  -
#pragma  mark  --------- table view ---------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_imgArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cell_ident = @"cell_ident";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_ident];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_ident];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"row : %ld",indexPath.row];
    
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    NSString * message = [NSString stringWithFormat:@" row : %ld", indexPath.row];
//    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
//    overlay.backgroundView.backgroundColor = [UIColor clearColor];
//    overlay.animation = MTStatusBarOverlayAnimationShrink;
//    overlay.detailViewMode = MTDetailViewModeHistory;
//    [overlay postImmediateFinishMessage:message duration:2.0 animated:YES];
//    overlay.progress = 0.5;
    UserModel *user = [UserModel new];
    NSLog(@"%@",user);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
