//
//  ViewController.m
//  SegmentControl
//
//  Created by songmeng on 15/7/7.
//  Copyright (c) 2015年 songmeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * tableViewA;
@property (nonatomic,strong)UITableView * tableViewB;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSegmentControl];
    [self layoutTableView];
}

- (void)layoutSegmentControl{
    UISegmentedControl * segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Table A",@"Table B" ]];
    segmentControl.center = CGPointMake(self.view.frame.size.width/2, 50);
    segmentControl.backgroundColor = [UIColor lightGrayColor];
    segmentControl.selectedSegmentIndex = 0;        //默认显示tableViewA
    
    [segmentControl addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
}

- (void)layoutTableView{
    self.tableViewA.delegate = self;
    self.tableViewA.dataSource = self;
    self.tableViewB.delegate = self;
    self.tableViewB.dataSource = self;
    
    [self.view addSubview:self.tableViewB];
    [self.view addSubview:self.tableViewA];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.tableViewA]) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableViewA]) {
        return 10;
    }else{
        if (0 == section) {
            return 5;
        }else{
            return 5;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableViewA]) {
        return 20;
    }else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * tableViewA_cell = @"tableViewACell";
    static NSString * tableViewB_cell = @"tableViewBCell";
    if ([tableView isEqual:self.tableViewA]) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewA_cell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewA_cell];
            cell.textLabel.text = @"table view A";
        }
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewB_cell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewB_cell];
            cell.textLabel.text = @"table view B";
        }
        return cell;
    }
}


- (void)changeView:(UISegmentedControl *)segmentControl{
    if (segmentControl.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.tableViewA];
    }else{
        [self.view bringSubviewToFront:self.tableViewB];
    }
}

#pragma  mark  -------------------懒加载--------------------

- (UITableView *)tableViewA{
    if (!_tableViewA) {
        _tableViewA = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80) style:UITableViewStyleGrouped];
    }
    return _tableViewA;
}

- (UITableView *)tableViewB{
    if (! _tableViewB) {
        _tableViewB = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80) style:UITableViewStyleGrouped];
    }
    return _tableViewB;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
