//
//  CPMemberRegisterStep01VC.m
//  PhoneRetrieve
//
//  Created by 王璋传 on 2018/7/2.
//  Copyright © 2018年 Captain. All rights reserved.
//

#import "CPMemberRegisterStep01VC.h"
#import "CPRegistStepView.h"
#import "CPSelectTextField.h"
#import "CPPhotoUploadBT.h"
#import "TZImagePickerController.h"

@interface CPMemberRegisterStep01VC ()<CPSelectTextFieldDelegat>

@property (nonatomic, strong) CPSelectTextField *proviceTF, *cityTF, *areaTF;
@property (nonatomic, strong) CPProviceCityAreaModel *cityModel, *proviceModel, *areaModel;
@property (nonatomic,strong) CPRegistStepView *stepView;
@property (nonatomic, strong) CPTextField *addressTF;

@property (nonatomic, strong) CPPhotoUploadBT *businessLicenseBT, *IDFrontBT, *IDBackBT;
@property (nonatomic, strong) CPTextField *bankAccontNameTF, *bankAccountTF,*bankSelecteTF,*bankBranchTF;
//@property (nonatomic, strong) CPSelectTextField *bankSelecteTF;

@property (nonatomic,strong) CPButton *nextAction;

@end

@implementation CPMemberRegisterStep01VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataTableView.backgroundColor = UIColor.whiteColor;
    
    [self loadProvice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;};
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return 1;};
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {return 890;};
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {return 0.00000001;};
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {return 0.00000001;}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {return nil;};
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {return nil;};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"CellIdentify";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self setupUIWithCell:cell];
    
    return cell;
}

