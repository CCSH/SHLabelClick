//
//  TableViewController.m
//  SHLabelClick
//
//  Created by CSH on 2017/11/9.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

@interface TableViewController ()

@property (nonatomic, copy) NSArray *modelArr;

@end

@implementation TableViewController

static NSString *const content = @"QWERTYUI欧帕斯对方 过后就看 了子线程VB你们收 款点击哪里文件你 12345 67890 qwert yuiopasd fghjklz xcvbnm才能前往IP恩赐陪我企鹅怒词谱呢往前二批UN前往";

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *colorArr = @[[UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor grayColor],[UIColor redColor],[UIColor orangeColor],[UIColor lightGrayColor],[UIColor redColor],[UIColor orangeColor],[UIColor lightGrayColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor]];
    
    NSMutableArray *modelArr  = [[NSMutableArray alloc]init];
    
    NSInteger loc = 0;
    NSInteger len = 1;
    
    for (int i = 0; i < 20; i++) {
        
        SHClickTextModel *model = [[SHClickTextModel alloc]init];
        
        model.parameter = [NSString stringWithFormat:@"%d",i];
        model.attDic = @{NSForegroundColorAttributeName:colorArr[arc4random()%colorArr.count]};
        model.range = NSMakeRange(loc, len);
        
        loc += len + arc4random()%5;

        len = 1 + arc4random()%4;

        if ((loc + len) > content.length) {
            break;
        }
        
        [modelArr addObject:model];
    }
    self.modelArr = modelArr;
    
    self.tableView.rowHeight = 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];

    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil] lastObject];
    }
    
    cell.textView.tag = indexPath.row;
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc]initWithString:content];
    [atrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(0, atrString.length)];
    
    cell.textView.attributedText = atrString;
    
    //添加点击(需要内容提前赋值)
    [cell.textView addClickWithModelArr:self.modelArr block:^(SHClickTextModel *obj, SHClickTextView *textView) {
        
        if (obj) {
            
            NSLog(@"第%ld个 === 参数:%@",(long)textView.tag,obj.parameter);
        }else{
            NSLog(@"第%ld个 === 点击了空白位置",(long)textView.tag);
        }
    }];
    
    return cell;
}

@end
