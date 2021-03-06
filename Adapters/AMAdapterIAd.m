/*
 
 AMAdapterIAd.m
 
 Copyright 2010 AdMob, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */

#import "AMAdapterIAd.h"
#import "AMAdNetworkConfig.h"
#import "AMView.h"
#import "AMLog.h"
#import "AMAdNetworkAdapter+Helpers.h"
#import "AMAdNetworkRegistry.h"

@implementation AMAdapterIAd

+ (AMAdNetworkType)networkType {
    return AMAdNetworkTypeIAd;
}

+ (void)load {
    if(NSClassFromString(@"ADBannerView") != nil) {
        [[AMAdNetworkRegistry sharedRegistry] registerClass:self];
    }
}

- (void)getAd {
    ADBannerView *iAdView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    kADBannerContentSizeIdentifierPortrait =
    &ADBannerContentSizeIdentifierPortrait != nil ?
    ADBannerContentSizeIdentifierPortrait :
    ADBannerContentSizeIdentifier320x50;
    kADBannerContentSizeIdentifierLandscape =
    &ADBannerContentSizeIdentifierLandscape != nil ?
    ADBannerContentSizeIdentifierLandscape :
    ADBannerContentSizeIdentifier480x32;
    iAdView.requiredContentSizeIdentifiers = [NSSet setWithObjects:
                                              kADBannerContentSizeIdentifierPortrait,
                                              kADBannerContentSizeIdentifierLandscape,
                                              nil];
    UIDeviceOrientation orientation;
    if ([self.amDelegate respondsToSelector:@selector(AMCurrentOrientation)]) {
        orientation = [self.amDelegate AMCurrentOrientation];
    }
    else {
        orientation = [UIDevice currentDevice].orientation;
    }
    
    if (UIDeviceOrientationIsLandscape(orientation)) {
        iAdView.currentContentSizeIdentifier = kADBannerContentSizeIdentifierLandscape;
    }
    else {
        iAdView.currentContentSizeIdentifier = kADBannerContentSizeIdentifierPortrait;
    }
    [iAdView setDelegate:self];
    
    self.adNetworkView = iAdView;
    [iAdView release];
}

- (void)stopBeingDelegate {
    ADBannerView *iAdView = (ADBannerView *)self.adNetworkView;
    if (iAdView != nil) {
        iAdView.delegate = nil;
    }
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation {
    ADBannerView *iAdView = (ADBannerView *)self.adNetworkView;
    if (iAdView == nil) return;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        iAdView.currentContentSizeIdentifier = kADBannerContentSizeIdentifierLandscape;
    }
    else {
        iAdView.currentContentSizeIdentifier = kADBannerContentSizeIdentifierPortrait;
    }
    // ADBanner positions itself in the center of the super view, which we do not
    // want, since we rely on publishers to resize the container view.
    // position back to 0,0
    CGRect newFrame = iAdView.frame;
    newFrame.origin.x = newFrame.origin.y = 0;
    iAdView.frame = newFrame;
}

- (BOOL)isBannerAnimationOK:(AMBannerAnimationType)animType {
    if (animType == AMBannerAnimationTypeFadeIn) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark IAdDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    // ADBanner positions itself in the center of the super view, which we do not
    // want, since we rely on publishers to resize the container view.
    // position back to 0,0
    CGRect newFrame = banner.frame;
    newFrame.origin.x = newFrame.origin.y = 0;
    banner.frame = newFrame;
    
    [amView adapter:self didReceiveAdView:banner];
    [amView adapterDidFinishAdRequest:self];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [amView adapter:self didFailAd:error];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [self helperNotifyDelegateOfFullScreenModal];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
