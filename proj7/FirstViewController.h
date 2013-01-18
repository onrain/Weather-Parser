//
//  FirstViewController.h
//  proj7
//
//  Created by Admin on 1/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FirstViewController;

@protocol FirstViewControllerDelegate <NSObject>

-(void) passendLocationDate:(FirstViewController *) controller data:(NSString *) locationDate;

@end

@interface FirstViewController : UIViewController<UISearchBarDelegate, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    __weak id <FirstViewControllerDelegate> delegate;
    NSArray *search_result;
    UILabel *emptySearch;
}

//-(IBAction)locationPassed:(id)sender;

@property(nonatomic, retain) IBOutlet UITableView *searchTable;

@property(nonatomic, retain) IBOutlet UISearchBar *search_Bar;

@property(weak, nonatomic) id<FirstViewControllerDelegate> delegate;

@end
