//
//  LM_alert.m
//  CMDriver
//
//  Created by 凯东源 on 17/2/6.
//  Copyright © 2017年 城马联盟. All rights reserved.
//

#import "LM_alert.h"
#import <objc/runtime.h>

const char *KLMAlertViewIndexBlock = "LMAlertViewIndexBlock";
const char *KLMAlertViewOkBlock = "LMAlertViewOkBlock";
const char *KLMAlertViewCancelBlock = "LMAlertViewCancelBlock";

@interface UIAlertView(CHAlertView)

@property (nonatomic,copy)LMAlertViewClickedWithIndex indexBlock;
@property (nonatomic,copy)LMAlertViewOkClicked okBlock;
@property (nonatomic,copy)LMAlertViewCancelClicked cancelBlock;

@end

@implementation UIAlertView(CHAlertView)

- (void)setIndexBlock:(LMAlertViewClickedWithIndex)indexBlock{
    objc_setAssociatedObject(self, KLMAlertViewIndexBlock, indexBlock, OBJC_ASSOCIATION_COPY);
}
- (LMAlertViewClickedWithIndex)indexBlock{
    return objc_getAssociatedObject(self, KLMAlertViewIndexBlock);
}

- (void)setOkBlock:(LMAlertViewOkClicked)okBlock{
    objc_setAssociatedObject(self, KLMAlertViewOkBlock, okBlock, OBJC_ASSOCIATION_COPY);
}
- (LMAlertViewOkClicked)okBlock{
    return objc_getAssociatedObject(self, KLMAlertViewOkBlock);
}

- (void)setCancelBlock:(LMAlertViewCancelClicked)cancelBlock{
    objc_setAssociatedObject(self, KLMAlertViewCancelBlock, cancelBlock, OBJC_ASSOCIATION_COPY);
}
-(LMAlertViewCancelClicked)cancelBlock{
    return objc_getAssociatedObject(self, KLMAlertViewCancelBlock);
}

@end

@interface LM_alert ()<UIAlertViewDelegate>

@end

@implementation LM_alert

#pragma mark -
+ (void)showLMAlertViewWithTitle:(NSString *)title message:(NSString *)msg cancleButtonTitle:(NSString *)cancelTitle okButtonTitle:(NSString *)okTitle otherButtonTitleArray:(NSArray*)otherTitleArray clickHandle:(LMAlertViewClickedWithIndex) handle{
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:handle ? self : nil cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    if (handle) {
        alert.indexBlock = handle;
    }
    for (NSString *otherTitle in otherTitleArray) {
        [alert addButtonWithTitle:otherTitle];
    }
    [alert show];
}

#pragma mark -
+ (void)showLMAlertViewWithTitle:(NSString *)title message:(NSString *)msg cancleButtonTitle:(NSString *)cancelTitle okButtonTitle:(NSString *)okTitle okClickHandle:(LMAlertViewOkClicked)okHandle cancelClickHandle:(LMAlertViewCancelClicked)cancelClickHandle{
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle,nil];
    if (okHandle) {
        alert.okBlock = okHandle;
    }
    if (cancelTitle) {
        alert.cancelBlock = cancelClickHandle;
    }
    [alert show];
}

#pragma mark -
+ (void)showLMAlertViewWithTitle:(NSString *)title message:(NSString *)msg cancleButtonTitle:(NSString *)cancelTitle okButtonTitle:(NSString *)okTitle otherButtonTitleArray:(NSArray*)otherTitleArray{
    [self showLMAlertViewWithTitle:title message:msg cancleButtonTitle:cancelTitle okButtonTitle:okTitle otherButtonTitleArray:otherTitleArray clickHandle:nil];
}

#pragma mark - UIAlertViewDelegate
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.indexBlock) {
        alertView.indexBlock(buttonIndex);
    }else{
        if (buttonIndex == 0) {//取消
            if (alertView.cancelBlock) {
                alertView.cancelBlock();
            }
        }else{//确定
            if (alertView.okBlock) {
                alertView.okBlock();
            }
        }
    }
}

@end
