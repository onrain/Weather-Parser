//
//  SecondViewController.m
//  proj7
//
//  Created by Admin on 1/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "SecondViewController.h"
#define meteo_uri @"http://free.worldweatheronline.com/feed/weather.ashx?format=json&key=5198c44b43130913131401&num_of_days=3"
@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize detail_table, tempC, speedW, location, imgW, datetime, wDesc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Details", @"Details");
        self.tabBarItem.image = [UIImage imageNamed:@"s"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	FirstViewController *first = [self.tabBarController.viewControllers objectAtIndex:0];
    first.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)passendLocationDate:(FirstViewController *)controller data:(NSString *)locationDate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&q=%@",    meteo_uri, locationDate]]];
        NSDictionary *json = nil;
        if(responseData) {
            json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithDictionary:json];
            [detail_table reloadData];
        });
    });
}

-(void) updateUIWithDictionary:(NSDictionary *) json {
    
    search_result = [[json objectForKey:@"data"] objectForKey:@"weather"];
    NSURL *url = [NSURL URLWithString:
                  [[[[[[json objectForKey:@"data" ] objectForKey:@"current_condition"] objectAtIndex:0] objectForKey:@"weatherIconUrl"] objectAtIndex:0] objectForKey:@"value"]];
        
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    image = [self imageWithBorderFromImage:image];
    [imgW setImage:image];
     
    tempC.text = [NSString stringWithFormat:@"%@ °",
                  [[[[json objectForKey:@"data" ] objectForKey:@"current_condition"] objectAtIndex:0] valueForKey:@"temp_C"]];
    
    speedW.text = [NSString stringWithFormat:@"Wind speed: %@ km",
                   [[[[json objectForKey:@"data" ] objectForKey:@"current_condition"] objectAtIndex:0] valueForKey:@"windspeedKmph"]];
        
    location.text = [NSString stringWithFormat:@"%@",
                     [[[[json objectForKey:@"data" ] valueForKey:@"request"] objectAtIndex:0] objectForKey:@"query"]];
    
    datetime.text = [NSString stringWithFormat:@"%@",
                     [[[[json objectForKey:@"data" ] valueForKey:@"weather"] objectAtIndex:0] objectForKey:@"date"]];
    
    wDesc.text = [NSString stringWithFormat:@"%@",
                    [[[[[[json objectForKey:@"data" ] objectForKey:@"current_condition"] objectAtIndex:0] objectForKey:@"weatherDesc"] objectAtIndex:0] objectForKey:@"value"]];
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [search_result count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RecipeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(search_result) {
        NSString *minC = [[search_result objectAtIndex:indexPath.row] valueForKey:@"tempMinC"];
        NSString *maxC = [[search_result objectAtIndex:indexPath.row] valueForKey:@"tempMaxC"];
        NSString *date = [[search_result objectAtIndex:indexPath.row] valueForKey:@"date"];
        NSString *desc = [[[[search_result objectAtIndex:indexPath.row] objectForKey:@"weatherDesc"] objectAtIndex:0] valueForKey:@"value"];
        NSString *image_url = [[[[search_result objectAtIndex:indexPath.row] objectForKey:@"weatherIconUrl"] objectAtIndex:0] valueForKey:@"value"];    
        NSURL *url = [NSURL URLWithString:image_url];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        image = [self imageWithBorderFromImage:image];
        NSString *result = [NSString stringWithFormat:@"min %@ max %@ \n%@ %@", minC, maxC, desc, date];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = result;
        cell.textLabel.lineBreakMode = YES;
        cell.imageView.image = image;
    }
    return cell;
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 102.0, 102.0, 102.0, 1.0);
    CGContextStrokeRect(context, rect);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return testImg;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
