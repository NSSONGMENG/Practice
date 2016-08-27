//
//  SomePhotoBrowser.m
//  SomePhotoBrowser
//
//  Created by songmeng on 16/7/12.
//  Copyright © 2016年 songmeng. All rights reserved.
//

#import "SomePhotoBrowser.h"
#import "ImageBrowserCell.h"

#define CELL_IDENT  @"image_browser_cell"

@interface SomePhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)NSArray    * imageArray;
@property (nonatomic, assign)NSInteger  initIndex;
@property (nonatomic, strong)UICollectionView   * collectionView;
@property (nonatomic, strong)UILabel        * titleLabel;
@property (nonatomic, strong)UILabel        * detailLabel;


@end

@implementation SomePhotoBrowser

- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSInteger)index{
    self = [SomePhotoBrowser new];
    _imageArray = photos;
    _initIndex = index;
    return self;
}
- (instancetype)init{
	self = [super init];
	if (self){
		[self createSubview];	
	}
	return self;
}

#pragma mark - create UI
- (void)createSubview{
    UICollectionViewFlowLayout  * layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = SCREEN_SIZE;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    [self addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_collectionView registerClass:[ImageBrowserCell class] forCellWithReuseIdentifier:CELL_IDENT];
}

#pragma mark - collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.imageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageBrowserCell    * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENT forIndexPath:indexPath];
    cell.image = [self.imageArray objectAtIndex:indexPath.row];
    __weak typeof(self) weakself = self;
    cell.callBackTapImageAction = ^(SomeImage * img){
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(somePhotoBrowser:tapImageAction:)]) {
            [weakself.delegate somePhotoBrowser:self tapImageAction:img];
        }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_SIZE;
}

#pragma mark - view event

#pragma mark - private method
- (void)showLabel{
    _labelShow = YES;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(-35);
    }];
    [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(35);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
//    AVPlayer
//    AVPlayerLayer
}

- (void)hideLabel{
    _labelShow = NO;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
    }];
    [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}



#pragma mark - public method 
- (void)showWithIndex:(NSInteger)currentIndex{
    _initIndex = currentIndex;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_initIndex inSection:0]
                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                    animated:NO];
}


#pragma mark - setter
- (void)setImgArray:(NSArray *)imgArray{
    if (imgArray) {
        self.imageArray = imgArray;
    }
}


#pragma mark - getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self addSubview:_titleLabel];
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self addSubview:_detailLabel];
    return _detailLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
