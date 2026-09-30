//
//  OpenSSLSimulatorStubs.m
//  TunnelKit
//
//  hide.me: openssl.xcframework has no arm64 tvOS-simulator slice (only x86_64), so the
//  OpenSSL-backed sources (CryptoAEAD.m, CryptoBox.m, CryptoCBC.m, CryptoCTR.m, TLSBox.m)
//  compile to nothing there. This file provides the classes and constants the rest of
//  TunnelKit links against, so apps embedding TunnelKit can still build and run in the
//  tvOS simulator. OpenVPN does not work in the simulator: none of this is ever called,
//  because the app's packet tunnel provider is itself a stub on the simulator.
//
//  Remove this file (and the #if guards in the files above) once the xcframework ships
//  a tvOS arm64 simulator slice.
//

#include <TargetConditionals.h>
#if TARGET_OS_TV && TARGET_OS_SIMULATOR

#import <Foundation/Foundation.h>

// Same values as TLSBox.m.
const NSInteger TLSBoxMaxBufferLength = 16384;
NSString *const TLSBoxPeerVerificationErrorNotification = @"TLSBoxPeerVerificationErrorNotification";
const NSInteger TLSBoxDefaultSecurityLevel = -1;

@interface CryptoBox : NSObject
@end

@implementation CryptoBox
@end

@interface TLSBox : NSObject
@end

@implementation TLSBox
@end

#endif
