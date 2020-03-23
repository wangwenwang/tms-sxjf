//
//  CheckOrderPathViewController.m
//  Order
//
//  Created by 凯东源 on 16/10/20.
//  Copyright © 2016年 凯东源. All rights reserved.
//

#import "CheckOrderPathViewController.h"
#import "CheckPathService.h"
#import "Tools.h"
#import "RouteAnnotation.h"
#import "LocationModel.h"

@interface CheckOrderPathViewController ()<BMKMapViewDelegate, BMKRouteSearchDelegate, CheckPathServiceDelegate> {
    
    /// 查看订单线路业务类
    CheckPathService *_service;
    
    /// 订单线路长度
    int _orderPathDistance;
    
    // 规划路线 10个点一批 判断是否最后一批
    BOOL _pathPointLast;
    
    /// 已经规划完路线的位置点
    int _startSearchPoint;
    
    /// 已经规划完路线的位置点
    int _startSearchPoint1;
    
    /// 是否是让地图缩放到包含线路
    BOOL _isJustFitMapWithPolyLine;
    
    /// 百度地图查询路线
    BMKRouteSearch *_routeSearch;
    
    /// 统计路线长度时在位置点集合中的脚标
    int _pointIdex;
}

/// 百度地图控件
@property (weak, nonatomic) IBOutlet BMKMapView *mapViwe;

// 路线距离
@property (weak, nonatomic) IBOutlet UILabel *pathDistanceField;

@end

@implementation CheckOrderPathViewController

#pragma mark - 事件

- (IBAction)exitOnclick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 生命周期
- (instancetype)init {
    if(self = [super init]) {
        _orderIDX = @"";
        _orderPathDistance = 0;
        _startSearchPoint = 0;
        _service = [[CheckPathService alloc] init];
        _service.delegate = self;
        _isJustFitMapWithPolyLine = YES;
        _mapViwe.zoomLevel = 10;
        _routeSearch = [[BMKRouteSearch alloc] init];
        _pointIdex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单路线";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapViwe viewWillAppear];
    _mapViwe.delegate = self;
    _routeSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapViwe viewWillDisappear];
    _mapViwe.delegate = nil;
    _routeSearch.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark -- BMKMapViewDelegate
/// 百度地图初始化完成
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //判断连接状态
    if([Tools isConnectionAvailable]) {
        [_service getOrderLocaltions:_orderIDX];
    }else {
        [Tools showAlert:self.view andTitle:@"网络连接不可用!"];
    }
}

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetRidingRouteResult:%u", error);
    
    //    NSMutableArray *ridingroute = [result.routes mutableCopy];
    //    if(error == BMK_SEARCH_NO_ERROR) {
    //        if(ridingroute.count > 0) {
    //            [ridingroute removeObjectAtIndex:0];
    //            for (int i = 0; i < ridingroute.count; i++) {
    //                _orderPathDistance += ridingroute
    //                BMKRidingRouteLine *ridingroute = array[i];
    //                _orderPathDistance += ridingroute.distance;
    //
    //            }
    //            //            if() {
    //            //
    //            //            }
    //        }
    //    }
}

/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKDrivingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"获取驾车路线成功发挥结果");
    NSLog(@"onGetDrivingRouteResult: %u", error);
    
    if(error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine *plan = result.routes[0];
        NSInteger size = plan.steps.count;
        unsigned int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep *transitStep = plan.steps[i];
            
            //            NSLog(@"sizesizesize:%ld, planPointCounts:%d", (long)size, planPointCounts);
            
            // 添加 annotation 节点
            RouteAnnotation *item = [[RouteAnnotation alloc] init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapViwe addAnnotation:item];
            
            // 轨迹点总数累计
            planPointCounts = transitStep.pointsCount + planPointCounts;
        }
        
        // 轨迹点
        BMKMapPoint tempPoints [planPointCounts];
        memset(tempPoints, 0, sizeof(tempPoints));
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep *transitStep = plan.steps[j];
            for (int k = 0; k < transitStep.pointsCount; k++) {
                tempPoints[i].x = transitStep.points[k].x;
                tempPoints[i].y = transitStep.points[k].y;
                i += 1;
            }
        }
        
        // 通过 points 构建 BMKPolyline
        BMKPolyline *polyLine = [BMKPolyline polylineWithPoints:tempPoints count:planPointCounts];
        
        // 添加路线 overlay
        if(_isJustFitMapWithPolyLine) {
            
            [self mapViewFitPolyLine:polyLine];
            _isJustFitMapWithPolyLine = NO;
            NSLog(@"缩放地图");
        } else {
            
            [_mapViwe addOverlay:polyLine];
            
            // 统计总距离
            _orderPathDistance = _orderPathDistance + plan.distance;
            CGFloat distance = _orderPathDistance / 1000.0;
            if(_pathPointLast) {
                
                _pathDistanceField.text = [NSString stringWithFormat:@"路线长度：%.1f公里", distance];
            } else  {
                
                _pathDistanceField.text = [NSString stringWithFormat:@"路线长度：%.1f公里 统计中...", distance];
            }
        }
        //递归回调
        [self searchDrivingPath];
    }else {
        [Tools showAlert:self.view andTitle:@"获取线路失败！"];
    }
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    RouteAnnotation *routeAnnotation = annotation;
    if(routeAnnotation) {
        return [self getViewForRouteAnnotation:routeAnnotation];
    }else {
        return nil;
    }
}

