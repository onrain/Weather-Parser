//
//  SecondViewController.m
//  proj7
//
//  Created by Admin on 1/17/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "SecondViewController.h"
#define meteo_uri @"http://free.worldweatheronline.com/feed/weather.ashx?format=json&num_of_days=2&key=5198c44b43130913131401"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"About", @"About");
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
    // Release any retained subviews of the main view.
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
        });
    });
}

-(void) updateUIWithDictionary:(NSDictionary *) json {

    NSString *tC = [[[[json objectForKey:@"data" ] objectForKey:@"current_condition"] objectAtIndex:0] valueForKey:@"temp_C"];
    NSString *tF = [[[[json objectForKey:@"data" ] objectForKey:@"current_condition"] objectAtIndex:0] valueForKey:@"temp_F"];
    NSString *WSpeed = [[[[json objectForKey:@"data" ] objectForKey:@"current_condition"] objectAtIndex:0] valueForKey:@"windspeedKmph"];
    NSString *city = [[[[json objectForKey:@"data" ] valueForKey:@"request"] objectAtIndex:0] objectForKey:@"query"];
        
    NSString *dTime = [[[[json objectForKey:@"data" ] valueForKey:@"weather"] objectAtIndex:0] objectForKey:@"date"];
        
    NSString *image_url = [[[[[[json objectForKey:@"data" ] objectForKey:@"current_condition"] objectAtIndex:0] objectForKey:@"weatherIconUrl"] objectAtIndex:0] objectForKey:@"value"];

        
    NSURL *url = [NSURL URLWithString:image_url];
        
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    image = [self imageWithBorderFromImage:image];
        
    [imgW setImage:image];
        
    tempC.text = [NSString stringWithFormat:@"С: %@", tC];
    tempF.text = [NSString stringWithFormat:@"F: %@", tF];
    speedW.text = [NSString stringWithFormat:@"Wind speed: %@ km", WSpeed];
    location.text = [NSString stringWithFormat:@"%@", city];
    datetime.text = [NSString stringWithFormat:@"%@", dTime];
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
