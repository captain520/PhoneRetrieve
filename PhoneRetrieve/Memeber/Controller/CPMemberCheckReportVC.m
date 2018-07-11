//
//  CPMemberCheckReportVC.m
//  PhoneRetrieve
//
//  Created by 王璋传 on 2018/7/11.
//  Copyright © 2018年 Captain. All rights reserved.
//

#import "CPMemberCheckReportVC.h"
#import "CPMemberCheckReportInfoCell.h"
#import "CPMemberReportResultModel.h"
#import "CPMemeberCheckQuestionCell.h"

@interface CPMemberCheckReportVC ()

@property (nonatomic, strong) CPMemberReportResultModel *model;

@end

@implementation CPMemberCheckReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"验机报告"];
    
    self.dataArray = @[
                       @[@""],
                       @[@""]
                       ];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    } else if (1 == section) {
        return 3;
    }
    
    return self.model.checkjson.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 60;
            break;
        case 1:
            return 100;
        default:
            break;
    }
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CELL_HEIGHT_F * section;
}

#pragma mark - uitableview Datasouce && delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.section) {
        return [self configCheckQuestionCell:indexPath];
    }
    return [self configBaseInfoCell:indexPath];
}

- (CPMemberCheckReportInfoCell *)configBaseInfoCell:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CPMemberCheckReportInfoCell";
    
    CPMemberCheckReportInfoCell *cell = [self.dataTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell =[[CPMemberCheckReportInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.model = self.model;
    
    return cell;
    
}

- (CPMemeberCheckQuestionCell *)configCheckQuestionCell:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CPMemeberCheckQuestionCell";
    
    CPMemeberCheckQuestionCell *cell = [self.dataTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell =[[CPMemeberCheckQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *headerIdentifier = @"Header";
    
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    CPLabel *titleLB  = [header.contentView viewWithTag:CPBASETAG];
    if (nil == header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
        header.contentView.backgroundColor = UIColor.whiteColor;
        
        titleLB = [CPLabel new];
        titleLB.text = @"验货信息";
        [header.contentView addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(header.contentView.mas_centerX);
            make.centerY.mas_equalTo(header.contentView.mas_centerY);
        }];
        
        UIView *sepLine = [UIView new];
        sepLine.backgroundColor = CPBoardColor;
        
        [header.contentView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(.5);
        }];
    }
    
    return header;
}

#pragma mark - private method

- (void)loadData {
    [self.dataTableView reloadData];
    
    __weak typeof(self) weakSelf = self;

    [CPMemberReportResultModel modelRequestWith:DOMAIN_ADDRESS@"/api/Reportresult/getResultCheckInfo"
                       parameters:@{@"resultid" : self.resultid}
                            block:^(id result) {
                                [weakSelf handleLoadDataBlock:result];
                            } fail:^(CPError *error) {
                                
                            }];
}

- (void)handleLoadDataBlock:(CPMemberReportResultModel *)result {
    if (!result || ![result isKindOfClass:[CPMemberReportResultModel class]]) {
        return;
    }
    
    self.model = result;
   
    [self.dataTableView reloadData];
}

@end
