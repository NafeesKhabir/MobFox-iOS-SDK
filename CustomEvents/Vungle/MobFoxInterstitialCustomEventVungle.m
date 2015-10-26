//
//  MobFoxCustomEventVungle.m
//  MobFoxCoreDemo
//
//  Created by Itamar Nabriski on 10/22/15.
//  Copyright © 2015 Itamar Nabriski. All rights reserved.
//

#import "MobFoxInterstitialCustomEventVungle.h"


@implementation MobFoxInterstitialCustomEventVungle


- (void)requestInterstitial:(NSString*)networkId customEventInfo:(NSDictionary *)info{
    VungleSDK* sdk = [VungleSDK sharedSDK];
    // start vungle publisher library
    [sdk setDelegate:self];
    [sdk startWithAppId:networkId];
    [self.delegate MFInterstitialCustomEventAd:self didLoad:nil];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController{
   
    VungleSDK* sdk = [VungleSDK sharedSDK];
    NSError *error;
    [sdk playAd:rootViewController error:&error];
   
    if(error){
        [self.delegate MFInterstitialCustomEventAdDidFailToReceiveAdWithError:error];
        return;
    }
    

}

- (void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable{
    
}

- (void)vungleSDKwillShowAd{
    
}

- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary*)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet{
    
}

- (void)vungleSDKwillCloseProductSheet:(id)productSheet{
    
}

@end