//
//  ToutiaoView.h
//  mangoClient
//
//  Created by dazhou on 16/4/20.
//  Copyright © 2016年 dazhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemObject : NSObject
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * detail;

@property (nonatomic, strong) NSString * title1;
@property (nonatomic, strong) NSString * detail1;
@end


@interface HintView : UIView

@property (nonatomic, copy) ItemObject * item;

@end



@interface ToutiaoView : UIView

@property (nonatomic, copy) NSArray * items;

@property (nonatomic, assign) BOOL autoscroll;
@property (nonatomic, assign) NSTimeInterval timeInterval;


@property (nonatomic, copy) void (^didSelectItemAtIndex)(NSUInteger index);



@end
