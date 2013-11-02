//
//  UIImageView+ImageCache.h
//  ImageCache
//
//  Created by HungChun on 12/5/1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageCache)
-(void)loadImageWithURL:(NSURL *)url;

-(void)CacheFile:(NSURL *)url andFileNema:(NSString *)strFileName;

-(void)CacheFile:(NSURL *)url andFileNema:(NSString *)strFileName andShowActivity:(BOOL)isShowActivity;//如果要show轉轉轉的就設定yes

-(NSData *)queryDiskCache:(NSString *)strFileName;

-(BOOL)checkImageCacheLifeCycle:(NSString *)strPath;

-(NSString *)getCatchPath:(NSString *)strFileName;

-(void)ShowActivityView;

-(void)HideActivityView;
@end
