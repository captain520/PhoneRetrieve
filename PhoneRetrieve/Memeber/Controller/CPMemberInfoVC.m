//
//  CPMemberInfoVC.m
//  PhoneRetrieve
//
//  Created by 王璋传 on 2018/7/4.
//  Copyright © 2018年 Captain. All rights reserved.
//

#import "CPMemberInfoVC.h"
#import "CPShopAboutHeader.h"
#import "CPMemberInfoEditCell.h"
#import "CPItemPickerAlert.h"
#import "CPMemberRateListModel.h"
#import "CPUserDetailInfoModel.h"

@interface CPMemberInfoVC ()

@property (nonatomic, strong) CPShopAboutHeader *headerView;
@property (nonatomic, strong) NSArray <CPMemberRateListModel *> *rateModels;

@end

@implementation CPMemberInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupUI];
}

//  初始化视图
- (void)setupUI {
    
    self.headerView = [[CPShopAboutHeader alloc] initWithReuseIdentifier:@"CPShopAboutHeader"];
    self.headerView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH * 2/3);
    self.headerView.backgroundView.backgroundColor = UIColor.redColor;

    [self.view addSubview:self.headerView];
    
    [self.dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - setter && getter

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadUserDetailInfo];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UITtableview Delegate && datasouce
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CPMemberInfoEditCell";
    
    CPMemberInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CPMemberInfoEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.shouldShowBottomLine = YES;
    }
    
    NSArray *tempArray = self.dataArray[indexPath.section];

    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell setTItle:tempArray[indexPath.row] subTitle:@"" hideArrowYesOrNo:YES];
    } else {
        [cell setTItle:tempArray[indexPath.row] subTitle:@"修改" hideArrowYesOrNo:NO];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 30;}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"会员信息";
    } if (1 == section) {
        return @"安全设置";
    } else if (2 == section) {
        return @"收款信息";
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            [self push2VCWith:@"CPAssistantModifyPhoneVC" title:@"修改手机号码"];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self push2VCWith:@"CPModifyShopPasswdVC" title:@"修改密码"];
                }
                    break;
                case 1:
                {
                    [self push2VCWith:@"CPMemberSonVC" title:@"子会员管理"];
                }
                    break;
                case 2:
                {
                    if (self.rateModels.count > 0) {
                        [self showPickerView];
                    } else {
                        [self loadMemberRateList];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            [self push2VCWith:@"CPMemberUpdateBankInfoVC" title:@"修改银行卡"];
        }
            break;

        default:
            break;
    }

}

#pragma mark - Pirvate method implement

- (void)loadData {
    
}

- (void)loadMemberRateList {
    
    __weak typeof(self) weakSelf = self;
    
    [CPMemberRateListModel modelRequestWith:DOMAIN_ADDRESS@"/api/userpre/findpre"
                                 parameters:nil
                                      block:^(id result) {
                                          [weakSelf handleLoadMemeberRateListBlock:result];
                                      } fail:^(CPError *error) {
                                          
                                      }];
}

- (void)handleLoadMemeberRateListBlock:(NSArray <CPMemberRateListModel *> *)result {
    if (!result || ![result isKindOfClass:[NSArray class]]) {
        return;
    }
    
    self.rateModels = result;
    
    [self showPickerView];
}

- (void)showPickerView {
    
    __weak typeof(self) weakSelf = self;
    
    CPItemPickerAlert *centerView = [[CPItemPickerAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
    centerView.dataArray = @[[self.rateModels valueForKeyPath:@"values"]].mutableCopy;
    centerView.actionBlock = ^(NSUInteger component, NSUInteger row) {
        DDLogInfo(@"component :%ld row:%lu",component,(unsigned long)row);
        [weakSelf updateRate:row];
    };
    
    [centerView show];
}

- (void)updateRate:(NSInteger)row {
    
    __weak typeof(self) weakSelf = self;
    
    CPMemberRateListModel *model = self.rateModels[row];
    
    [CPBaseModel modelRequestWith:DOMAIN_ADDRESS@"/api/user/setPgprice_pre"
                       parameters:@{
                                    @"userid":@([CPUserInfoModel shareInstance].loginModel.ID),
                                    @"pgprice_pre": model.values
                                    }
                            block:^(id result) {
                                [weakSelf handleUdpateRateBlock:result row:row];
                            } fail:^(CPError *error) {
                                
                            }];
}

- (void)handleUdpateRateBlock:(CPBaseModel *)result row:(NSUInteger)row {
    
    [self.view makeToast:@"设置成功" duration:1.0f position:CSToastPositionCenter];

    [self updateRateCell:0 row:row];
}

- (void)updateRateCell:(NSUInteger)section row:(NSUInteger)row {
    
    CPMemberRateListModel *model = self.rateModels[row];
    NSString *title =  [NSString stringWithFormat:@"建议价格比例：(%@%%)",model.values];

    CPMemberInfoEditCell *cell = [self.dataTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    
    [cell setTItle:title subTitle:@"" hideArrowYesOrNo:NO];
}

/**
 获取用户详细信息
 */
- (void)loadUserDetailInfo {
    
    __weak typeof(self) weakSelf = self;
    
    [CPUserDetailInfoModel modelRequestWith:DOMAIN_ADDRESS@"/api/user/getDetailUserInfo"
                                 parameters:@{@"userid" : @([CPUserInfoModel shareInstance].loginModel.ID)}
                                      block:^(CPUserDetailInfoModel *result) {
                                          [weakSelf handleLoadUserDetailinfoBlock:result];
                                      } fail:^(NSError *error) {
                                          
                                      }];
}

- (void)handleLoadUserDetailinfoBlock:(CPUserDetailInfoModel *)result {
    if (!result || ![result isKindOfClass:[CPUserDetailInfoModel class]]) {
        return;
    }
    
    [CPUserInfoModel shareInstance].userDetaiInfoModel = result;

    NSString *linkName = result.linkname.length > 0 ? result.linkname : result.phone;
    self.headerView.content = [NSString stringWithFormat:@"会员编号：%@",result.cpcode];
    self.headerView.detail = [NSString stringWithFormat:@"会员昵称：%@",linkName];
    
    self.dataArray = @[
                       //   会员信息
                       @[
                           [NSString stringWithFormat:@"负责人：%@",linkName],
                           [NSString stringWithFormat:@"手机号码：%@",result.phone],
                           ],
                       //   安全设置
                       @[
                           @"登录密码",
                           @"子会员管理",
                           [NSString stringWithFormat:@"建议价格比例：(%@)",result.pgprice_pre]
                           ],
                       //   收款信息
                       @[
                           [NSString stringWithFormat:@"收款信息：%@",result.bankname]
                           ]
                       ].mutableCopy;
    
    [self.dataTableView reloadData];
}

@end
