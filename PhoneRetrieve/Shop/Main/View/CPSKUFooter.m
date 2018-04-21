//
//  CPSKUFooter.m
//  PhoneRetrieve
//
//  Created by wangzhangchuan on 2018/3/14.
//  Copyright © 2018年 Captain. All rights reserved.
//

#import "CPSKUFooter.h"
#import <SDCycleScrollView.h>

@implementation CPSKUFooter {
    CPLabel *hintLB;
    SDCycleScrollView *sv;
    UIWebView *webView;
    
    CPCommonButtn *wwwBT;
}

- (void)setupUI {
    
    {
        hintLB = [CPLabel new];
        hintLB.numberOfLines = 0;
        hintLB.textColor = UIColor.redColor;
        [self.contentView addSubview:hintLB];
        [hintLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cellSpaceOffset);
            make.left.mas_equalTo(cellSpaceOffset);
            make.right.mas_equalTo(-cellSpaceOffset);
        }];
    }
    
    {
        webView = [UIWebView new];
        webView.backgroundColor = [UIColor clearColor];
        webView.dataDetectorTypes = UIDataDetectorTypeAll;
        webView.delegate = self;
        [self.contentView addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(hintLB.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(cellSpaceOffset);
            make.right.mas_equalTo(-cellSpaceOffset);
//            make.bottom.mas_equalTo(-cellSpaceOffset);
            make.height.mas_equalTo(80);
//            make.height.mas_equalTo(80);
        }];
    }
    
    {
        sv = [SDCycleScrollView new];
        sv.placeholderImage = CPImage(@"apple");
        sv.currentPageDotColor = MainColor;
        [self.contentView addSubview:sv];
        [sv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(webView.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(cellSpaceOffset);
            make.right.mas_equalTo(-cellSpaceOffset);
//            make.bottom.mas_equalTo(-cellSpaceOffset);
            make.height.mas_equalTo(140);
        }];
    }
    
    {
        wwwBT = [CPCommonButtn new];
        [wwwBT addTarget:self action:@selector(buttonAction:) forControlEvents:64];
        [self.contentView addSubview:wwwBT];
        [wwwBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sv.mas_bottom).offset(CELL_HEIGHT_F);
            make.left.mas_equalTo(cellSpaceOffset);
            make.right.mas_equalTo(-cellSpaceOffset);
        }];
    }
}

- (void)setModel:(CPFlowModel *)model {
    
    
    if (nil == model) {
        return;
    }
    
    _model = model;
    
    if (!model.Description || model.Description.length == 0) {
        webView.hidden = YES;
    } else {
        webView.hidden = NO;
        [webView loadHTMLString:htmlEntityDecode(_model.Description) baseURL:nil];
    }
    
    if (!_model.images || _model.images.count == 0) {
        sv.hidden = YES;
        [sv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(webView.mas_bottom).offset(cellSpaceOffset);
            make.left.mas_equalTo(cellSpaceOffset);
            make.right.mas_equalTo(-cellSpaceOffset);
            //            make.bottom.mas_equalTo(-cellSpaceOffset);
            make.height.mas_equalTo(0);
        }];
    } else {
        sv.hidden = NO;
        sv.imageURLStringsGroup = _model.images;
    }
    
    hintLB.text = _model.tips;
    
//    _model.descriptionclickurl = model//@"https://www.baidu.com";
    wwwBT.hidden = _model.descriptionclickurl.length == 0;
    
    NSString *title = [NSString stringWithFormat:@"相关网址：%@",_model.descriptionclickurl];
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:title
                                                               attributes:@{
                                                                            NSForegroundColorAttributeName : MainColor,
                                                                            NSUnderlineStyleAttributeName : @1
                                                                            }];
    
    [wwwBT setAttributedTitle:attr forState:0];
//    [wwwBT setTitle:title forState:0];
}

- (void)buttonAction:(UIButton *)sender {
    if([[UIApplication sharedApplication] canOpenURL:CPUrl(_model.descriptionclickurl)]) {
        [[UIApplication sharedApplication] openURL:CPUrl(_model.descriptionclickurl)];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    
    return YES;
}

@end