#pragma mark - setup view
- (void)setupUIWithCell:(UITableViewCell *)cell {
   // 注册进度视图
    self.stepView = [[CPRegistStepView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44.9f) itemTitles:@[ @"注册只需3步",@"登录信息",@"会员信息"]];
    self.stepView.currentStep = 1;
    
    [cell.contentView addSubview:self.stepView];
    
    //  省市区选择
    CGFloat width = (SCREENWIDTH - 4 * cellSpaceOffset) / 3;
    
    if (nil == self.proviceTF) {
        
        self.proviceTF = [[CPSelectTextField alloc] initWithFrame:CGRectMake(0, 0, width, CELL_HEIGHT_F)];
        self.proviceTF.placeholder = @"选择省";
        self.proviceTF.cp_editDelegate = self;
        self.proviceTF.type = 0;
        //        self.proviceTF.dataArray = @[@"1111",@"222",@"333"];
        
        [cell.contentView addSubview:self.proviceTF];
        
        [self.proviceTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.stepView.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(cellSpaceOffset);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(CELL_HEIGHT_F);
        }];
    }
    
    if (nil == self.cityTF) {
        
        self.cityTF = [[CPSelectTextField alloc] initWithFrame:CGRectMake(0, 0, width, CELL_HEIGHT_F)];
        self.cityTF.placeholder = @"选择市";
        //        self.cityTF.dataArray = @[@"aaa",@"bbb",@"ccc"];
        self.cityTF.cp_editDelegate = self;
        self.cityTF.type = 1;
        
        [cell.contentView addSubview:self.cityTF];
        
        [self.cityTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.stepView.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(self.proviceTF.mas_right).offset(cellSpaceOffset);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(CELL_HEIGHT_F);
        }];
    }
    
    if (nil == self.areaTF) {
        
        self.areaTF = [[CPSelectTextField alloc] initWithFrame:CGRectMake(0, 0, width, CELL_HEIGHT_F)];
        self.areaTF.placeholder = @"选择区";
        //        self.areaTF.dataArray = @[@"----",@"xxxx",@">>>>>>"];
        self.areaTF.cp_editDelegate = self;
        self.areaTF.type = 2;
        
        [cell.contentView addSubview:self.areaTF];
        
        [self.areaTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.stepView.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(self.cityTF.mas_right).offset(cellSpaceOffset);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(CELL_HEIGHT_F);
        }];
    }
    
    //  收货地址栏
    {
        self.addressTF = [CPTextField new];
        self.addressTF.placeholder = @"收货地址";
        
        [cell.contentView addSubview:self.addressTF];
        [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.proviceTF.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(cellSpaceOffset);
            make.right.mas_equalTo(-cellSpaceOffset);
            make.height.mas_equalTo(CELL_HEIGHT_F);
        }];
    }
    
    //  图片上传
    if (nil == self.businessLicenseBT) {
        
        self.businessLicenseBT = [CPPhotoUploadBT new];
        //        self.businessLicenseBT.backgroundColor = UIColor.redColor;
        //        [self.businessLicenseBT setImage:CPImage(@"header.jpg") forState:0];
        [self.businessLicenseBT setBackgroundImage:CPImage(@"add_pic") forState:UIControlStateNormal];
        [self.businessLicenseBT addTarget:self action:@selector(showImagePickVC:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:self.businessLicenseBT];
        
        [self.businessLicenseBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.addressTF.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(cellSpaceOffset);
            make.size.mas_equalTo(CGSizeMake(2 * CELL_HEIGHT_F, 2 * CELL_HEIGHT_F));
        }];
        
    }
    
    
    CPLabel *licenseTitleLB = [CPLabel new];
    licenseTitleLB.text = @"营业执照(可选)";
    licenseTitleLB.textColor = [UIColor redColor];
    licenseTitleLB.textAlignment = NSTextAlignmentCenter;
    
    [cell.contentView addSubview:licenseTitleLB];
    
    [licenseTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.businessLicenseBT.mas_bottom).offset(4);
        make.left.mas_equalTo(self.businessLicenseBT.mas_left);
        make.right.mas_equalTo(self.businessLicenseBT.mas_right);
    }];
    
    
    if (nil == self.IDFrontBT) {
        
        self.IDFrontBT = [CPPhotoUploadBT new];
        //        self.IDFrontBT.backgroundColor = UIColor.redColor;
        //        [self.IDFrontBT setImage:CPImage(@"header.jpg") forState:0];
        [self.IDFrontBT setBackgroundImage:CPImage(@"add_pic") forState:UIControlStateNormal];
        [self.IDFrontBT addTarget:self action:@selector(showImagePickVC:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:self.IDFrontBT];
        
        [self.IDFrontBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(licenseTitleLB.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(cellSpaceOffset);
            make.size.mas_equalTo(CGSizeMake(2 * CELL_HEIGHT_F, 2 * CELL_HEIGHT_F));
        }];
        
        CPLabel *titleLB = [CPLabel new];
        titleLB.text = @"身份证正面";
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.textColor = [UIColor redColor];
        
        [cell.contentView addSubview:titleLB];
        
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.IDFrontBT.mas_bottom).offset(4);
            make.left.mas_equalTo(self.IDFrontBT.mas_left);
            make.right.mas_equalTo(self.IDFrontBT.mas_right);
        }];
    }
    
    if (nil == self.IDBackBT) {
        
        self.IDBackBT = [CPPhotoUploadBT new];
        //        self.IDBackBT.backgroundColor = UIColor.redColor;
        //        [self.IDBackBT setImage:CPImage(@"header.jpg") forState:0];
        [self.IDBackBT setBackgroundImage:CPImage(@"add_pic") forState:UIControlStateNormal];
        [self.IDBackBT addTarget:self action:@selector(showImagePickVC:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:self.IDBackBT];
        
        [self.IDBackBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(licenseTitleLB.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(self.IDFrontBT.mas_right).offset(cellSpaceOffset);
            make.size.mas_equalTo(CGSizeMake(2 * CELL_HEIGHT_F, 2 * CELL_HEIGHT_F));
        }];
        
        CPLabel *titleLB = [CPLabel new];
        titleLB.text = @"身份证背面";
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.textColor = [UIColor redColor];
        
        [cell.contentView addSubview:titleLB];
        
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.IDBackBT.mas_bottom).offset(4);
            make.left.mas_equalTo(self.IDBackBT.mas_left);
            make.right.mas_equalTo(self.IDBackBT.mas_right);
        }];
    }
    
    //  账号信息相关
    {
        CPLabel *headerLB = [CPLabel new];
        headerLB.text = @"银行信息";
        [cell.contentView addSubview:headerLB];
        [headerLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.IDBackBT.mas_bottom).offset(60);
            make.left.mas_equalTo(cellSpaceOffset);
        }];
        
        UIView *sepLine = [UIView new];
        sepLine.backgroundColor = CPBoardColor;
        
        [cell.contentView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerLB.mas_bottom).offset(4);
            make.left.mas_equalTo(cellSpaceOffset);
            make.right.mas_equalTo(-cellSpaceOffset);
            make.height.mas_equalTo(1);
        }];
        
        if (nil == self.bankAccontNameTF) {
            self.bankAccontNameTF = [CPTextField new];
            self.bankAccontNameTF.placeholder = @"收款人名称";
            [cell.contentView addSubview:self.bankAccontNameTF];
            [self.bankAccontNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(sepLine.mas_bottom).offset(cellSpaceOffset);
                make.left.mas_equalTo(cellSpaceOffset);
                make.right.mas_equalTo(-cellSpaceOffset);
                make.height.mas_equalTo(CELL_HEIGHT_F);
            }];
        }
        
        if (nil == self.bankSelecteTF) {
            self.bankSelecteTF = [[CPTextField alloc] initWithFrame:CGRectMake(cellSpaceOffset, 0, SCREENWIDTH - 2 * cellSpaceOffset, CELL_HEIGHT_F)];
            self.bankSelecteTF.placeholder = @"银行名称";
//            self.bankSelecteTF.tintColor = UIColor.clearColor;

            [cell.contentView addSubview:self.bankSelecteTF];
            [self.bankSelecteTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bankAccontNameTF.mas_bottom).offset(cellSpaceOffset);
                make.left.mas_equalTo(cellSpaceOffset);
                make.right.mas_equalTo(-cellSpaceOffset);
                make.height.mas_equalTo(CELL_HEIGHT_F);
            }];
        }
        
        if (nil == self.bankBranchTF) {
            self.bankBranchTF = [[CPTextField alloc] initWithFrame:CGRectMake(cellSpaceOffset, 0, SCREENWIDTH - 2 * cellSpaceOffset, CELL_HEIGHT_F)];
            self.bankBranchTF.placeholder = @"支行名称";
            //            self.bankBranchTF.tintColor = UIColor.clearColor;
            
            [cell.contentView addSubview:self.bankBranchTF];
            [self.bankBranchTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bankSelecteTF.mas_bottom).offset(cellSpaceOffset);
                make.left.mas_equalTo(cellSpaceOffset);
                make.right.mas_equalTo(-cellSpaceOffset);
                make.height.mas_equalTo(CELL_HEIGHT_F);
            }];
        }
        
        if (nil == self.bankAccountTF) {
            self.bankAccountTF = [CPTextField new];
            self.bankAccountTF.placeholder = @"银行账号";
            [cell.contentView addSubview:self.bankAccountTF];
            [self.bankAccountTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bankBranchTF.mas_bottom).offset(cellSpaceOffset);
                make.left.mas_equalTo(cellSpaceOffset);
                make.right.mas_equalTo(-cellSpaceOffset);
                make.height.mas_equalTo(CELL_HEIGHT_F);
            }];
        }

    }
    
    //  提交按钮
    {
        if (nil == self.nextAction) {
            self.nextAction = [CPButton new];
            [cell.contentView addSubview:self.nextAction];
            [self.nextAction setTitle:@"提交注册信息" forState:0];
            [self.nextAction addTarget:self action:@selector(nextAction:) forControlEvents:64];
            [self.nextAction mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.bankAccountTF.mas_bottom).offset(CELL_HEIGHT_F);
                make.left.mas_equalTo(cellSpaceOffset);
                make.right.mas_equalTo(-cellSpaceOffset);
                make.height.mas_equalTo(CELL_HEIGHT_F);
            }];
            
            RAC(self.nextAction,enabled) = [RACSignal combineLatest:@[
                                                                      self.proviceTF.rac_textSignal,
                                                                      self.cityTF.rac_textSignal,
                                                                      self.areaTF.rac_textSignal,
                                                                      self.addressTF.rac_textSignal,
                                                                      self.bankAccontNameTF.rac_textSignal,
                                                                      self.bankSelecteTF.rac_textSignal,
                                                                      self.bankAccountTF.rac_textSignal,
                                                                      self.bankBranchTF.rac_textSignal
                                                                      ]
                                                             reduce:^id{
                                                                 return @(
                                                                 self.proviceTF.text.length > 0 &&
                                                                 self.cityTF.text.length > 0 &&
                                                                 self.areaTF.text.length > 0 &&
                                                                 self.addressTF.text.length > 0 &&
                                                                 self.bankBranchTF.text.length > 0 &&
                                                                 self.bankAccontNameTF.text.length > 0 &&
                                                                 self.bankSelecteTF.text.length > 0 &&
                                                                 self.bankAccountTF.text.length > 0 &&
                                                                 self.IDFrontBT.imageUrl.length > 0 &&
                                                                 self.IDBackBT.imageUrl.length > 0
                                                                 );
                                                             }];
        }
    }
}



