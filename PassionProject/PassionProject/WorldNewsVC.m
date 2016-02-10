//
//  WorldNewsVC.m
//  PassionProject
//
//  Created by C4Q on 2/8/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

#import "WorldNewsVC.h"
#import <AFNetworking/AFNetworking.h>
#import <RPSlidingMenu/RPSlidingMenu.h>

@interface WorldNewsVC ()
@property(nonatomic)NSString *titleString;
@property(nonatomic)NSString *snippetText;
@property(nonatomic)NSString *dateString;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation WorldNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //possible heading for navigation bar
//    self.navigationController.navigationBar.topItem.title = @"Trending";
//    
//    [[UINavigationBar appearance] setTitleTextAttributes: @{
//                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                            NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:17.0f]}];
    
    //RPSliding Menu
    self.featureHeight = 200.0f;
    self.collapsedHeight = 100.0f;
    
    [self nprJson]; 
}

#pragma mark- API call

-(void)nprJson {
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

[manager GET:@"http://api.npr.org/query?id=1122,1004&fields=title,teaser,storyDate,text,image&requiredAssets=text&dateType=story&output=JSON&numResults=10&apiKey=MDIyNTg2ODAxMDE0NTQ1OTU1NTU1N2E2Ng000"
  parameters:nil
    progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         //NSArray *posts = [responseObject objectForKey:@"data"];
         
         NSDictionary *lists = [responseObject objectForKey:@"list"];
         
         NSArray *posts = [lists objectForKey:@"story"];
         
         for (NSDictionary *post in posts) {
             
             //Story Title
             NSDictionary *title = [post objectForKey:@"title"];
             self.titleString = [title objectForKey:@"$text"];
             NSLog(@"%@", self.titleString);
             
             //Story Snippet
             NSDictionary *snippet = [post objectForKey:@"teaser"];
             self.snippetText = [snippet objectForKey:@"$text"];
             NSLog(@"%@", self.snippetText);
             
             //Story Date
             NSDictionary *storyDate = [post objectForKey:@"storyDate"];
             self.dateString = [storyDate objectForKey:@"$text"];
             NSLog(@"%@", self.dateString);
             
         }
         
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"%@", error.userInfo);
         
     }];

}


#pragma mark- MDMenuViewController
//
//-(NSString*)titleForChildControllerMDMenuViewController:(MDMenuViewController*)menuController {
//     return @"World News";
//}
//
//-(NSString*)iconForChildControllerMDMenuViewController:(MDMenuViewController*)menuController {
//    return @"concept-icon-poster60.png";
//}




#pragma mark - RPSlidingMenuViewController


-(NSInteger)numberOfItemsInSlidingMenu{
    return 10;
}

- (void)customizeCell:(RPSlidingMenuCell *)slidingMenuCell forRow:(NSInteger)row{
    
        slidingMenuCell.textLabel.text = self.titleString;
    slidingMenuCell.textLabel.textColor = [UIColor blackColor];
    
        slidingMenuCell.detailTextLabel.text = self.snippetText;
        slidingMenuCell.backgroundImageView.image = [UIImage imageNamed:@"grayBackground"];

}

- (void)slidingMenu:(RPSlidingMenuViewController *)slidingMenu didSelectItemAtRow:(NSInteger)row{
    
    [super slidingMenu:slidingMenu didSelectItemAtRow:row];
    
    self.featureHeight = 250.0f;
    self.collapsedHeight = 120.0f;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
