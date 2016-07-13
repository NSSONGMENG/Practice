//
//  ViewController.m
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/9.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "ViewController.h"
#import "TZImagePickerController.h"
#import "ImageCollectionViewCell.h"

#define ITEM_WIDTH [UIScreen mainScreen].bounds.size.width/4-3
#define CELL_ITENT  @"image_collection_cell"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate>
@property (nonatomic, strong) UICollectionView  * collectionView;
@property (nonatomic, strong) NSMutableArray    * imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout  * layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_WIDTH);
    layout.minimumLineSpacing = 1.;
    layout.minimumInteritemSpacing = 1.;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:CELL_ITENT];
}

#pragma  mark  -
#pragma  mark  --------- collection ---------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.imageArray count]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ITENT forIndexPath:indexPath];
    if (indexPath.row < [self.imageArray count]) {
        cell.image = [self.imageArray objectAtIndex:indexPath.row];
        cell.titleString = nil;
    }else{
        cell.titleString = @"添加图片";
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ITEM_WIDTH, ITEM_WIDTH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell * cell = (ImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.titleString isEqualToString:@"添加图片"]) {
        //选择图片
        TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        picker.allowTakePicture = YES;
        __weak typeof(self) weakself = self;
        picker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
            NSLog(@" -- ");
            [weakself.imageArray addObjectsFromArray:photos];
            [weakself.collectionView reloadData];
        };
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        //浏览图片
        
    }
}





#pragma  mark  -
#pragma  mark  --------- lazy loading ---------
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [@[] mutableCopy];
    }
    return _imageArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
