//
//  PhotosViewController.m
//  Tumblr
//
//  Created by Alex Oseguera on 6/25/20.
//  Copyright © 2020 Alex Oseguera. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *posts;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 286;
    [self fetchPosts];
}

-(void)fetchPosts {
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *responseDictionary = dataDictionary[@"response"];
                self.posts = responseDictionary[@"posts"];
                [self.tableView reloadData];
            }
        }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    NSDictionary *post = self.posts[indexPath.row];
    
    NSArray *photos = post[@"photos"];
    if(photos){
        NSDictionary *photo = photos[0];
        NSArray *altSizes =  photo[@"alt_sizes"];
        NSDictionary *smallSize = altSizes[6];
        NSString *urlString = smallSize[@"url"];
        NSURL *url = [NSURL URLWithString:urlString];
        
        [cell.postPicView setImageWithURL:url];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
