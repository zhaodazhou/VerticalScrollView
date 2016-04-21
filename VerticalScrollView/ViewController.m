//
//  ViewController.m
//  VerticalScrollView
//
//  Created by dazhou on 16/4/21.
//  Copyright © 2016年 dazhou. All rights reserved.
//

#import "ViewController.h"
#import "ToutiaoView.h"

@interface ViewController ()

@property (nonatomic, weak) ToutiaoView * toutiaoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    ToutiaoView * toutiao = [[[NSBundle mainBundle] loadNibNamed:@"ToutiaoView" owner:nil options:nil] firstObject];
    toutiao.frame = CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 62);
    [self.view addSubview:toutiao];
    self.toutiaoView = toutiao;
    
    [self testToutiaoView];
}

- (void)testToutiaoView
{
    ItemObject * item1 = [ItemObject new];
    item1.title = @"公告";
    item1.detail = @"和谐社会，你懂的";
    item1.title1 = @"头条";
    item1.detail1 = @"友谊的小船，不能随便翻";
    
    ItemObject * item2 = [ItemObject new];
    item2.title = @"头条";
    item2.detail = @"时光已过永不回";
    item2.title1 = @"公告";
    item2.detail1 = @"往事只能回味";
    
    self.toutiaoView.items = @[item1, item2];
    self.toutiaoView.didSelectItemAtIndex = ^(NSUInteger index) {
        NSLog(@"tap index: %ld", index);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
