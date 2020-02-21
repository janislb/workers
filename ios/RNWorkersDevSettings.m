#import "RNWorkersDevSettings.h"
#import <React/RCTLog.h>

@implementation RNWorkersDevSettings
{
  RNWorkersInstanceData *_data;
}

// We're replacing the stock implementation of RCTDevSettings for the worker bridge.
// We define `moduleName` instead of using RCT_EXPORT_MODULE because the latter would
// override RCTDevSettings for the parent bridge, which is undesirable.
+ (NSString *)moduleName
{
  return @"RCTDevSettings";
}

// RCTDevSettings produces side-effects in its setter for the `bridge` property, and
// those side-effects must run on the main queue. The only way to guarantee that this
// module is initialized on the main queue is to define the `constantsToExport` method.
- (NSDictionary *)constantsToExport
{
  return nil;
}

- (instancetype)initWithData:(RNWorkersInstanceData *)data
{
  if (self = [self init]) {
    _data = data;
  }
  return self;
}

- (BOOL)isShakeToShowDevMenuEnabled {
  return NO;
}

- (BOOL)isRemoteDebuggingAvailable {
  return NO; // _data.bundlerPort && super.isRemoteDebuggingAvailable;
}

- (void)_remoteDebugSettingDidChange
{
  if (super.isDebuggingRemotely && !self.isRemoteDebuggingAvailable) {
    RCTLogWarn(
      @"The worker with bundle root %@ cannot be debugged remotely because it does "
       "not have a unique bundler instance. Start another bundler on a unique port "
       "(using the --port argument), then provide that port to the Worker constructor.",
      _data.bundleRoot
    );
    return;
  }
  [super _remoteDebugSettingDidChange];
}

@end
