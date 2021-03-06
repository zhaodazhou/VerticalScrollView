//
//  ToutiaoView.m
//  mangoClient
//
//  Created by dazhou on 16/4/20.
//  Copyright © 2016年 dazhou. All rights reserved.
//

#import "ToutiaoView.h"

@implementation ItemObject

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"";
        self.detail = @"";
        self.title1 = @"";
        self.detail1 = @"";
    }
    
    return self;
}

@end



@implementation HintView

- (void)setItem:(ItemObject *)item
{
    _item = item;
}

- (void)drawRect:(CGRect)rect
{
    int leftMargin = 5;
    int topMargin = 3;
    int labelWidth = 40;
    int labelHeight = 18;
    
    
    UILabel * _hintLabel1;
    UILabel * _hintLabel2;
    UILabel * _hintDescLabel1;
    UILabel * _hintDescLabel2;
    
    _hintLabel1 = [[UILabel alloc] init];
    _hintLabel1.textAlignment = NSTextAlignmentCenter;
    _hintLabel1.layer.cornerRadius = 4;
    _hintLabel1.layer.masksToBounds = YES;
    _hintLabel1.layer.borderColor = [UIColor redColor].CGColor;
    _hintLabel1.layer.borderWidth = 1;
    _hintLabel1.font = [UIFont systemFontOfSize:14];
    [self addSubview:_hintLabel1];
    
    _hintDescLabel1 = [[UILabel alloc] init];
    _hintDescLabel1.font = [UIFont systemFontOfSize:14];
    [self addSubview:_hintDescLabel1];
    
    
    _hintLabel2 = [[UILabel alloc] init];
    _hintLabel2.textAlignment = NSTextAlignmentCenter;
    _hintLabel2.layer.cornerRadius = 4;
    _hintLabel2.layer.masksToBounds = YES;
    _hintLabel2.layer.borderColor = [UIColor redColor].CGColor;
    _hintLabel2.layer.borderWidth = 1;
    _hintLabel2.font = [UIFont systemFontOfSize:14];
    [self addSubview:_hintLabel2];
    
    _hintDescLabel2 = [[UILabel alloc] init];
    _hintDescLabel2.font = [UIFont systemFontOfSize:14];
    [self addSubview:_hintDescLabel2];
    
    
    _hintLabel1.frame = CGRectMake(leftMargin, topMargin, labelWidth, labelHeight);
    _hintDescLabel1.frame = CGRectMake(leftMargin + labelWidth + 10,
                                       topMargin,
                                       CGRectGetWidth(rect) - (leftMargin + labelWidth + 10),
                                       labelHeight);
    
    _hintLabel2.frame = CGRectMake(leftMargin, CGRectGetHeight(rect) / 2 + topMargin, labelWidth, labelHeight);
    _hintDescLabel2.frame = CGRectMake(leftMargin + labelWidth + 10,
                                       CGRectGetHeight(rect) / 2 + topMargin,
                                       CGRectGetWidth(rect) - (leftMargin + labelWidth + 10),
                                       labelHeight);
    
    _hintLabel1.text = self.item.title;
    _hintDescLabel1.text = self.item.detail;
    _hintLabel2.text = self.item.title1;
    _hintDescLabel2.text = self.item.detail1;
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];
}


@end



@interface ToutiaoView()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@property (nonatomic, strong) NSTimer *timer;

@end



static int hintViewHeight = 46;

@implementation ToutiaoView


- (void)awakeFromNib
{
    _mScrollView.showsVerticalScrollIndicator = NO;
    _mScrollView.pagingEnabled = YES;
    _mScrollView.delegate = self;
    _mScrollView.scrollEnabled = NO;
    
    _autoscroll = YES;
    _timeInterval = 2;
}

/** items setter */
- (void)setItems:(NSArray *)items
{
    if (items.count == 0) return;
    
    NSMutableArray *mutableItems = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < 3; i++) {
        [mutableItems addObjectsFromArray:items];
    }
    
    _items = mutableItems.copy;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initSelf];
    });
}

- (void)initSelf
{
    int count = (int)[self.items count];
    
    self.mScrollView.contentSize = CGSizeMake(0, hintViewHeight * count);
    
    
    for (int index = 0; index < count; index ++) {
        CGRect frame = CGRectMake(0,
                                  hintViewHeight * index,
                                  [UIScreen mainScreen].bounds.size.width - 72,
                                  hintViewHeight);
        HintView * hintView = [[HintView alloc] init];
        hintView.frame = frame;
        
        hintView.item = [self.items objectAtIndex:(index % (count / 3))];
        
        [self.mScrollView addSubview:hintView];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:frame];
        [btn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = index % (count / 3);
        [self.mScrollView addSubview:btn];
    }
    
    
    [self setUpTimer];
}

- (void)onBtnPressed:(UIButton *)sender
{
    if (self.didSelectItemAtIndex) {
        self.didSelectItemAtIndex(sender.tag);
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageHeight = hintViewHeight;
    CGFloat periodOffset = pageHeight * (self.items.count / 3);
    CGFloat offsetActivatingMoveToBeginning = pageHeight * ((self.items.count / 3) * 2);
    CGFloat offsetActivatingMoveToEnd = pageHeight * ((self.items.count / 3) * 1);
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > offsetActivatingMoveToBeginning) {
        scrollView.contentOffset = CGPointMake(0, (offsetY - periodOffset));
    } else if (offsetY < offsetActivatingMoveToEnd) {
        scrollView.contentOffset = CGPointMake(0, (offsetY + periodOffset));
    }
}

#pragma mark - Timer

- (void)setUpTimer {
    [self tearDownTimer];
    
    if (!self.autoscroll) return;
    
    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval
                                         target:self
                                       selector:@selector(timerFire:)
                                       userInfo:nil
                                        repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)tearDownTimer {
    [self.timer invalidate];
}

- (void)timerFire:(NSTimer *)timer {
    CGFloat currentOffset = self.mScrollView.contentOffset.y;
    CGFloat targetOffset  = currentOffset + hintViewHeight;

    [self.mScrollView setContentOffset:CGPointMake(self.mScrollView.contentOffset.x, targetOffset) animated:YES];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    [self setUpTimer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
