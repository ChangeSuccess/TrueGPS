//
//  ViewController.m
//  TrueGPS
//
//  Created by km on 2018/9/26.
//  Copyright © 2018年 ly. All rights reserved.
//

#import "ViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationmanager;//定位服务
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController
@synthesize locationmanager;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLocation];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    self.mapView.showsUserLocation = YES;
    [self.mapView setRegion:MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            
            /*看需求定义一个全局变量来接收赋值*/
            NSLog(@"----%@",placeMark.country);//当前国家
            NSLog(@"%@",currentCity);//当前的城市
            
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