/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if(overlay != nil) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 3;
        return polylineView;
    }else {
        return nil;
    }
}

#pragma mark -- 功能函数

/// 根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *)polyline {
    if(polyline.pointCount < 1) {
        return;
    }
    
    BMKMapPoint pt = polyline.points[0];
    double ltX = pt.x;
    double rbX = pt.x;
    double ltY = pt.y;
    double rbY = pt.y;
    
    for (int i = 1; i < polyline.pointCount; i++) {
        BMKMapPoint pt = polyline.points[i];
        if(pt.x < ltX) {
            ltX = pt.x;
        }
        if(pt.x > rbX) {
            rbX = pt.x;
        }
        if(pt.y > ltY) {
            ltY = pt.y;
        }
        if(pt.y < rbY) {
            rbY = pt.y;
        }
    }
    //没补全
    BMKMapRect rect = BMKMapRectMake(ltX, ltY, rbX - ltX, rbY - ltY);
    _mapViwe.visibleMapRect = rect;
    _mapViwe.zoomLevel = _mapViwe.zoomLevel - 0.3;
}

/**
 * 旋转图片
 *
 * image: 需要旋转的图片
 *
 * degrees: 旋转的角度
 *
 * return 旋转后的图片
 */
- (UIImage *)imageRotated:(UIImage *)image andDegress:(int)degrees {
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    CGSize rotatedSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);
    CGContextRotateCTM(bitmap, (float)(degrees * M_PI / 180.0));
    CGContextRotateCTM(bitmap, (float)M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width / 2, -rotatedSize.height / 2, rotatedSize.width, rotatedSize.height), image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
    
}

/**
 * 根据 RouteAnnotation 的类型获取对应的图标
 *
 * routeAnnotation: RouteAnnotation
 *
 * return 对应类型的图标
 */
