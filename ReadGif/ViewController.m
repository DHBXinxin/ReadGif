//
//  ViewController.m
//  ReadGif
//
//  Created by IOS on 16/4/12.
//  Copyright © 2016年 IOS. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
//    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//            ALAssetRepresentation *representation = result.defaultRepresentation;
//            CGImageRef cImage = [representation fullScreenImage];
//            uint8_t *buffer = (uint8_t *)malloc(representation.size);
//            NSError *error;
//            NSUInteger length = [representation getBytes:buffer fromOffset:0 length:representation.size error:&error];
//            NSData *data = [NSData dataWithBytes:buffer length:length];
//            CGImageSourceRef cImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
//        }];
//    } failureBlock:^(NSError *error) {
//        
//    }];
    
    NSString *imagePath =[[NSBundle mainBundle] pathForResource:@"图层-33" ofType:@"gif"];
    CGImageSourceRef  cImageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:imagePath], NULL);
    
    size_t imageCount = CGImageSourceGetCount(cImageSource);
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSMutableArray *times = [[NSMutableArray alloc] initWithCapacity:imageCount];
    NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:imageCount];
    CGSize _size;
    float totalTime = 0;
    for (size_t i = 0; i < imageCount; i++) {
        CGImageRef cgimage= CGImageSourceCreateImageAtIndex(cImageSource, i, NULL);
        [images addObject:(__bridge id)cgimage];
        CGImageRelease(cgimage);
        
        NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(cImageSource, i, NULL);
        NSDictionary *gifProperties = [properties valueForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        NSString *gifDelayTime = [gifProperties valueForKey:(__bridge NSString* )kCGImagePropertyGIFDelayTime];
        [times addObject:gifDelayTime];
        totalTime += [gifDelayTime floatValue];
        
        _size.width = [[properties valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
        _size.height = [[properties valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
    }
    
    float currentTime = 0;
    for (size_t i = 0; i < times.count; i++) {
        float keyTime = currentTime / totalTime;
        [keyTimes addObject:[NSNumber numberWithFloat:keyTime]];
        currentTime += [[times objectAtIndex:i] floatValue];
    }
    UIView *image = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
    [self.view addSubview:image];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setValues:images];
    [animation setKeyTimes:keyTimes];
    animation.duration = totalTime;
    animation.repeatCount = HUGE_VALF;
    [image.layer addAnimation:animation forKey:@"gifAnimation"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