#pragma mark - CPSelectTextFieldDelegat
- (void)cp_textFieldDidBeginEditing:(UITextField *)textField model:(CPProviceCityAreaModel *)model{};
- (void)cp_textFieldDidEndEditing:(UITextField *)textField model:(CPProviceCityAreaModel *)model{

    if (textField == self.proviceTF) {
        [self loadCity:model.Code];
        self.proviceModel = model;
    } else if (textField == self.cityTF) {
        [self loadArea:model.Code];
        self.cityModel = model;
    } else if (textField == self.areaTF) {
        self.areaModel = model;
    } else if (textField == self.bankSelecteTF) {
//        textField.text = @"00000";
    }
    
}


#pragma mark - private method implement
#pragma mark - load data

- (void)loadProvice {
    
    __weak typeof(self) weakSelf = self;
    
    [CPProviceCityAreaModel modelRequestWith:DOMAIN_ADDRESS@"/api/area/findData?parentcode=0"
                                  parameters:nil
                                       block:^(id result) {
                                           [weakSelf handleLoadProviceBlock:result];
                                       } fail:^(CPError *error) {
                                           
                                       }];
}

- (void)handleLoadProviceBlock:(NSArray <CPProviceCityAreaModel *> *)result {
    if (!result || ![result isKindOfClass:[NSArray class]]) {
        return;
    }
    
    self.proviceTF.dataArray = result;
}

