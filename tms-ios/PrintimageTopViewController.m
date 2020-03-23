//
//  PrintimageTopViewController.m
//  tms-ios
//
//  Created by wangww on 2020/3/16.
//  Copyright © 2020 wangziting. All rights reserved.
//

#import "PrintimageTopViewController.h"
#import "Tools.h"

@interface PrintimageTopViewController ()

// 标签号条码
@property (weak, nonatomic) IBOutlet UIImageView *barCodeImageView;
// 标签号
@property (weak, nonatomic) IBOutlet UILabel *productNo;

// 订单号二维码
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;


/********* 寄方 *********/
// 发货联系人
@property (weak, nonatomic) IBOutlet UILabel *issuePartyContact;
// 发货人电话(有值则显示没有则取固话)
@property (weak, nonatomic) IBOutlet UILabel *issuePartyTel_or_issuePartyGuHua;
// 发货城市
@property (weak, nonatomic) IBOutlet UILabel *issuePartyCity;
// 发货区县 + 发货详细地址
@property (weak, nonatomic) IBOutlet UILabel *issuePartyDistricict_and_issuePartyAddr;
// 寄件时间
@property (weak, nonatomic) IBOutlet UILabel *actualPieceTime;

/********* 收方 *********/
// 收货联系人
@property (weak, nonatomic) IBOutlet UILabel *receivePartyContactName;
// 收货人电话(有值则显示没有则取固话)
@property (weak, nonatomic) IBOutlet UILabel *receivePartyPhone_or_receivePartyGuHua;
// 收货城市
@property (weak, nonatomic) IBOutlet UILabel *receivePartyCity;
// 收货区县 + 收货地址
@property (weak, nonatomic) IBOutlet UILabel *receicePartyDistricict_and_receivePartyAddr1;

/********* 货物名称 *********/
// 货物名称
@property (weak, nonatomic) IBOutlet UILabel *productName;
// 打印时间
@property (weak, nonatomic) IBOutlet UILabel *print_time;
// 签收时间
@property (weak, nonatomic) IBOutlet UILabel *deliveryDate;

/********* 月结卡号 *********/
// 月结卡号
@property (weak, nonatomic) IBOutlet UILabel *monthCardNumber;
// 件数
@property (weak, nonatomic) IBOutlet UILabel *orderQty;
// 运费
@property (weak, nonatomic) IBOutlet UILabel *transportFee;
// 实重
@property (weak, nonatomic) IBOutlet UILabel *displayWt;
// 付款方式
@property (weak, nonatomic) IBOutlet UILabel *chargeTypes;
// 费用合计
@property (weak, nonatomic) IBOutlet UILabel *orderAmount;
// 计重
@property (weak, nonatomic) IBOutlet UILabel *chargeWeight;

/********* 附加服务 *********/
// 附加服务
@property (weak, nonatomic) IBOutlet UILabel *insuranceFee;
// 声明价值
@property (weak, nonatomic) IBOutlet UILabel *valuationMoney;
// 代收款(代收货款)
@property (weak, nonatomic) IBOutlet UILabel *collectPayment;
// 签回单
@property (weak, nonatomic) IBOutlet UILabel *returnBillFlag;
// 尺寸
@property (weak, nonatomic) IBOutlet UILabel *productSize;
// 备注
@property (weak, nonatomic) IBOutlet UILabel *remark;







// 标签号条码
@property (weak, nonatomic) IBOutlet UIImageView *barCodeImageView_2;
// 标签号
@property (weak, nonatomic) IBOutlet UILabel *productNo_2;
// 订单号条码
@property (weak, nonatomic) IBOutlet UIImageView *bottomBarCodeImageView;


/********* 寄方 *********/
// 发货联系人
@property (weak, nonatomic) IBOutlet UILabel *issuePartyContact_2;
// 发货人电话(有值则显示没有则取固话)
@property (weak, nonatomic) IBOutlet UILabel *issuePartyTel_or_issuePartyGuHua_2;
// 发货城市
@property (weak, nonatomic) IBOutlet UILabel *issuePartyCity_2;
// 发货区县 + 发货详细地址
@property (weak, nonatomic) IBOutlet UILabel *issuePartyDistricict_and_issuePartyAddr_2;

/********* 收方 *********/
// 收货联系人
@property (weak, nonatomic) IBOutlet UILabel *receivePartyContactName_2;
// 收货人电话(有值则显示没有则取固话)
@property (weak, nonatomic) IBOutlet UILabel *receivePartyPhone_or_receivePartyGuHua_2;
// 收货城市
@property (weak, nonatomic) IBOutlet UILabel *receivePartyCity_2;
// 收货区县 + 收货地址
@property (weak, nonatomic) IBOutlet UILabel *receicePartyDistricict_and_receivePartyAddr1_2;
// 订单号
@property (weak, nonatomic) IBOutlet UILabel *omsNo;
// 备注
@property (weak, nonatomic) IBOutlet UILabel *remark_2;


/********* tsuh号 *********/
@end

