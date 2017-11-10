//
//  SHClickTextView.h
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/6.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 点击的模型
 */
@interface SHClickTextModel : NSObject

//携带参数(用户信息什么的)
@property (nonatomic, copy) id parameter;
//点击范围
@property (nonatomic, assign) NSRange range;
//字符串属性
@property (nonatomic, copy) NSDictionary *attDic;

//矩形框数组(不用赋值，内部有计算)
@property (nonatomic, copy) NSArray *rects;

@end

@class SHClickTextView;
/**
 文字局部点击回调
 */
typedef void (^SHClickTextBlock)(SHClickTextModel *model,SHClickTextView *textView);
/**
 文字局部点击视图
 */
@interface SHClickTextView : UITextView<UITextViewDelegate>

/**
 添加点击

 @param modelArr 参数集合
 @param block 回调
 */
- (void)addClickWithModelArr:(NSArray <SHClickTextModel *>*)modelArr block:(SHClickTextBlock)block;

@end

