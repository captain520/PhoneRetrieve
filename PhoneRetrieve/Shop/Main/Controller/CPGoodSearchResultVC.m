//
//  CPGoodSearchResultVC.m
//  PhoneRetrieve
//
//  Created by wangzhangchuan on 2018/3/21.
//  Copyright © 2018年 Captain. All rights reserved.
//

#import "CPGoodSearchResultVC.h"
#import "CPGoodModel.h"
#import "CPFlowVC.h"
#import "CPSortCell.h"

@interface CPGoodSearchResultVC ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIButton *backItem;

@end

@implementation CPGoodSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];

    [self loadData];
}

- (void)setupUI {

    self.dataTableView.frame = CGRectMake(0, CPStatusBarHeight, SCREENWIDTH, SCREENHEIGHT - CPStatusBarHeight);
    //  返回按钮
    {
        self.backItem = [[UIButton alloc] initWithFrame:CGRectMake(8., 0, CELL_HEIGHT_F, CELL_HEIGHT_F)];

        [self.dataTableView addSubview:self.backItem];
        [self.backItem setImage:CPImage(@"right-arrow") forState:0];
        [self.backItem addTarget:self action:@selector(backAction:) forControlEvents:64];
    }

    [self.dataTableView addSubview:self.searchBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIdentify = @"CellIdentify";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
//    if (nil == cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
//        cell.clipsToBounds = YES;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//
//    CPGoodModel *model = self.dataArray[indexPath.section][indexPath.row];
//    cell.textLabel.text = model.name;
    static NSString *cellIdentify = @"CPSortCell";
    
    CPSortCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (nil == cell) {
        cell = [[CPSortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.clipsToBounds = YES;
        cell.contentView.backgroundColor = BgColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CPGoodModel *good = self.dataArray[indexPath.section][indexPath.row];
    cell.no = [NSString stringWithFormat:@"%02ld",(long)indexPath.row + 1];
    cell.content = good.name;
    
    return cell;
}

- (UISearchBar *)searchBar {
    
    if (nil == _searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 0, SCREENWIDTH - 60, CELL_HEIGHT_F)];
        _searchBar.barTintColor = MainColor;//[UIColor clearColor];
        _searchBar.showsCancelButton = YES;
        //        _searchBar.backgroundColor = [UIColor redColor];
        _searchBar.layer.borderColor = MainColor.CGColor;
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.delegate = self;
    }
    
    return _searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    [self.view endEditing:YES];
//        [self push2VCWith:@"CPSearchVC" title:nil];
//    [self push2VCWith:@"CPGoodSearchResultVC" title:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    DDLogInfo(@"i0i0i0i0i0i0i0i0i0i0");
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *params= @{
                            @"name" : self.searchBar.text,
                            @"repaircfg" : @"1"
                            };
    
    [CPGoodModel modelRequestWith:CPURL_SHOP_GOOD_LIST
                       parameters:params
                            block:^(id result) {
                                [weakSelf handleLoadGoodsBlock:result];
                            } fail:^(CPError *error) {
                                
                            }];
}

- (void)handleLoadGoodsBlock:(NSArray <CPGoodModel *> *)result {
    if (!result || ![result isKindOfClass:[NSArray class]]) {
        self.dataArray = @[];
    } else {
        self.dataArray = @[result];
    }

    [self.dataTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CPGoodModel *model = self.dataArray[indexPath.section][indexPath.row];

    CPFlowVC *flowVC = [[CPFlowVC alloc] init];
    flowVC.title = @"手机是否存在以下问题？";
    flowVC.goodid = model.ID;
    
    [self.navigationController pushViewController:flowVC animated:YES];
    
}

#pragma mark - back action

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