- (BMKAnnotationView *)getViewForRouteAnnotation:(RouteAnnotation *)routeAnnotation {
    BMKAnnotationView *view = nil;
    
    NSString *imageName = nil;
    switch (routeAnnotation.type) {
        case 0: imageName = @"nav_start"; break;
        case 1: imageName = @"nav_end"; break;
        case 2: imageName = @"nav_bus"; break;
        case 3: imageName = @"nav_rail"; break;
        case 4: imageName = @"direction"; break;
        case 5: imageName = @"nav_waypoint"; break;
        default:
            break;
    }
    NSString *identifier = [NSString stringWithFormat:@"%@_annotation", imageName];
    view = [_mapViwe dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(view == nil) {
        view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:identifier];
        view.centerOffset = CGPointMake(0, -(CGRectGetHeight(view.frame) * 0.5));
        view.canShowCallout = YES;
        
    }
    view.annotation = routeAnnotation;
    
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/mapapi.bundle/"];
    NSBundle *bundle = [[NSBundle alloc] initWithPath:bundlePath];
    NSString *imagePath = [[bundle resourcePath] stringByAppendingString:[NSString stringWithFormat:@"/images/icon_%@.png", imageName]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if(routeAnnotation.type == 4) {
        image = [self imageRotated:image andDegress:routeAnnotation.degree];
    }
    if(image != nil) {
        view.image = image;
    }
    return view;
}

/**
 * 添加起点和终点图标
 *
 * start: 起点位置
 *
 * end： 终点位置
 */
- (void)addStartAndEndPointMark:(LocationModel *)start andEnd:(LocationModel *)end {
    RouteAnnotation *startItem = [[RouteAnnotation alloc] init];
    startItem.coordinate = CLLocationCoordinate2DMake(start.CORDINATEY, start.CORDINATEX);
    startItem.title = @"起点";
    startItem.type = 0;
    [_mapViwe addAnnotation:startItem];  // 添加起点标注
    
    RouteAnnotation *endItem = [[RouteAnnotation alloc] init];
    endItem.coordinate = CLLocationCoordinate2DMake(end.CORDINATEY, end.CORDINATEX);
    endItem.title = @"终点";
    endItem.type = 1;
    [_mapViwe addAnnotation:endItem];  // 添加终点标注
}

/**
 * 搜索架车路线
 */
- (void)searchDrivingPath {
    NSMutableArray *points = _service.orderLocations;
    NSInteger pointsSize = points.count;
    if(_startSearchPoint1 >= pointsSize - 2) {
        return;
    }
    
    //声明变量
    BMKPlanNode *from = [[BMKPlanNode alloc] init];
    BMKPlanNode *to = [[BMKPlanNode alloc] init];
    NSMutableArray *passBys = [[NSMutableArray alloc] init];
    //用11个点缩放地图，起、途中9个点、终
    if(_isJustFitMapWithPolyLine) {
        //起点
        LocationModel *startPoint = points[0];
        //途中
        CGFloat i = 0.1;
        while (i <= 0.9) {
            CGFloat count = points.count;
            BMKPlanNode *passBy = [[BMKPlanNode alloc] init];
            int j = count * i;
            LocationModel *passByLocalPoint = points[j];
            passBy.pt = CLLocationCoordinate2DMake(passByLocalPoint.CORDINATEY, passByLocalPoint.CORDINATEX);
            [passBys addObject:passBy];
            i += 0.1;
        }
        //终点
        LocationModel *endPoint = points[points.count - 1];
        from.pt = CLLocationCoordinate2DMake(startPoint.CORDINATEY, startPoint.CORDINATEX);
        to.pt = CLLocationCoordinate2DMake(endPoint.CORDINATEY, endPoint.CORDINATEX);
    } else {
        //检出本途中点个数
        int fori = 0;
        if((points.count - _startSearchPoint1 - 2) > 10) {
            fori = 10;
        } else {
            fori = (int)points.count - _startSearchPoint1 - 2;
            _pathPointLast = YES;
        }
        
        //起点
        LocationModel *startPoint = points[_startSearchPoint1];
        //途中
        for (int i = 0; i < fori; i++) {
            _startSearchPoint1 += 1;
            BMKPlanNode *passBy = [[BMKPlanNode alloc] init];
            LocationModel *passByLocalPoint = points[_startSearchPoint1];
            passBy.pt = CLLocationCoordinate2DMake(passByLocalPoint.CORDINATEY, passByLocalPoint.CORDINATEX);
            [passBys addObject:passBy];
        }
        //终点
        LocationModel *endPoint = points[_startSearchPoint1 + 1];
        
        from.pt = CLLocationCoordinate2DMake(startPoint.CORDINATEY, startPoint.CORDINATEX);
        to.pt = CLLocationCoordinate2DMake(endPoint.CORDINATEY, endPoint.CORDINATEX);
    }
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc] init];
    drivingRouteSearchOption.from = from;
    drivingRouteSearchOption.wayPointsArray = passBys;
    drivingRouteSearchOption.to = to;
    drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE;
    
    BOOL flag = [_routeSearch drivingSearch:drivingRouteSearchOption];
    if(flag) {
        NSLog(@"驾乘检索发送成功");
    } else {
        NSLog(@"驾乘检索发送失败");
        [Tools showAlert:self.view andTitle:@"规划失败!"];
    }
}

/// 获取订单线路长度
- (void)getOrderPathDiatance {
    NSMutableArray *points = _service.orderLocations;
    if(_pointIdex > (points.count - 2)) {
        NSLog(@"路线长度：%f公里", _orderPathDistance / 1000.0);
        return;
    }
    LocationModel *startPoint = points[_pointIdex];
    LocationModel *endPoint = points[_pointIdex + 1];
    BMKRidingRoutePlanOption *ridingRouteSearchOption = [[BMKRidingRoutePlanOption alloc] init];
    
    BMKPlanNode *from = [[BMKPlanNode alloc] init];
    CLLocationCoordinate2D fromCoordinated = CLLocationCoordinate2DMake(startPoint.CORDINATEY, startPoint.CORDINATEX);
    from.pt = fromCoordinated;
    
    BMKPlanNode *to = [[BMKPlanNode alloc] init];
    CLLocationCoordinate2D toCoordinated = CLLocationCoordinate2DMake(endPoint.CORDINATEY, endPoint.CORDINATEX);
    to.pt = toCoordinated;
    
    ridingRouteSearchOption.from = from;
    ridingRouteSearchOption.to = to;
    BOOL ridingFlag = [_routeSearch ridingSearch:ridingRouteSearchOption];
    if(ridingFlag) {
        NSLog(@"骑行检索发送成功");
    }else {
        NSLog(@"骑行检索发送失败");
    }
}

#pragma mark -- CheckPathServiceDelegate
/// 获取订单线路位置集合成功
- (void)success {
    NSMutableArray *points = _service.orderLocations;
    
    if(points.count > 2) {
        if(points.count > 0) {
            [self addStartAndEndPointMark:points[0] andEnd:points[points.count - 1]];
        }
        [self searchDrivingPath];
    } else {
        
        [Tools showAlert:self.view andTitle:[NSString stringWithFormat:@"定位点个数为%ld,小于3个点不能规划线路",(long)points.count] andTime:2.5];
    }
}

- (void)failure:(NSString *)msg {
    [Tools showAlert:self.view andTitle:msg ? msg : @"获取线路失败"];
}



@end
