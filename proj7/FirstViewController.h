//
//  FirstViewController.h
//  proj7
//
//  Created by Admin on 1/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UISearchBarDelegate, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *search_result;
    UILabel *emptySearch;
}

@property(nonatomic, retain) IBOutlet UITableView *searchTable;

@property(nonatomic, retain) IBOutlet UISearchBar *search_Bar;

@end
