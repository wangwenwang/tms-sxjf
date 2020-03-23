//
//  PrintViewController.m
//  tms-ios
//
//  Created by wangww on 2020/3/16.
//  Copyright © 2020 wangziting. All rights reserved.
//

#import "PrintViewController.h"
#import "PrintTableViewCell.h"
#import "Tools.h"
#import "PrintimageTopViewController.h"

@interface PrintViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) Bluetooth* bluetooth;
@property (strong, nonatomic) CBPeripheral* peripheral;
@property (strong, nonatomic) NSMutableArray* listDevices;
@property (strong, nonatomic) NSMutableString* listDeviceInfo;

@end

@implementation PrintViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.listDeviceInfo = [NSMutableString stringWithString:@""];
    self.listDevices = [NSMutableArray array];
    self.bluetooth = [[Bluetooth alloc]init];
    
    [self connDevice];
}


#pragma mark - 功能函数

- (void)registCell {
    
    [_myTableView registerNib:[UINib nibWithNibName:@"PrintTableViewCell" bundle:nil] forCellReuseIdentifier:@"PrintTableViewCell"];
}

#pragma mark - 事件

- (IBAction)exitOnclick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)connDevice{
    if(_listDevices != nil){
        _listDevices = nil;
        _listDevices = [NSMutableArray array];
        [_myTableView reloadData];
    }
    
    BLOCK_CALLBACK_SCAN_FIND callback = ^( CBPeripheral*peripheral){
        
        if(self.listDevices.count == 0){
            [self.listDevices addObject:peripheral];
        }
        
        // 设备去重
        int kk = 0;
        for(int i = 0; i < _listDevices.count; i++){
            
            NSString *uuid = [NSString stringWithFormat:@"%@", [[_listDevices objectAtIndex:i] identifier]];
            uuid = [uuid substringFromIndex:[uuid length] - 13];
            
            NSString *udx = [NSString stringWithFormat:@"%@", [peripheral identifier]];
            udx = [udx substringFromIndex:[udx length] - 13];
            if([uuid isEqualToString:udx]){
                
                kk++;
            }
        }
        if(kk == 0){
            [self.listDevices addObject:peripheral];
            [_myTableView reloadData];
        }
    };
    
    [self.bluetooth scanStart:callback];
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds* NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.bluetooth scanStop];
    });
}

- (void)calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 1.0);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"image = %.3f %@",dataLength,typeArray[index]);
}


- (IBAction)print{
    
    for(int i = 0; i < _arr.count; i++){
        
        PrintimageTopViewController *vc = [[PrintimageTopViewController alloc] init];
        vc.productNo_s = _arr[i][@"productNo"];
        vc.dic = _dic;
        UIView *view = vc.view;
        UIImage *image3 = [Tools tg_makeImageWithView:view withSize:view.frame.size];
        
        [self calulateImageFileSize:image3];
        
        //    [self presentViewController:vc animated:YES completion:nil];
        
        if(self.peripheral){
            
            [self.bluetooth open:self.peripheral];
            [self.bluetooth flushRead];
            [self.bluetooth DrawBigBitmap:image3 gotopaper:0];
            [self.bluetooth print_status_detect];
            
            int status=[self.bluetooth print_status_get:3000];
            if(status==1){
                NSLog(@"打印机缺纸");
            }
            if(status==2){
                NSLog(@"打印机开盖");
            }
        }else{
            
            [Tools showAlert:self.view andTitle:@"请选择打印机"];
        }
    }
    //    [self.bluetooth close];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     
    return self.listDevices.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString  *CellIdentiferId = @"PrintTableViewCellid";
    PrintTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"PrintTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        
        // name
        cell.nameLabel.text = [[_listDevices objectAtIndex:indexPath.row] name];
        // uuid
        NSString* uuid = [NSString stringWithFormat:@"%@", [[_listDevices objectAtIndex:indexPath.row] identifier]];
        uuid = [uuid substringFromIndex:[uuid length] - 13];
        cell.uuidLabel.text = uuid;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.peripheral =[_listDevices objectAtIndex:indexPath.row];
}

@end
