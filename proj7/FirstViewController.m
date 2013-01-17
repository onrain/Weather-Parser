//
//  FirstViewController.m
//  proj7
//
//  Created by Admin on 1/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "FirstViewController.h"

#define search_uri @"http://www.worldweatheronline.com/feed/search.ashx?format=json&key=5198c44b43130913131401"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize search_Bar;
@synthesize searchTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSString *query = searchBar.text;
    if([query length] != 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&query=%@", search_uri, query]]];
            NSDictionary *json = nil;
            if(responseData) {
                json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
            }
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUIWithDictionary:json];
            });
        });
    }

}

-(void) updateUIWithDictionary:(NSDictionary *) json {
    @try {

       search_result = [[json objectForKey:@"search_api"] objectForKey:@"result"];

    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Could not parse the JSON feed."
                                   delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles: nil] show];
        NSLog(@"Exception: %@", exception);
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%i", [search_result count]);
    return [search_result count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Resault search"];
        
    cell.textLabel.text = @"Hello amigos!";
    
    return cell;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
