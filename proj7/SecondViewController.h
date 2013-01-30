//
//  SecondViewController.h
//  proj7
//
//  Created by Admin on 1/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface SecondViewController : UIViewController<FirstViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) NSDictionary *searchValue;

@property(nonatomic, retain) NSArray *search_result;

@property(nonatomic, retain) IBOutlet UILabel *tempC;
    
@property(nonatomic, retain) IBOutlet UILabel *speedW;
    
@property(nonatomic, retain) IBOutlet UILabel *location;
    
@property(nonatomic, retain) IBOutlet UIImageView *imgW;
    
@property(nonatomic, retain) IBOutlet UILabel *datetime;
    
@property(nonatomic, retain) IBOutlet UILabel *wDesc;

@property(nonatomic, retain) IBOutlet UITableView *detail_table;

@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

@end
