
'use strict';

import {
  DeviceEventEmitter,
  NativeModules
} from 'react-native';

const MDM = NativeModules.MobileDeviceManager;

export default {
  isSupported: MDM?.isSupported,
  getConfiguration: MDM?.getConfiguration,
  isAppLockingAllowed: MDM?.isAppLockingAllowed,
  isAppLocked: MDM?.isAppLocked,
  lockApp: MDM?.lockApp,
  unlockApp: MDM?.unlockApp,
  APP_CONFIG_CHANGED: MDM?.APP_CONFIG_CHANGED,
  APP_LOCK_STATUS_CHANGED: MDM?.APP_LOCK_STATUS_CHANGED,
  addAppConfigListener(callback) {
    return DeviceEventEmitter.addListener(
      MDM?.APP_CONFIG_CHANGED,
      callback
    );
  },
  addAppLockListener(callback) {
    return DeviceEventEmitter.addListener(
      MDM?.APP_LOCK_STATUS_CHANGED,
      callback
    );
  }
};
