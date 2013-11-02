//
//  UIImageView+ImageCache.m
//  ImageCache
//
//  Created by HungChun on 12/5/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+ImageCache.h"
#import "NSString+MD5Addition.h"

@implementation UIImageView (ImageCache)
-(void)ShowActivityView{
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [act startAnimating];
    [act setFrame:CGRectMake((self.frame.size.width - 20) / 2, (self.frame.size.height - 20) / 2, 20, 20)];
    [self addSubview:act];
    [act release];
}

-(void)HideActivityView{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

-(void)loadImageWithURL:(NSURL *)url{
    //背景圖設定
    self.image = [UIImage imageNamed:@"photoitem.png"];
    NSString *imgFileName = [[url absoluteString]stringFromMD5];
    NSData *data =  [self queryDiskCache:imgFileName];
    if (data) {
        if (![self checkImageCacheLifeCycle:[self getCatchPath:imgFileName]]) {
            [self CacheFile:url andFileNema:imgFileName];
        }else {
            self.image = [UIImage imageWithData:data];
        }
    }else{
        [self CacheFile:url andFileNema:imgFileName];
    }
}

-(void)CacheFile:(NSURL *)url andFileNema:(NSString *)strFileName{
    [self CacheFile:url andFileNema:strFileName andShowActivity:YES];
}

-(void)CacheFile:(NSURL *)url andFileNema:(NSString *)strFileName andShowActivity:(BOOL)isShowActivity{
    if (isShowActivity) {
        [self ShowActivityView];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imgData];
        UIGraphicsBeginImageContext(self.frame.size);
        [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [imgData writeToFile:[self getCatchPath:strFileName] atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isShowActivity) {
                [self HideActivityView];
            }
            self.image = image; 
        });
        UIGraphicsEndImageContext();
    });
}

-(NSData *)queryDiskCache:(NSString *)strFileName{
    NSString *diskPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
        return nil;
    }
    NSString *filePath = [self getCatchPath:strFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSData dataWithContentsOfFile:filePath];
    }else 
    return nil;
}

-(BOOL)checkImageCacheLifeCycle:(NSString *)strPath{
    //暫存時間一週
    NSInteger cacheLifeCycle = 60*60*24*7;
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheLifeCycle];
    if ([[[[NSFileManager defaultManager] attributesOfItemAtPath:strPath error:nil] fileModificationDate] compare:expirationDate] == NSOrderedAscending) {
        [[NSFileManager defaultManager] removeItemAtPath:strPath error:nil];
        return NO;
    }else {
        return YES;
    }
}

//取得檔案路徑
-(NSString *)getCatchPath:(NSString *)strFileName{
    NSString* kDataCacheDirectory=@"ImageCache";
    return [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:kDataCacheDirectory] stringByAppendingPathComponent:strFileName];
}
@end