- (void)loadCity:(NSString *)paramCode {
    
    __weak typeof(self) weakSelf = self;
    
    [CPProviceCityAreaModel modelRequestWith:DOMAIN_ADDRESS@"/api/area/findData"
                                  parameters:@{@"parentcode" : paramCode}
                                       block:^(id result) {
                                           [weakSelf handleLoadCityBlock:result];
                                       } fail:^(CPError *error) {
                                           
                                       }];
}

- (void)handleLoadCityBlock:(NSArray <CPProviceCityAreaModel *> *)result {
    if (!result || ![result isKindOfClass:[NSArray class]]) {
        return;
    }
    
    self.cityTF.dataArray = result;
}

- (void)loadArea:(NSString *)paramCode {
    
    __weak typeof(self) weakSelf = self;
    
    [CPProviceCityAreaModel modelRequestWith:DOMAIN_ADDRESS@"/api/area/findData"
                                  parameters:@{@"parentcode" : paramCode}
                                       block:^(id result) {
                                           [weakSelf handleLoadAreaBlock:result];
                                       } fail:^(CPError *error) {
                                           
                                       }];
}

- (void)handleLoadAreaBlock:(NSArray <CPProviceCityAreaModel *> *)result {
    if (!result || ![result isKindOfClass:[NSArray class]]) {
        return;
    }
    
    self.areaTF.dataArray = result;
}

