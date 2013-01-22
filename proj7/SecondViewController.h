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
{
    IBOutlet UILabel *tempC;
    
    IBOutlet UILabel *speedW;
    
    IBOutlet UILabel *location;
    
    IBOutlet UIImageView *imgW;
    
    IBOutlet UILabel *datetime;
    
    NSArray *search_result;
    
    IBOutlet UILabel *wDesc;
}

@property(nonatomic, retain) IBOutlet UITableView *detail_table;

@end
