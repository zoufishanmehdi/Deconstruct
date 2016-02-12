//
//  WorldNewsVC.m
//  PassionProject
//
//  Created by C4Q on 2/8/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

#import "WorldNewsVC.h"
#import "WorldNewsData.h"
#import <AFNetworking/AFNetworking.h>
#import <RPSlidingMenu/RPSlidingMenu.h>
#import "LeftViewController.h"
#import <LGSideMenuController/LGSideMenuController.h>

@interface WorldNewsVC ()

//@property(nonatomic)NSString *titleString;
//@property(nonatomic)NSString *snippetText;
//@property(nonatomic)NSString *dateString;
@property (nonatomic) WorldNewsData *data;
@property (nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) LeftViewController *leftViewController;

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
//    self.featureHeight = 200.0f;
//    self.collapsedHeight = 100.0f;
    
    [self nprJson]; 
}

//#pragma mark- BreakingBad API call
//-(void)nprJson {
//
//    NSString *url = [NSString stringWithFormat:@"http://api.npr.org/query?id=1122,1004&fields=title,teaser,storyDate,text,image&requiredAssets=text&dateType=story&output=JSON&numResults=10&apiKey=MDIyNTg2ODAxMDE0NTQ1OTU1NTU1N2E2Ng000"];
//    
//    NSString *encodedString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    
//    
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
//    
//    [manager GET:encodedString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//
//         //NSArray *posts = [responseObject objectForKey:@"data"];
//
//         NSDictionary *lists = [responseObject objectForKey:@"list"];
//
//         NSArray *posts = [lists objectForKey:@"story"];
//         
//        self.searchResults = [[NSMutableArray alloc] init];
//
//         for (NSDictionary *post in posts) {
//             
//             // create new post from json
//             WorldNewsData *data = [[WorldNewsData alloc] initWithJSON:post];
//             // add post to array
//             [self.searchResults addObject:data];
//             NSLog(@"This is the world news data: %@",data);
//         }
//        
//         NSLog(@"%@", lists);
//         
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"Error: %@", error.localizedDescription);
//        // block();
//    }];
//}

-(void)nprJson {
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

[manager GET:@"http://api.npr.org/query?id=1122,1004&fields=title,teaser,storyDate,text,image&requiredAssets=text&dateType=story&output=JSON&numResults=10&apiKey=MDIyNTg2ODAxMDE0NTQ1OTU1NTU1N2E2Ng000"
  parameters:nil
    progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         //NSArray *posts = [responseObject objectForKey:@"data"];
         
         NSDictionary *lists = [responseObject objectForKey:@"list"];
         
         NSArray *posts = [lists objectForKey:@"story"];
         
         self.searchResults = [[NSMutableArray alloc] init];
         
         for (NSDictionary *post in posts) {
             
             //Story Title
             NSDictionary *title = [post objectForKey:@"title"];
             NSString * titleString = [title objectForKey:@"$text"];
             NSLog(@"%@", titleString);
             
             //Story Snippet
             NSDictionary *snippet = [post objectForKey:@"teaser"];
             NSString *snippetText = [snippet objectForKey:@"$text"];
             NSLog(@"%@", snippetText);
             
             //Story Date
             NSDictionary *storyDate = [post objectForKey:@"storyDate"];
             NSString *dateString = [storyDate objectForKey:@"$text"];
             NSLog(@"%@", dateString);
             
             //create new post from json
//             WorldNewsData *data = [[WorldNewsData alloc] initWithJSON:post];
//             // add post to array
//             [self.searchResults addObject:data];
//             NSLog(@"This is the world news data: %@",data);
             
             WorldNewsData *data = [[WorldNewsData alloc] init];
             data.titleString = titleString;
             data.snippetText = snippetText;
             data.dateString = dateString;

              [self.searchResults addObject:data];
         }
         
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"%@", error.userInfo);
         
     }];

}

#pragma mark- LGSideMenuController
//- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
//                         presentationStyle:(LGSideMenuPresentationStyle)style
//                                      type:(NSUInteger)type
//{
////    self = [super initWithRootViewController:rootViewController];
////    if (self)
////    {
////        _type = type;
//    
//        // -----
//        
//        _leftViewController = [LeftViewController new];


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

    
    WorldNewsData *data = self.searchResults[row];

    slidingMenuCell.textLabel.text = data.titleString;
    NSLog(@"%@", data.titleString);
    slidingMenuCell.textLabel.textColor = [UIColor blackColor];
    
        slidingMenuCell.detailTextLabel.text = data.snippetText;
     NSLog(@"%@", data.snippetText);
        slidingMenuCell.backgroundImageView.image = [UIImage imageNamed:@"grayBackground"];

}

- (void)slidingMenu:(RPSlidingMenuViewController *)slidingMenu didSelectItemAtRow:(NSInteger)row{
    
    [super slidingMenu:slidingMenu didSelectItemAtRow:row];
    
    self.featureHeight = 240.0f;
    self.collapsedHeight = 110.0f;
    
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