#pragma mark - private method

- (void)showImagePickVC:(CPPhotoUploadBT *)sender {
    
    __weak CPMemberRegisterStep01VC *weakSelf = self;
    
    TZImagePickerController *vc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    
    [vc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"------");
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender setImage:photos.firstObject forState:UIControlStateNormal];
            
            [[CPProgress Instance] showLoading:self.view message:@"图片上传中"];
            
            [CPBaseModel uploadImages:photos.firstObject block:^(NSString *filePath) {
                DDLogError(@">>>>>>>>>>>>>>>>>>>>%@",filePath);
                sender.imageUrl = filePath;
                [[CPProgress Instance] hidden];
            }];
            
            [weakSelf handleImagePickImageBlock];
        });
    }];
    
    
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav presentViewController:vc animated:YES completion:nil];
}

- (void)handleImagePickImageBlock {
    self.nextAction.enabled = (
                               self.proviceTF.text.length > 0 &&
                               self.cityTF.text.length > 0 &&
                               self.areaTF.text.length > 0 &&
                               self.addressTF.text.length > 0 &&
                               self.bankAccontNameTF.text.length > 0 &&
                               self.bankSelecteTF.text.length > 0 &&
                               self.bankAccountTF.text.length > 0 &&
                               self.IDFrontBT.imageUrl.length > 0 &&
                               self.IDBackBT.imageUrl.length > 0 &&
                               self.bankBranchTF.text.length > 0
                               );
}

-(void)nextAction:(id)sender {
    
    NSMutableDictionary *params = @{
                                   @"phone" : [CPRegistParam shareInstance].phone,
                                   @"sms" : [CPRegistParam shareInstance].sms,
                                   @"password" : [CPRegistParam shareInstance].password,
                                   @"provinceid" : self.proviceModel.Code,
                                   @"cityid" : self.cityModel.Code,
                                   @"districtid" : self.areaModel.Code,
                                   @"address" : self.addressTF.text,
                                   @"idcard1url" : self.IDFrontBT.imageUrl,
                                   @"idcard2url" : self.IDBackBT.imageUrl,
                                   @"bankname" : self.bankSelecteTF.text,
                                   @"banknum" : self.bankAccountTF.text,
                                   @"bankbranch" : self.bankBranchTF.text,
                                   @"bname" : self.bankAccontNameTF.text
                                   }.mutableCopy;
    
    //  可选的营业执照
    if (self.businessLicenseBT.imageUrl.length > 0) {
        [params setObject:self.businessLicenseBT.imageUrl forKey:@"licenseurl"];
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    [CPBaseModel modelRequestWith:DOMAIN_ADDRESS@"/api/user/register6"
                       parameters:params
                            block:^(id result) {
                                [weakSelf handleRegistActionBlock:result];
                            } fail:^(CPError *error) {
                                
                            }];
}

- (void)handleRegistActionBlock:(id)result {
    [self.view makeToast:@"您提交的信息已发送至商家中，请耐心等候商家审核！！！" duration:2.0f position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
        
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([NSStringFromClass(obj.class) isEqualToString:@"CPLoginVC"]) {
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
            }
        }];
        
    }];
}

@end
