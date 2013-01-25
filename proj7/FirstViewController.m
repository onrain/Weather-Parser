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


@synthesize search_Bar, searchTable, closeSearch, indicator, search_result;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Search", @"Searh");
        self.tabBarItem.image = [UIImage imageNamed:@"f"];
    }
    return self;
}
                        
- (void)viewDidLoad
{
    [super viewDidLoad];
    [searchTable setHidden:YES];
    indicator.hidden = YES;
    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setEnabled:NO];
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)getCurrentLocation:(id)sender {
    indicator.hidden = NO;
    [indicator startAnimating];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    indicator.hidden = YES;
    [indicator stopAnimating];
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            [self searchWithParams:placemark.locality];
            [locationManager stopUpdatingLocation];
        }
    } ];
}

-(void)dealloc {
    [locationManager release];
    [geocoder release];
    [super dealloc];
}



-(void) closeKey:(id)sender {
    [self.view endEditing:YES];
}

-(void)searchWithParams:(NSString *) query {
    indicator.hidden = NO;
    [indicator startAnimating];
    if([query length] != 0) {
        query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&query=%@", search_uri, query]]];
            NSDictionary *json = nil;
            @try {
                json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateUIWithDictionary:json];
                });
            }
            @catch (NSException *exception) {
                [searchTable setHidden:YES];
                [indicator stopAnimating];
                indicator.hidden = YES;
                emptySearch = [[UILabel alloc] initWithFrame:CGRectMake(60, 200, 200, 20)];
                emptySearch.text = @"Not found!";
                emptySearch.textAlignment = UITextAlignmentCenter;
                [self.view addSubview:emptySearch];
            }
        });
    }
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [emptySearch removeFromSuperview];
    NSString *query = searchBar.text;
    [self searchWithParams:query];
}

-(void) updateUIWithDictionary:(NSDictionary *) json {
    @try { 
        search_result = [[[json objectForKey:@"search_api"] objectForKey:@"result"] retain];
        [searchTable setHidden:NO];
        indicator.hidden = YES;
        [indicator stopAnimating];
        [searchTable reloadData];
    }
    @catch (NSException *exception) {
        [searchTable setHidden:YES];
        indicator.hidden = YES;
        [indicator stopAnimating];
        emptySearch = [[UILabel alloc] initWithFrame:CGRectMake(60, 200, 200, 20)];
        emptySearch.text = @"Not found!";
        emptySearch.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:emptySearch];
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [search_result count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    NSString *region = [[[[search_result objectAtIndex:indexPath.row] objectForKey:@"region"] objectAtIndex:0] objectForKey:@"value"];
    NSString *country = [[[[search_result objectAtIndex:indexPath.row] objectForKey:@"country"] objectAtIndex:0] objectForKey:@"value"];
    NSString *value = [[[[search_result objectAtIndex:indexPath.row] objectForKey:@"areaName"] objectAtIndex:0] objectForKey:@"value"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ / %@ / %@", value, region, country];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *value = [[[[search_result objectAtIndex:indexPath.row] objectForKey:@"areaName"] objectAtIndex:0] objectForKey:@"value"];
    NSString *country = [[[[search_result objectAtIndex:indexPath.row] objectForKey:@"country"] objectAtIndex:0] objectForKey:@"value"];
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    country = [country stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
    [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setEnabled:YES];
    [self.delegate passendLocationDate:self data:[NSString stringWithFormat:@"%@,%@", value, country]];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
