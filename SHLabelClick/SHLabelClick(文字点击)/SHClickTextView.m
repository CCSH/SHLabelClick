//
//  SHClickTextView.m
//  SHFriendTimeLineUI
//
//  Created by CSH on 2017/4/6.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHClickTextView.h"

@implementation SHClickTextModel

@end

@interface SHClickTextView ()

//回调
@property (nonatomic, strong) SHClickTextBlock block;
//点击集合
@property (nonatomic, strong) NSMutableArray <SHClickTextModel *>*linkArr;

@end

@implementation SHClickTextView

#pragma mark - 实例化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setup];
}

#pragma mark - 初始化
- (void)setup{
    
    self.userInteractionEnabled = YES;
    self.scrollEnabled = NO;
    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.editable = YES;
    self.delegate = self;
    [self.linkArr removeAllObjects];
    //添加点击
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return NO;
}

#pragma mark - 懒加载
- (NSMutableArray *)linkArr {
    if (!_linkArr) {
        _linkArr = [[NSMutableArray alloc]init];
    }
    return _linkArr;
}

#pragma mark - 添加点击
- (void)addClickWithModelArr:(NSArray <SHClickTextModel *>*)modelArr block:(SHClickTextBlock)block{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [modelArr enumerateObjectsUsingBlock:^(SHClickTextModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self addClickWithModel:obj block:block];
        }];
    });
}

- (void)addClickWithModel:(SHClickTextModel *)model block:(SHClickTextBlock)block{
    
    //赋值
    self.block = block;
    
    //拿到字符串
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    if (atrString.length) {
        
        //添加属性
        if (model.attDic.count > 0) {
            
            NSEnumerator *enumerator = [model.attDic keyEnumerator];
            id key;
            while ((key = [enumerator nextObject])) {
                
                [atrString addAttributes:model.attDic range:model.range];
            }
        }

        self.attributedText = atrString;
        
        //计算点击位置
        self.selectedRange = model.range;
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        self.selectedRange = NSMakeRange(0, 0);
        
        NSMutableArray *rects  = [NSMutableArray array];
        
        for (UITextSelectionRect *selectionRect  in selectionRects) {
            
            CGRect rect = selectionRect.rect;
            
            if (rect.size.width || rect.size.height){
                
                [rects addObject:[NSValue valueWithCGRect:rect]];
            }else{
                continue;
            }
        }
        
        //保存
        model.rects = rects;
        
        if (model) {
            //添加点击
            [self.linkArr addObject:model];
        }
    }
}

#pragma mark - 添加点击
- (void)labelClick:(UITapGestureRecognizer *)tap{
    
    //点击了父视图的位置
    CGPoint point = [tap locationInView:self];
    
    __block SHClickTextModel *model;
    
    //查找点击位置
    [self.linkArr enumerateObjectsUsingBlock:^(SHClickTextModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        for (id rect in obj.rects) {
            //是否在点击位置
            if (CGRectContainsPoint([rect CGRectValue], point)) {
                
                model = obj;
                *stop = YES;
            }
        }
    }];
    
    //回调
    if (self.block) {
        self.block(model,self);
    }

}

@end
