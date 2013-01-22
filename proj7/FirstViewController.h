//
//  FirstViewController.h
//  proj7
//
//  Created by Admin on 1/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class FirstViewController;

@protocol FirstViewControllerDelegate <NSObject>

-(void) passendLocationDate:(FirstViewController *) controller data:(NSString *) locationDate;

@end

@interface FirstViewController : UIViewController<UISearchBarDelegate, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
{
    __weak id <FirstViewControllerDelegate> delegate;
    NSArray *search_result;
    UILabel *emptySearch;

    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

-(IBAction)closeKey:(id)sender;

@property(nonatomic, retain) IBOutlet UITableView *searchTable;

@property(nonatomic, retain) IBOutlet UISearchBar *search_Bar;

@property(nonatomic, retain) IBOutlet UIBarButtonItem *closeSearch;

@property(weak, nonatomic) id<FirstViewControllerDelegate> delegate;

- (IBAction)getCurrentLocation:(id)sender;

@end
