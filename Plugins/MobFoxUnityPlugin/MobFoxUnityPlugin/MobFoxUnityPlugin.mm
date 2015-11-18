//
//  MobFoxUnityPlugin.m
//  MobFoxUnityPlugin
//
//  Created by Itamar Nabriski on 11/17/15.
//  Copyright © 2015 Itamar Nabriski. All rights reserved.
//


#import "MobFoxUnityPlugin.h"

extern "C"
{
    extern UIViewController* UnityGetGLViewController();
    extern void UnitySendMessage(const char *, const char *, const char *);
}

@interface MobFoxUnityPlugin()
    @property NSMutableDictionary* ads;
    @property int nextId;
    @property NSString* gameObject;
    @property (nonatomic,strong) MobFoxInterstitialAd* inter;
@end

@implementation MobFoxUnityPlugin

-(id) init{
    self = [super init];
    self.ads = [[NSMutableDictionary alloc] init];
    self.nextId = 1;
    self.gameObject = nil;
    return self;
}

-(int) createBanner:(NSString*)invh  withDimensions:(CGRect) placement{
    
    MobFoxAd* banner = [[MobFoxAd alloc] init:invh withFrame:placement];
    banner.delegate = self;
    NSString* key = [NSString stringWithFormat:@"key-%d",self.nextId];
    [self.ads setValue:banner forKey:key];
    int cur = self.nextId;
    self.nextId= self.nextId + 1;
    return cur;
}

-(void) showBanner:(int) bannerId{
    NSString* key = [NSString stringWithFormat:@"key-%d",bannerId];
    MobFoxAd* banner = [self.ads valueForKey:key];
    if(!banner){
        NSLog(@"MobFoxUnityPlugin >> showBanner >> banner with id %d was not found",bannerId);
        return;
    }
    
    //banner.type = @"video";
    [banner loadAd];
    NSLog(@"MobFoxUnityPlugin >> showBanner >> show banner %d",bannerId);

}

-(void) hideBanner:(int) bannerId{
     NSString* key = [NSString stringWithFormat:@"key-%d",bannerId];
     MobFoxAd* banner = [self.ads valueForKey:key];
     if(!banner){
        NSLog(@"MobFoxUnityPlugin >> hideBanner >> banner with id %d was not found",bannerId);
        return;
    }
    [banner removeFromSuperview];
    NSLog(@"MobFoxUnityPlugin >> hideBanner >> hiding banner %d",bannerId);
}

-(void) createInterstitial:(NSString*)invh{
    
    NSLog(@"MobFoxUnityPlugin >> createInterstitial");
    self.inter = [[MobFoxInterstitialAd alloc] init:invh];
    self.inter.delegate = self;
    [self.inter loadAd];
   }

-(void) showInterstitial{
   
    if(!self.inter){
        NSLog(@"MobFoxUnityPlugin >> showInterstitial >> inter not init");
        return;
    }
    
    if(self.inter.ready){
        [self.inter show];
    }
    
    NSLog(@"MobFoxUnityPlugin >> showInterstitial");
    
}

- (void)MobFoxAdDidLoad:(MobFoxAd *)banner{
    //show banner
    UIViewController* vc = UnityGetGLViewController();
    [vc.view addSubview:banner];
    NSLog(@"MobFoxUnityPlugin >> showBanner >> showing banner");
}

- (void)MobFoxAdDidFailToReceiveAdWithError:(NSError *)error{

}

- (void)MobFoxAdClosed{
}

- (void)MobFoxAdClicked{

}

- (void)MobFoxAdFinished{

}

- (void)MobFoxInterstitialAdDidLoad:(MobFoxInterstitialAd *)interstitial{
    
    NSLog(@"MobFoxUnityPlugin >> MobFoxInterstitialAdDidLoad >> inter loaded");
    interstitial.rootViewController = UnityGetGLViewController();
    UnitySendMessage([self.gameObject UTF8String],"interstitialReady","");
   
}


- (void)MobFoxInterstitialAdDidFailToReceiveAdWithError:(NSError *)error{}

- (void)MobFoxInterstitialAdClosed{}


- (void)MobFoxInterstitialAdClicked{}


- (void)MobFoxInterstitialAdFinished{}

@end

extern "C"
{
    static MobFoxUnityPlugin* plugin = [[MobFoxUnityPlugin alloc] init];
    
    void _setGameObject(const char* gameObject){
        plugin.gameObject = [NSString stringWithUTF8String:gameObject];
    }
    
    int _createBanner(const char* invh){
        return [plugin createBanner:[NSString stringWithUTF8String:invh] withDimensions:CGRectMake(0.0, 0.0, 300.0, 250.0)];
    }
    void _showBanner(int bannerId){
        [plugin showBanner:bannerId];
    }
    void  _showHide(int bannerId){
        [plugin hideBanner:bannerId];
    }
    
    void _createInterstitial(const char* invh){
        [plugin createInterstitial:[NSString stringWithUTF8String:invh]];
    }
    
    void _showInterstitial(){
        [plugin showInterstitial];
    }
}