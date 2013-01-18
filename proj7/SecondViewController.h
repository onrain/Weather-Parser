//
//  SecondViewController.h
//  proj7
//
//  Created by Admin on 1/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface SecondViewController : UIViewController<FirstViewControllerDelegate>
{
    IBOutlet UILabel *tempC;
    
    IBOutlet UILabel *speedW;
    
    IBOutlet UILabel *location;
    
    IBOutlet UILabel *tempF;
    
    IBOutlet UIImageView *imgW;
    
    IBOutlet UILabel *datetime;
}
@end