@implementation PrintimageTopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _barCodeImageView.image = [Tools resizeCodeWithString:_productNo_s BCSize:_barCodeImageView.frame.size];
    _productNo.text = _productNo_s;
    _qrCodeImageView.image = [Tools createQRWithString:_dic[@"omsNo"] QRSize:_qrCodeImageView.frame.size];
    
    
    
    // 寄方
    _issuePartyContact.text = _dic[@"issuePartyContact"];
    _issuePartyTel_or_issuePartyGuHua.text = [[NSString stringWithFormat:@"%@", _dic[@"issuePartyTel"]] isEqualToString:@""] ? _dic[@"issuePartyGuHua"] : _dic[@"issuePartyTel"];
    _issuePartyCity.text = _dic[@"issuePartyCity"];
    _issuePartyDistricict_and_issuePartyAddr.text = [NSString stringWithFormat:@"%@  %@", _dic[@"issuePartyDistricict"], _dic[@"issuePartyAddr"]];
    _actualPieceTime.text = _dic[@"actualPieceTime"];
    
    // 收方
    _receivePartyContactName.text = _dic[@"receivePartyContactName"];
    _receivePartyPhone_or_receivePartyGuHua.text = [[NSString stringWithFormat:@"%@", _dic[@"receivePartyPhone"]] isEqualToString:@""] ? _dic[@"receivePartyGuHua"] : _dic[@"receivePartyPhone"];
    _receivePartyCity.text = _dic[@"receivePartyCity"];
    _receicePartyDistricict_and_receivePartyAddr1.text = [NSString stringWithFormat:@"%@  %@", _dic[@"receicePartyDistricict"], _dic[@"receivePartyAddr1"]];
    
    // 货物名称
    _productName.text = _dic[@"productName"];
    _print_time.text = [Tools getDate];
    _deliveryDate.text = _dic[@"deliveryDate"];
    
    // 月结卡号
    _monthCardNumber.text = _dic[@"monthCardNumber"];
    _orderQty.text = [NSString stringWithFormat:@"%@", _dic[@"orderQty"]];
    _transportFee.text = [NSString stringWithFormat:@"%@", _dic[@"transportFee"]];
    _displayWt.text = [NSString stringWithFormat:@"%@", _dic[@"displayWt"]];
    _chargeTypes.text = [NSString stringWithFormat:@"%@", _dic[@"chargeTypes"]];
    _orderAmount.text = [NSString stringWithFormat:@"%@", _dic[@"orderAmount"]];
    _chargeWeight.text = [NSString stringWithFormat:@"%@", _dic[@"chargeWeight"]];
    
    // 附加服务
    _insuranceFee.text = [NSString stringWithFormat:@"%@", _dic[@"insuranceFee"]];
    _valuationMoney.text = [NSString stringWithFormat:@"%@", _dic[@"valuationMoney"]];
    _collectPayment.text = [NSString stringWithFormat:@"%@", _dic[@"collectPayment"]];
    _returnBillFlag.text = [NSString stringWithFormat:@"%@", _dic[@"returnBillFlag"]];
    _productSize.text = [NSString stringWithFormat:@"%@", _dic[@"productSize"]];
    _remark.text = _dic[@"remark"];
    
    
    
    
    
    
    
    
    /********* 客户联 *********/
    
    _barCodeImageView_2.image = [Tools resizeCodeWithString:_productNo_s BCSize:_barCodeImageView.frame.size];
    _productNo_2.text = _productNo_s;
    _bottomBarCodeImageView.image = [Tools resizeCodeWithString:_dic[@"omsNo"] BCSize:_barCodeImageView.frame.size];
    
    // 寄方
    _issuePartyContact_2.text = _dic[@"issuePartyContact"];
    _issuePartyTel_or_issuePartyGuHua_2.text = [[NSString stringWithFormat:@"%@", _dic[@"issuePartyTel"]] isEqualToString:@""] ? _dic[@"issuePartyGuHua"] : _dic[@"issuePartyTel"];
    _issuePartyCity_2.text = _dic[@"issuePartyCity"];
    _issuePartyDistricict_and_issuePartyAddr_2.text = [NSString stringWithFormat:@"%@  %@", _dic[@"issuePartyDistricict"], _dic[@"issuePartyAddr"]];
    
    // 收方
    _receivePartyContactName_2.text = _dic[@"receivePartyContactName"];
    _receivePartyPhone_or_receivePartyGuHua_2.text = [[NSString stringWithFormat:@"%@", _dic[@"receivePartyPhone"]] isEqualToString:@""] ? _dic[@"receivePartyGuHua"] : _dic[@"receivePartyPhone"];
    _receivePartyCity_2.text = _dic[@"receivePartyCity"];
    _receicePartyDistricict_and_receivePartyAddr1_2.text = [NSString stringWithFormat:@"%@  %@", _dic[@"receicePartyDistricict"], _dic[@"receivePartyAddr1"]];
    _omsNo.text = _dic[@"omsNo"];
    _remark_2.text = _dic[@"remark"];
}

@end
