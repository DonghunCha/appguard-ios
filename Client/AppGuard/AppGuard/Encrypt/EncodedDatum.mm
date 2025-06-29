//
//  EncodedDatum.cpp
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 18..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#include "EncodedDatum.h"

const char EncodedDatum::keys_[][16] =
{
    {"rq1e"}, // /Applications/Cydia.app
    {"9876"}, // /usr/sbin/sshd
    {"brew"}, // /usr/bin/sshd
    {"2580"}, // /usr/libexec/sftp-server
    {"1143"}, // /private/var/lib/apt
    {"6523"}, // /private/var/tmp/cydia.log
    {"1157"}, // /private/var/lib/cydia
    {"6291"}, // /private/var/stash
    {"f202"}, // /Applications
    {"2316"}, // gamehacker
    {"7347"}, // GamePlayerd
    {"f329"}, // Flex
    {"jf2j"}, // MemSearch
    {"310a"}, // debugger
    {"z2qf"}, // TEXT segment integrity TODO fix
    {"f343"}, // sandbox detect
    {"23is"}, // __TEXT
    {"32f0"}, // __text
    {"1823"}, // /Library/MobileSubstrate/DynamicLibraries/
    {"8a3c"}, // .plist
    {"5239"}, // LSApplicationWorkspace
    {"8493"}, // defaultWorkspace
    {"7341"}, // allApplications
    {"A95Y"}, // detected
    {"NQ21"}, // block
    {"8723"}, // Signature integrity
    {"4638"}, // com.nhnent.appguardPolicyQueue
    {"2472"}, // policy.ag
    {"2394"}, // https://adam.cdn.toastoven.net
    {"9119"}, // This application will shut down according to the security policy.
    {"1129"}, // Code : %d
    {"8806"}, // AppGuard Alert
    {"2243"}, // https://alpha-api-logncrash.cloud.toast.com
    {"1423"}, // https://beta-api-logncrash.cloud.toast.com
    {"1332"}, // https://api-logncrash.cloud.toast.com
    {"2421"}, // /bin/bash
    {"4423"}, // /bin/sh
    {"6428"}, // /usr/sbin/sshd
    {"3246"}, // /usr/libexec/ssh-keysign
    {"5272"}, // /etc/ssh/sshd_config
    {"3131"}, // /Library/MobileSubstrate/MobileSubstrate.dylib
    {"6274"}, // /var/cache/apt
    {"3245"}, // /var/lib/apt
    {"5241"}, // /var/lib/cydia
    {"8683"}, // /var/log/syslog
    {"1134"}, // /var/tmp/cydia.log
    {"2347"}, // /etc/apt
    {"3424"}, // isatty
    {"1131"}, // cydia://
    {"2221"}, // /private/AG.txt
    {"4357"}, // Content-Type
    {"1819"}, // application/octet-stream
    {"1133"}, // GameGemiOS
    {"2244"}, // iGameGuardian
    {"9995"}, // com.nhnent.appgaurdExitQueue
    {"1a2b"}, // cryptid
    {"1234"}, // com.nhnent.appgaurdEncryptionQueue
    {"9389"}, // 0610
    {"4321"}, // ptrace
    {"6208"}, // /SC_Info
    {"5809"}, // .dylib
    {"1030"}, // com.apple.StoreKit
    {"4287"}, // /Frameworks/CydiaSubstrate.framework/CydiaSubstrate
    {"2860"}, // com.nhn.appguardCheckQueue
    {"1342"}, // MobileSubstrate.dylib
    {"2131"}, // libsubstrate.dylib
    {"5522"}, // TweakInject.dylib
    {"9458"}, // SubstrateLoader.dylib
    {"8367"}, // CydiaSubstrate
    {"7612"}, // Target Debug
    {"4379"}, // Debug Machine Info
    {"5434"}, // DYLD_INSERT_LIBRARIES
    {"6208"}, // UIApplication
    {"1026"}, // NSString
    {"3681"}, // NSFileManager
    {"6288"}, // com.nhnent.appguardPinningQueue
    {"8806"}, // Diresu
    {"1010"}, // ToastMemoryInformationManager
    {"3011"}, // AGNController
    {"4287"}, // SSL Pinning
    {"7234"}, // https://agd-policy.nhn.com/monitor/l7check
    {"9999"}, // H167g8Uttivf8jtH
    {"5152"}, // RNCryptorLoader
    {"3132"}, // s::::
    {"1331"}, // b::::
    {"1376"}, // free
    {"9922"}, // initWithOperations::::
    {"3192"}, // cryptor
    {"7121"}, // buffer
    {"2378"}, // addData::
    {"2892"}, // removeData::
    {"1682"}, // setResponseQueue:
    {"3414"}, // randomDataOfLength:
    {"2384"}, // initWithHandler:
    {"2347"}, // synchronousResultForCryptor::::
    {"8342"}, // setQueue:
    {"9924"}, // error
    {"6894"}, // finish
    {"6349"}, // send
    {"4839"}, // AppGuard Test Version.
    {"4139"}, // Free AppGuard Abuser
    {"COCO"}, // https://api-appguard-policy.cloud.toast.com/v1/block
    {"EK81"}, // BLOCK
    {"5934"}, // com.nhnent.appguardBlockQueue
    {"2312"}, // read
    {"3491"}, // write
    {"4359"}, // sendto
    {"3247"}, // sendmsg
    {"3492"}, // recv
    {"2347"}, // recvfrom
    {"4578"}, // recvmsg
    {"4389"}, // AQPattern
    {"8271"}, // _Z12hookingSVC80v
    {"3475"}, // /Library/BawAppie/ABypass/ABLicense
    {"3278"}, // ///././Library//./MobileSubstrate///DynamicLibraries///././/!ABypass2.dylib
    {"2478"}, // _Z19startAuthenticationv
    {"1566"}, // _Z13getRealOffsety
    {"9921"}, // _Z16calculateAddressx
    {"2323"}, // _MSSafeMode
    {"3232"}, // substitute
    {"3248"}, // /Library/MobileSubstrate/DynamicLibraries/AppFirewall.dylib
    {"2342"}, // /var/mobile/Library/Preferences/jp.akusio.kernbypass.plist
    {"4213"}, // signer integrity
    {"3453"}, // /var/mobile/Library/Preferences/com.laxus.iosgodsiapcracker.plist
    {"3451"}, // Suspected IAP hacking
    {"8765"}, // NHN_JB_TEST
    {"1111"}, // 0445c80
    {"6789"}, // 1235c8
    {"4562"}, // /Library/MobileSubstrate/DynamicLibraries/AdaptiveHome.dylib
    {"5959"}, // UnityFramework
    {"6746"}, // b4b1a804
    {"4512"}, // sleep
    {"2341"}, // usleep
    {"4123"}, // checkSystemAPIHook_detected_in_load
    {"3414"}, // checkAppGuardBinaryPatch1
    {"3314"}, // checkAppGuardBinaryPatch2
    {"1347"}, // __zDATA
    {"1357"}, // __zTEXT
    {"aaaa"}, // 1239948858249
    {"4525"}, // dylib injection
    {"9482"}, // checkValidSvcCallHook_detected_in_load
    {"88e3"}, //appguard_plist_dict_key,
    {"4823"}, //appguard_plist_env_key,
    {"88d3"}, //env_alpha,
    {"58s3"}, //env_beta,
    {"4551"}, // exit
    {"6742"}, // /Applications/Sileo-Nightly.app
    {"4432"}, // /Applications/Zebra.app
    {"7643"}, // substitute-loader.dylib
    {"5654"}, // libsubstitute.dylib
    {"z1z1"}, // c9fa5e18160a5e37afa7df126715488f5df6ba5d4caa3870a6749843f51533ee
    {"4463" },// /ios
    {"5638" }, //  // /alpha/ios
    {"6557" },  // /beta/ios
    {"6534"}, // http://alpha-agd-policy.nhn.com/v1/block
    {"6536"}, // http://beta-agd-policy.nhn.com/v1/block
    {"4832"}, // RN, PG, RT fields are deprecated.
    {"opiz"}, // dc7a42f36f5aa669d5a8658a322ef37cb3ec3a3f9939b2278ba947bf7a61a3ee,
    {"7664"}, // Info.plist
    {"9864"}, // Unity Interface Mem Patched.(d)
    {"3921"}, // Check Text section by check Code
    {"5435"}, //usr/sbin/frida-server
    {"5436"}, //gum-js-loop
    {"5437"}, // frida-ios-dump
    {"6642"}, // The f function is deprecated. It no longer works.
    {"2452"}, //CFBundleExecutable
    {"2454"},//CFBundleIdentifier
    {"2453"}, //CFBundleVersion
    {"2457"}, //CFBundleShortVersionString,
    {"5625"}, //crackerxi://?data=
    {"4938"},// gamegodopen:bf?decryptedPath=
    {"4342"}, //decryptedPath
    {"9582"}, //data
    {"8778"}, //il2cpp
    {"x289c"}, //d64b7b73
    {"4454"}, // /var/jb
    {"4453"}, // /Applications/Sileo.app
    {"7553"}, ///var/mobile/Library/palera1n/helper
    {"6553"}, // /cores/binpack/Applications/palera1nLoader.app
    {"zkjo"}, //2a02a552ab75c5de1367b69d135a4fffb121bedd2bd934440560035e83d1d0c7
    {"4352"}, //Exported function patched RET;
    {"2324"}, //Behavior
    {"9535"}, //jsbundle
    {"2939"}, //Flutter
    {"2935"}, //__const
    {"2462"}, //policy_json
    {"3341"}, //appKey
    {"3454"}, //version
    {"3456"}, //updatedDateTime
    {"3457"}, //uuid
    {"3458"}, //ruleGroups
    {"3470"}, //action
    {"4331"}, // CLLocationManager
    {"4332"}, // NSLocationWhenInUseUsageDescription
    {"4333"}, // NSLocationAlwaysUsageDescription
    {"4334"}, //NSLocationAlwaysAndWhenInUseUsageDescription
    {"3422"}, // CodePush
    {"3235"}, //tap/ppp/ipsec0/tun/ipsec/utun
    {"zzsw"}, // bcbfce8d5b64aacefe0af8bffe873699a7f2156d28fec6498aad5160c38b5f6d //startup message replace signature
    {"4564"}, // Secured by NHN AppGuard
    {"Zrzr"}, // detection_alert_mode_replace_signature //e7a438bd1b7bd0c151ca42ac87ef720294f66677875b87de7e546a2b50c817aa
    {"3455"}, // .debug.dylib
    {"2346"} // /.expo-internal/
};

const char EncodedDatum::encoded_[][256] =
{
    // /Applications/Cydia.app
    {'\x5D', '\x30', '\x41', '\x15', '\x1E', '\x18', '\x52', '\x04', '\x06', '\x18', '\x5E', '\x0B', '\x01', '\x5E', '\x72', '\x1C', '\x16', '\x18', '\x50', '\x4B', '\x13', '\x01', '\x41',  '\0'},
    // /usr/sbin/sshd
    {'\x16', '\x4D', '\x44', '\x44', '\x16', '\x4B', '\x55', '\x5F', '\x57', '\x17', '\x44', '\x45', '\x51', '\x5C',  '\0'},
    // /usr/bin/sshd
    {'\x4D', '\x07', '\x16', '\x05', '\x4D', '\x10', '\x0C', '\x19', '\x4D', '\x01', '\x16', '\x1F', '\x06',  '\0'},
    // /usr/libexec/sftp-server
    {'\x1D', '\x40', '\x4B', '\x42', '\x1D', '\x59', '\x51', '\x52', '\x57', '\x4D', '\x5D', '\x53', '\x1D', '\x46', '\x5E', '\x44', '\x42', '\x18', '\x4B', '\x55', '\x40', '\x43', '\x5D', '\x42',  '\0'},
    // /private/var/lib/apt
    {'\x1E', '\x41', '\x46', '\x5A', '\x47', '\x50', '\x40', '\x56', '\x1E', '\x47', '\x55', '\x41', '\x1E', '\x5D', '\x5D', '\x51', '\x1E', '\x50', '\x44', '\x47',  '\0'},
    // /private/var/tmp/cydia.log
    {'\x19', '\x45', '\x40', '\x5A', '\x40', '\x54', '\x46', '\x56', '\x19', '\x43', '\x53', '\x41', '\x19', '\x41', '\x5F', '\x43', '\x19', '\x56', '\x4B', '\x57', '\x5F', '\x54', '\x1C', '\x5F', '\x59', '\x52',  '\0'},
    // /private/var/lib/cydia
    {'\x1E', '\x41', '\x47', '\x5E', '\x47', '\x50', '\x41', '\x52', '\x1E', '\x47', '\x54', '\x45', '\x1E', '\x5D', '\x5C', '\x55', '\x1E', '\x52', '\x4C', '\x53', '\x58', '\x50',  '\0'},
    // /private/var/stash
    {'\x19', '\x42', '\x4B', '\x58', '\x40', '\x53', '\x4D', '\x54', '\x19', '\x44', '\x58', '\x43', '\x19', '\x41', '\x4D', '\x50', '\x45', '\x5A',  '\0'},
    // /Applications
    {'\x49', '\x73', '\x40', '\x42', '\x0A', '\x5B', '\x53', '\x53', '\x12', '\x5B', '\x5F', '\x5C', '\x15',  '\0'},
    // gamehacker
    {'\x55', '\x52', '\x5C', '\x53', '\x5A', '\x52', '\x52', '\x5D', '\x57', '\x41',  '\0'},
    // GamePlayerd
    {'\x70', '\x52', '\x59', '\x52', '\x67', '\x5F', '\x55', '\x4E', '\x52', '\x41', '\x50',  '\0'},
    // Flex
    {'\x20', '\x5F', '\x57', '\x41',  '\0'},
    // MemSearch
    {'\x27', '\x03', '\x5F', '\x39', '\x0F', '\x07', '\x40', '\x09', '\x02',  '\0'},
    // debugger
    {'\x57', '\x54', '\x52', '\x14', '\x54', '\x56', '\x55', '\x13',  '\0'},
    // TEXT segment integrity
    {'\x2E', '\x77', '\x29', '\x32', '\x5A', '\x41', '\x14', '\x01', '\x17', '\x57', '\x1F', '\x12', '\x5A', '\x5B', '\x1F', '\x12', '\x1F', '\x55', '\x03', '\x0F', '\x0E', '\x4B',  '\0'},
    // sandbox detect
    {'\x15', '\x52', '\x5A', '\x57', '\x04', '\x5C', '\x4C', '\x13', '\x02', '\x56', '\x40', '\x56', '\x05', '\x47',  '\0'},
    //__TEXT
    {'\x6D', '\x6C', '\x3D', '\x36', '\x6A', '\x67',  '\0'},
    //__text
    {'\x6C', '\x6D', '\x12', '\x55', '\x4B', '\x46',  '\0'},
    // /Library/MobileSubstrate/DynamicLibraries/
    {'\x1E', '\x74', '\x5B', '\x51', '\x43', '\x59', '\x40', '\x4A', '\x1E', '\x75', '\x5D', '\x51', '\x58', '\x54', '\x57', '\x60', '\x44', '\x5A', '\x41', '\x47', '\x43', '\x59', '\x46', '\x56', '\x1E', '\x7C', '\x4B', '\x5D', '\x50', '\x55', '\x5B', '\x50', '\x7D', '\x51', '\x50', '\x41', '\x50', '\x4A', '\x5B', '\x56', '\x42', '\x17',  '\0'},
    // .plist
    {'\x16', '\x11', '\x5F', '\x0A', '\x4B', '\x15',  '\0'},
    // LSApplicationWorkspace
    {'\x79', '\x61', '\x72', '\x49', '\x45', '\x5E', '\x5A', '\x5A', '\x54', '\x46', '\x5A', '\x56', '\x5B', '\x65', '\x5C', '\x4B', '\x5E', '\x41', '\x43', '\x58', '\x56', '\x57',  '\0'},
    // defaultWorkspace
    {'\x5C', '\x51', '\x5F', '\x52', '\x4D', '\x58', '\x4D', '\x64', '\x57', '\x46', '\x52', '\x40', '\x48', '\x55', '\x5A', '\x56',  '\0'},
    // allApplications
    {'\x56', '\x5F', '\x58', '\x70', '\x47', '\x43', '\x58', '\x58', '\x54', '\x52', '\x40', '\x58', '\x58', '\x5D', '\x47',  '\0'},
    // detected
    {'\x25', '\x5C', '\x41', '\x3C', '\x22', '\x4D', '\x50', '\x3D',  '\0'},
    // block
    {'\x2C', '\x3D', '\x5D', '\x52', '\x25',  '\0'},
    // Signature integrity
    {'\x6B', '\x5E', '\x55', '\x5D', '\x59', '\x43', '\x47', '\x41', '\x5D', '\x17', '\x5B', '\x5D', '\x4C', '\x52', '\x55', '\x41', '\x51', '\x43', '\x4B',  '\0'},
    // com.nhnent.appguardPolicyQueue
    {'\x57', '\x59', '\x5E', '\x16', '\x5A', '\x5E', '\x5D', '\x5D', '\x5A', '\x42', '\x1D', '\x59', '\x44', '\x46', '\x54', '\x4D', '\x55', '\x44', '\x57', '\x68', '\x5B', '\x5A', '\x5A', '\x5B', '\x4D', '\x67', '\x46', '\x5D', '\x41', '\x53',  '\0'},
    // policy.ag
    {'\x42', '\x5B', '\x5B', '\x5B', '\x51', '\x4D', '\x19', '\x53', '\x55',  '\0'},
    // https://adam.cdn.toastoven.net
    {'\x5A', '\x47', '\x4D', '\x44', '\x41', '\x09', '\x16', '\x1B', '\x53', '\x57', '\x58', '\x59', '\x1C', '\x50', '\x5D', '\x5A', '\x1C', '\x47', '\x56', '\x55', '\x41', '\x47', '\x56', '\x42', '\x57', '\x5D', '\x17', '\x5A', '\x57', '\x47',  '\0'},
    // This application will shut down according to the security policy.
    {'\x6D', '\x59', '\x58', '\x4A', '\x19', '\x50', '\x41', '\x49', '\x55', '\x58', '\x52', '\x58', '\x4D', '\x58', '\x5E', '\x57', '\x19', '\x46', '\x58', '\x55', '\x55', '\x11', '\x42', '\x51', '\x4C', '\x45', '\x11', '\x5D', '\x56', '\x46', '\x5F', '\x19', '\x58', '\x52', '\x52', '\x56', '\x4B', '\x55', '\x58', '\x57', '\x5E', '\x11', '\x45', '\x56', '\x19', '\x45', '\x59', '\x5C', '\x19', '\x42', '\x54', '\x5A', '\x4C', '\x43', '\x58', '\x4D', '\x40', '\x11', '\x41', '\x56', '\x55', '\x58', '\x52', '\x40', '\x17',  '\0'},
    // Code : 
    {'\x72', '\x5E', '\x56', '\x5C', '\x11', '\x0B', '\x12', '\0'},
    // AppGuard Alert
    {'\x79', '\x48', '\x40', '\x71', '\x4D', '\x59', '\x42', '\x52', '\x18', '\x79', '\x5C', '\x53', '\x4A', '\x4C',  '\0'},
    // https://alpha-api-logncrash.cloud.toast.com
    {'\x5A', '\x46', '\x40', '\x43', '\x41', '\x08', '\x1B', '\x1C', '\x53', '\x5E', '\x44', '\x5B', '\x53', '\x1F', '\x55', '\x43', '\x5B', '\x1F', '\x58', '\x5C', '\x55', '\x5C', '\x57', '\x41', '\x53', '\x41', '\x5C', '\x1D', '\x51', '\x5E', '\x5B', '\x46', '\x56', '\x1C', '\x40', '\x5C', '\x53', '\x41', '\x40', '\x1D', '\x51', '\x5D', '\x59',  '\0'},
    // https://beta-api-logncrash.cloud.toast.com
    {'\x59', '\x40', '\x46', '\x43', '\x42', '\x0E', '\x1D', '\x1C', '\x53', '\x51', '\x46', '\x52', '\x1C', '\x55', '\x42', '\x5A', '\x1C', '\x58', '\x5D', '\x54', '\x5F', '\x57', '\x40', '\x52', '\x42', '\x5C', '\x1C', '\x50', '\x5D', '\x5B', '\x47', '\x57', '\x1F', '\x40', '\x5D', '\x52', '\x42', '\x40', '\x1C', '\x50', '\x5E', '\x59',  '\0'},
    // https://api-logncrash.cloud.toast.com
    {'\x59', '\x47', '\x47', '\x42', '\x42', '\x09', '\x1C', '\x1D', '\x50', '\x43', '\x5A', '\x1F', '\x5D', '\x5C', '\x54', '\x5C', '\x52', '\x41', '\x52', '\x41', '\x59', '\x1D', '\x50', '\x5E', '\x5E', '\x46', '\x57', '\x1C', '\x45', '\x5C', '\x52', '\x41', '\x45', '\x1D', '\x50', '\x5D', '\x5C',  '\0'},
    // /bin/bash
    {'\x1D', '\x56', '\x5B', '\x5F', '\x1D', '\x56', '\x53', '\x42', '\x5A',  '\0'},
    // /bin/sh
    {'\x1B', '\x56', '\x5B', '\x5D', '\x1B', '\x47', '\x5A',  '\0'},
    // /usr/sbin/sshd
    {'\x19', '\x41', '\x41', '\x4A', '\x19', '\x47', '\x50', '\x51', '\x58', '\x1B', '\x41', '\x4B', '\x5E', '\x50',  '\0'},
    // /usr/libexec/ssh-keysign
    {'\x1C', '\x47', '\x47', '\x44', '\x1C', '\x5E', '\x5D', '\x54', '\x56', '\x4A', '\x51', '\x55', '\x1C', '\x41', '\x47', '\x5E', '\x1E', '\x59', '\x51', '\x4F', '\x40', '\x5B', '\x53', '\x58',  '\0'},
    // /etc/ssh/sshd_config
    {'\x1A', '\x57', '\x43', '\x51', '\x1A', '\x41', '\x44', '\x5A', '\x1A', '\x41', '\x44', '\x5A', '\x51', '\x6D', '\x54', '\x5D', '\x5B', '\x54', '\x5E', '\x55',  '\0'},
    // /Library/MobileSubstrate/MobileSubstrate.dylib
    {'\x1C', '\x7D', '\x5A', '\x53', '\x41', '\x50', '\x41', '\x48', '\x1C', '\x7C', '\x5C', '\x53', '\x5A', '\x5D', '\x56', '\x62', '\x46', '\x53', '\x40', '\x45', '\x41', '\x50', '\x47', '\x54', '\x1C', '\x7C', '\x5C', '\x53', '\x5A', '\x5D', '\x56', '\x62', '\x46', '\x53', '\x40', '\x45', '\x41', '\x50', '\x47', '\x54', '\x1D', '\x55', '\x4A', '\x5D', '\x5A', '\x53',  '\0'},
    // /var/cache/apt
    {'\x19', '\x44', '\x56', '\x46', '\x19', '\x51', '\x56', '\x57', '\x5E', '\x57', '\x18', '\x55', '\x46', '\x46',  '\0'},
    // /var/lib/apt
    {'\x1C', '\x44', '\x55', '\x47', '\x1C', '\x5E', '\x5D', '\x57', '\x1C', '\x53', '\x44', '\x41',  '\0'},
    // /var/lib/cydia
    {'\x1A', '\x44', '\x55', '\x43', '\x1A', '\x5E', '\x5D', '\x53', '\x1A', '\x51', '\x4D', '\x55', '\x5C', '\x53',  '\0'},
    // /var/log/syslog
    {'\x17', '\x40', '\x59', '\x41', '\x17', '\x5A', '\x57', '\x54', '\x17', '\x45', '\x41', '\x40', '\x54', '\x59', '\x5F',  '\0'},
    // /var/tmp/cydia.log
    {'\x1E', '\x47', '\x52', '\x46', '\x1E', '\x45', '\x5E', '\x44', '\x1E', '\x52', '\x4A', '\x50', '\x58', '\x50', '\x1D', '\x58', '\x5E', '\x56',  '\0'},
    // /etc/apt
    {'\x1D', '\x56', '\x40', '\x54', '\x1D', '\x52', '\x44', '\x43',  '\0'},
    // isatty
    {'\x5A', '\x47', '\x53', '\x40', '\x47', '\x4D',  '\0'},
    // cydia://
    {'\x52', '\x48', '\x57', '\x58', '\x50', '\x0B', '\x1C', '\x1E',  '\0'},
    // /private/AG.txt
    {'\x1D', '\x42', '\x40', '\x58', '\x44', '\x53', '\x46', '\x54', '\x1D', '\x73', '\x75', '\x1F', '\x46', '\x4A', '\x46',  '\0'},
    // Content-Type
    {'\x77', '\x5C', '\x5B', '\x43', '\x51', '\x5D', '\x41', '\x1A', '\x60', '\x4A', '\x45', '\x52',  '\0'},
    // application/octet-stream
    {'\x50', '\x48', '\x41', '\x55', '\x58', '\x5B', '\x50', '\x4D', '\x58', '\x57', '\x5F', '\x16', '\x5E', '\x5B', '\x45', '\x5C', '\x45', '\x15', '\x42', '\x4D', '\x43', '\x5D', '\x50', '\x54',  '\0'},
    // GameGemiOS
    {'\x76', '\x50', '\x5E', '\x56', '\x76', '\x54', '\x5E', '\x5A', '\x7E', '\x62',  '\0'},
    // iGameGuardian
    {'\x5B', '\x75', '\x55', '\x59', '\x57', '\x75', '\x41', '\x55', '\x40', '\x56', '\x5D', '\x55', '\x5C',  '\0'},
    // com.nhnent.appgaurdExitQueue
    {'\x5A', '\x56', '\x54', '\x1B', '\x57', '\x51', '\x57', '\x50', '\x57', '\x4D', '\x17', '\x54', '\x49', '\x49', '\x5E', '\x54', '\x4C', '\x4B', '\x5D', '\x70', '\x41', '\x50', '\x4D', '\x64', '\x4C', '\x5C', '\x4C', '\x50',  '\0'},
    // cryptid
    {'\x52', '\x13', '\x4B', '\x12', '\x45', '\x08', '\x56',  '\0'},
    // com.nhnent.appgaurdEncryptionQueue
    {'\x52', '\x5D', '\x5E', '\x1A', '\x5F', '\x5A', '\x5D', '\x51', '\x5F', '\x46', '\x1D', '\x55', '\x41', '\x42', '\x54', '\x55', '\x44', '\x40', '\x57', '\x71', '\x5F', '\x51', '\x41', '\x4D', '\x41', '\x46', '\x5A', '\x5B', '\x5F', '\x63', '\x46', '\x51', '\x44', '\x57',  '\0'},
    // 0610
    {'\x09', '\x05', '\x09', '\x09',  '\0'},
    // ptrace
    {'\x44', '\x47', '\x40', '\x50', '\x57', '\x56',  '\0'},
    // SC_Info
    {'\x19', '\x61', '\x73', '\x67', '\x7F', '\x5C', '\x56', '\x57',  '\0'},
    // .dylib
    {'\x1B', '\x5C', '\x49', '\x55', '\x5C', '\x5A',  '\0'},
    // com.apple.StoreKit
    {'\x52', '\x5F', '\x5E', '\x1E', '\x50', '\x40', '\x43', '\x5C', '\x54', '\x1E', '\x60', '\x44', '\x5E', '\x42', '\x56', '\x7B', '\x58', '\x44',  '\0'},
    // /Frameworks/CydiaSubstrate.framework/CydiaSubstrate
    {'\x1B', '\x74', '\x4A', '\x56', '\x59', '\x57', '\x4F', '\x58', '\x46', '\x59', '\x4B', '\x18', '\x77', '\x4B', '\x5C', '\x5E', '\x55', '\x61', '\x4D', '\x55', '\x47', '\x46', '\x4A', '\x56', '\x40', '\x57', '\x16', '\x51', '\x46', '\x53', '\x55', '\x52', '\x43', '\x5D', '\x4A', '\x5C', '\x1B', '\x71', '\x41', '\x53', '\x5D', '\x53', '\x6B', '\x42', '\x56', '\x41', '\x4C', '\x45', '\x55', '\x46', '\x5D',  '\0'},
    // com.nhn.appguardCheckQueue
    {'\x51', '\x57', '\x5B', '\x1E', '\x5C', '\x50', '\x58', '\x1E', '\x53', '\x48', '\x46', '\x57', '\x47', '\x59', '\x44', '\x54', '\x71', '\x50', '\x53', '\x53', '\x59', '\x69', '\x43', '\x55', '\x47', '\x5D',  '\0'},
    // MobileSubstrate.dylib
    {'\x7C', '\x5C', '\x56', '\x5B', '\x5D', '\x56', '\x67', '\x47', '\x53', '\x40', '\x40', '\x40', '\x50', '\x47', '\x51', '\x1C', '\x55', '\x4A', '\x58', '\x5B', '\x53',  '\0'},
    // libsubstrate.dylib
    {'\x5E', '\x58', '\x51', '\x42', '\x47', '\x53', '\x40', '\x45', '\x40', '\x50', '\x47', '\x54', '\x1C', '\x55', '\x4A', '\x5D', '\x5B', '\x53',  '\0'},
    // TweakInject.dylib
    {'\x61', '\x42', '\x57', '\x53', '\x5E', '\x7C', '\x5C', '\x58', '\x50', '\x56', '\x46', '\x1C', '\x51', '\x4C', '\x5E', '\x5B', '\x57',  '\0'},
    // SubstrateLoader.dylib
    {'\x6A', '\x41', '\x57', '\x4B', '\x4D', '\x46', '\x54', '\x4C', '\x5C', '\x78', '\x5A', '\x59', '\x5D', '\x51', '\x47', '\x16', '\x5D', '\x4D', '\x59', '\x51', '\x5B',  '\0'},
    // CydiaSubstrate
    {'\x7B', '\x4A', '\x52', '\x5E', '\x59', '\x60', '\x43', '\x55', '\x4B', '\x47', '\x44', '\x56', '\x4C', '\x56',  '\0'},
    // Target Debug
    {'\x63', '\x57', '\x43', '\x55', '\x52', '\x42', '\x11', '\x76', '\x52', '\x54', '\x44', '\x55',  '\0'},
    // Debug Machine Info
    {'\x70', '\x56', '\x55', '\x4C', '\x53', '\x13', '\x7A', '\x58', '\x57', '\x5B', '\x5E', '\x57', '\x51', '\x13', '\x7E', '\x57', '\x52', '\x5C', '\x3D', '\x7D', '\x51', '\x51', '\x42', '\x5E', '\x14', '\x7E', '\x56', '\x5A', '\x5C', '\x5A', '\x59', '\x5C', '\x14', '\x7A', '\x59', '\x5F', '\x5B', '\x39', '\x73', '\x5C', '\x56', '\x46', '\x50', '\x19', '\x79', '\x52', '\x54', '\x51', '\x5D', '\x5D', '\x52', '\x19', '\x7D', '\x5D', '\x51', '\x56',  '\0'},
    // DYLD_INSERT_LIBRARIES
    {'\x71', '\x6D', '\x7F', '\x70', '\x6A', '\x7D', '\x7D', '\x67', '\x70', '\x66', '\x67', '\x6B', '\x79', '\x7D', '\x71', '\x66', '\x74', '\x66', '\x7A', '\x71', '\x66',  '\0'},
    // UIApplication
    {'\x63', '\x7B', '\x71', '\x48', '\x46', '\x5E', '\x59', '\x5B', '\x57', '\x46', '\x59', '\x57', '\x58',  '\0'},
    // NSString
    {'\x7F', '\x63', '\x61', '\x42', '\x43', '\x59', '\x5C', '\x51',  '\0'},
    // NSFileManager
    {'\x7D', '\x65', '\x7E', '\x58', '\x5F', '\x53', '\x75', '\x50', '\x5D', '\x57', '\x5F', '\x54', '\x41',  '\0'},
    // com.nhnent.appguardPinningQueue
    {'\x55', '\x5D', '\x55', '\x16', '\x58', '\x5A', '\x56', '\x5D', '\x58', '\x46', '\x16', '\x59', '\x46', '\x42', '\x5F', '\x4D', '\x57', '\x40', '\x5C', '\x68', '\x5F', '\x5C', '\x56', '\x51', '\x58', '\x55', '\x69', '\x4D', '\x53', '\x47', '\x5D',  '\0'},
    // Diresu
    {'\x7C', '\x51', '\x42', '\x53', '\x4B', '\x4D',  '\0'},
    // ToastMemoryInformationManager
    {'\x65', '\x5F', '\x50', '\x43', '\x45', '\x7D', '\x54', '\x5D', '\x5E', '\x42', '\x48', '\x79', '\x5F', '\x56', '\x5E', '\x42', '\x5C', '\x51', '\x45', '\x59', '\x5E', '\x5E', '\x7C', '\x51', '\x5F', '\x51', '\x56', '\x55', '\x43',  '\0'},
    // AGNController
    {'\x72', '\x77', '\x7F', '\x72', '\x5C', '\x5E', '\x45', '\x43', '\x5C', '\x5C', '\x5D', '\x54', '\x41',  '\0'},
    // SSL Pinning
    {'\x67', '\x61', '\x74', '\x17', '\x64', '\x5B', '\x56', '\x59', '\x5D', '\x5C', '\x5F',  '\0'},
    // https://agd-policy.nhn.com/monitor/l7check
    {'\x5F', '\x46', '\x47', '\x44', '\x44', '\x08', '\x1C', '\x1B', '\x56', '\x55', '\x57', '\x19', '\x47', '\x5D', '\x5F', '\x5D', '\x54', '\x4B', '\x1D', '\x5A', '\x5F', '\x5C', '\x1D', '\x57', '\x58', '\x5F', '\x1C', '\x59', '\x58', '\x5C', '\x5A', '\x40', '\x58', '\x40', '\x1C', '\x58',  '\0'},
    // H167g8Uttivf8jtH
    {'\x71', '\x08', '\x0F', '\x0E', '\x5E', '\x01', '\x6C', '\x4D', '\x4D', '\x50', '\x4F', '\x5F', '\x01', '\x53', '\x4D', '\x71',  '\0'},
    // RNCryptorLoader
    {'\x67', '\x7F', '\x76', '\x40', '\x4C', '\x41', '\x41', '\x5D', '\x47', '\x7D', '\x5A', '\x53', '\x51', '\x54', '\x47',  '\0'},
    // s::::
    {'\x40', '\x0B', '\x09', '\x08', '\x09',  '\0'},
    // b::::
    {'\x53', '\x09', '\x09', '\x0B', '\x0B',  '\0'},
    // free
    {'\x57', '\x41', '\x52', '\x53',  '\0'},
    // initWithOperations::::
    {'\x50', '\x57', '\x5B', '\x46', '\x6E', '\x50', '\x46', '\x5A', '\x76', '\x49', '\x57', '\x40', '\x58', '\x4D', '\x5B', '\x5D', '\x57', '\x4A', '\x08', '\x08', '\x03', '\x03',  '\0'},
    // cryptor
    {'\x50', '\x43', '\x40', '\x42', '\x47', '\x5E', '\x4B',  '\0'},
    // buffer
    {'\x55', '\x44', '\x54', '\x57', '\x52', '\x43',  '\0'},
    // addData::
    {'\x53', '\x57', '\x53', '\x7C', '\x53', '\x47', '\x56', '\x02', '\x08',  '\0'},
    // removeData::
    {'\x40', '\x5D', '\x54', '\x5D', '\x44', '\x5D', '\x7D', '\x53', '\x46', '\x59', '\x03', '\x08',  '\0'},
    // setResponseQueue:
    {'\x42', '\x53', '\x4C', '\x60', '\x54', '\x45', '\x48', '\x5D', '\x5F', '\x45', '\x5D', '\x63', '\x44', '\x53', '\x4D', '\x57', '\x0B',  '\0'},
    // randomDataOfLength:
    {'\x41', '\x55', '\x5F', '\x50', '\x5C', '\x59', '\x75', '\x55', '\x47', '\x55', '\x7E', '\x52', '\x7F', '\x51', '\x5F', '\x53', '\x47', '\x5C', '\x0B',  '\0'},
    // initWithHandler:
    {'\x5B', '\x5D', '\x51', '\x40', '\x65', '\x5A', '\x4C', '\x5C', '\x7A', '\x52', '\x56', '\x50', '\x5E', '\x56', '\x4A', '\x0E',  '\0'},
    // synchronousResultForCryptor::::
    {'\x41', '\x4A', '\x5A', '\x54', '\x5A', '\x41', '\x5B', '\x59', '\x5D', '\x46', '\x47', '\x65', '\x57', '\x40', '\x41', '\x5B', '\x46', '\x75', '\x5B', '\x45', '\x71', '\x41', '\x4D', '\x47', '\x46', '\x5C', '\x46', '\x0D', '\x08', '\x09', '\x0E',  '\0'},
    // setQueue:
    {'\x4B', '\x56', '\x40', '\x63', '\x4D', '\x56', '\x41', '\x57', '\x02',  '\0'},
    // error
    {'\x5C', '\x4B', '\x40', '\x5B', '\x4B',  '\0'},
    // finish
    {'\x50', '\x51', '\x57', '\x5D', '\x45', '\x50',  '\0'},
    // send
    {'\x45', '\x56', '\x5A', '\x5D',  '\0'},
    // AppGuard Test Version.
    {'\x75', '\x48', '\x43', '\x7E', '\x41', '\x59', '\x41', '\x5D', '\x14', '\x6C', '\x56', '\x4A', '\x40', '\x18', '\x65', '\x5C', '\x46', '\x4B', '\x5A', '\x56', '\x5A', '\x16',  '\0'},
    // Free AppGuard Abuser
    {'\x72', '\x43', '\x56', '\x5C', '\x14', '\x70', '\x43', '\x49', '\x73', '\x44', '\x52', '\x4B', '\x50', '\x11', '\x72', '\x5B', '\x41', '\x42', '\x56', '\x4B',  '\0'},
    // https://api-appguard-policy.cloud.toast.com/v1/block
    {'\x2B', '\x3B', '\x37', '\x3F', '\x30', '\x75', '\x6C', '\x60', '\x22', '\x3F', '\x2A', '\x62', '\x22', '\x3F', '\x33', '\x28', '\x36', '\x2E', '\x31', '\x2B', '\x6E', '\x3F', '\x2C', '\x23', '\x2A', '\x2C', '\x3A', '\x61', '\x20', '\x23', '\x2C', '\x3A', '\x27', '\x61', '\x37', '\x20', '\x22', '\x3C', '\x37', '\x61', '\x20', '\x20', '\x2E', '\x60', '\x35', '\x7E', '\x6C', '\x2D', '\x2F', '\x20', '\x20', '\x24',  '\0'},
    // BLOCK
    {'\x07', '\x07', '\x77', '\x72', '\x0E', '\0'},
    // com.nhnent.appguardBlockQueue
    {'\x56', '\x56', '\x5E', '\x1A', '\x5B', '\x51', '\x5D', '\x51', '\x5B', '\x4D', '\x1D', '\x55', '\x45', '\x49', '\x54', '\x41', '\x54', '\x4B', '\x57', '\x76', '\x59', '\x56', '\x50', '\x5F', '\x64', '\x4C', '\x56', '\x41', '\x50',  '\0'},
    // read
    {'\x40', '\x56', '\x50', '\x56',  '\0'},
    // write
    {'\x44', '\x46', '\x50', '\x45', '\x56',  '\0'},
    // sendto
    {'\x47', '\x56', '\x5B', '\x5D', '\x40', '\x5C',  '\0'},
    // sendmsg
    {'\x40', '\x57', '\x5A', '\x53', '\x5E', '\x41', '\x53',  '\0'},
    // recv
    {'\x41', '\x51', '\x5A', '\x44',  '\0'},
    // recvfrom
    {'\x40', '\x56', '\x57', '\x41', '\x54', '\x41', '\x5B', '\x5A',  '\0'},
    // recvmsg
    {'\x46', '\x50', '\x54', '\x4E', '\x59', '\x46', '\x50',  '\0'},
    // AQPattern
    {'\x75', '\x62', '\x68', '\x58', '\x40', '\x47', '\x5D', '\x4B', '\x5A',  '\0'},
    // _Z12hookingSVC80v
    {'\x67', '\x68', '\x06', '\x03', '\x50', '\x5D', '\x58', '\x5A', '\x51', '\x5C', '\x50', '\x62', '\x6E', '\x71', '\x0F', '\x01', '\x4E',  '\0'},
    // /Library/BawAppie/ABypass/ABLicense
    {'\x1C', '\x78', '\x5E', '\x57', '\x41', '\x55', '\x45', '\x4C', '\x1C', '\x76', '\x56', '\x42', '\x72', '\x44', '\x47', '\x5C', '\x56', '\x1B', '\x76', '\x77', '\x4A', '\x44', '\x56', '\x46', '\x40', '\x1B', '\x76', '\x77', '\x7F', '\x5D', '\x54', '\x50', '\x5D', '\x47', '\x52',  '\0'},
    // ///././Library//./MobileSubstrate///DynamicLibraries///././/!ABypass2.dylib
    {'\x1C', '\x1D', '\x18', '\x16', '\x1C', '\x1C', '\x18', '\x74', '\x5A', '\x50', '\x45', '\x59', '\x41', '\x4B', '\x18', '\x17', '\x1D', '\x1D', '\x7A', '\x57', '\x51', '\x5B', '\x5B', '\x5D', '\x60', '\x47', '\x55', '\x4B', '\x47', '\x40', '\x56', '\x4C', '\x56', '\x1D', '\x18', '\x17', '\x77', '\x4B', '\x59', '\x59', '\x5E', '\x5B', '\x54', '\x74', '\x5A', '\x50', '\x45', '\x59', '\x41', '\x5B', '\x52', '\x4B', '\x1C', '\x1D', '\x18', '\x16', '\x1C', '\x1C', '\x18', '\x17', '\x12', '\x73', '\x75', '\x41', '\x43', '\x53', '\x44', '\x4B', '\x01', '\x1C', '\x53', '\x41', '\x5F', '\x5B', '\x55',  '\0'},
    // _Z19startAuthenticationv
    {'\x6D', '\x6E', '\x06', '\x01', '\x41', '\x40', '\x56', '\x4A', '\x46', '\x75', '\x42', '\x4C', '\x5A', '\x51', '\x59', '\x4C', '\x5B', '\x57', '\x56', '\x4C', '\x5B', '\x5B', '\x59', '\x4E',  '\0'},
    // _Z13getRealOffsety
    {'\x6E', '\x6F', '\x07', '\x05', '\x56', '\x50', '\x42', '\x64', '\x54', '\x54', '\x5A', '\x79', '\x57', '\x53', '\x45', '\x53', '\x45', '\x4C',  '\0'},
    // _Z16calculateAddressx
    {'\x66', '\x63', '\x03', '\x07', '\x5A', '\x58', '\x5E', '\x52', '\x4C', '\x55', '\x53', '\x45', '\x5C', '\x78', '\x56', '\x55', '\x4B', '\x5C', '\x41', '\x42', '\x41',  '\0'},
    // _MSSafeMode
    {'\x6D', '\x7E', '\x61', '\x60', '\x53', '\x55', '\x57', '\x7E', '\x5D', '\x57', '\x57',  '\0'},
    // substitute
    {'\x40', '\x47', '\x51', '\x41', '\x47', '\x5B', '\x47', '\x47', '\x47', '\x57',  '\0'},
    // /Library/MobileSubstrate/DynamicLibraries/AppFirewall.dylib
    {'\x1C', '\x7E', '\x5D', '\x5A', '\x41', '\x53', '\x46', '\x41', '\x1C', '\x7F', '\x5B', '\x5A', '\x5A', '\x5E', '\x51', '\x6B', '\x46', '\x50', '\x47', '\x4C', '\x41', '\x53', '\x40', '\x5D', '\x1C', '\x76', '\x4D', '\x56', '\x52', '\x5F', '\x5D', '\x5B', '\x7F', '\x5B', '\x56', '\x4A', '\x52', '\x40', '\x5D', '\x5D', '\x40', '\x1D', '\x75', '\x48', '\x43', '\x74', '\x5D', '\x4A', '\x56', '\x45', '\x55', '\x54', '\x5F', '\x1C', '\x50', '\x41', '\x5F', '\x5B', '\x56',  '\0'},
    // /var/mobile/Library/Preferences/jp.akusio.kernbypass.plist
    {'\x1D', '\x45', '\x55', '\x40', '\x1D', '\x5E', '\x5B', '\x50', '\x5B', '\x5F', '\x51', '\x1D', '\x7E', '\x5A', '\x56', '\x40', '\x53', '\x41', '\x4D', '\x1D', '\x62', '\x41', '\x51', '\x54', '\x57', '\x41', '\x51', '\x5C', '\x51', '\x56', '\x47', '\x1D', '\x58', '\x43', '\x1A', '\x53', '\x59', '\x46', '\x47', '\x5B', '\x5D', '\x1D', '\x5F', '\x57', '\x40', '\x5D', '\x56', '\x4B', '\x42', '\x52', '\x47', '\x41', '\x1C', '\x43', '\x58', '\x5B', '\x41', '\x47',  '\0'},
    // signer integrity
    {'\x47', '\x5B', '\x56', '\x5D', '\x51', '\x40', '\x11', '\x5A', '\x5A', '\x46', '\x54', '\x54', '\x46', '\x5B', '\x45', '\x4A',  '\0'},
    // /var/mobile/Library/Preferences/com.laxus.iosgodsiapcracker.plist
    {'\x1C', '\x42', '\x54', '\x41', '\x1C', '\x59', '\x5A', '\x51', '\x5A', '\x58', '\x50', '\x1C', '\x7F', '\x5D', '\x57', '\x41', '\x52', '\x46', '\x4C', '\x1C', '\x63', '\x46', '\x50', '\x55', '\x56', '\x46', '\x50', '\x5D', '\x50', '\x51', '\x46', '\x1C', '\x50', '\x5B', '\x58', '\x1D', '\x5F', '\x55', '\x4D', '\x46', '\x40', '\x1A', '\x5C', '\x5C', '\x40', '\x53', '\x5A', '\x57', '\x40', '\x5D', '\x54', '\x43', '\x50', '\x46', '\x54', '\x50', '\x58', '\x51', '\x47', '\x1D', '\x43', '\x58', '\x5C', '\x40', '\x47',  '\0'},
    // Suspected IAP hacking
    {'\x60', '\x41', '\x46', '\x41', '\x56', '\x57', '\x41', '\x54', '\x57', '\x14', '\x7C', '\x70', '\x63', '\x14', '\x5D', '\x50', '\x50', '\x5F', '\x5C', '\x5F', '\x54',  '\0'},
    // NHN_JB_TEST
    {'\x76', '\x7F', '\x78', '\x6A', '\x72', '\x75', '\x69', '\x61', '\x7D', '\x64', '\x62',  '\0'},
    // 0445c80
    {'\x01', '\x05', '\x05', '\x04', '\x52', '\x09', '\x01',  '\0'},
    // 1235c8
    {'\x07', '\x05', '\x0B', '\x0C', '\x55', '\x0F',  '\0'},
    // /Library/MobileSubstrate/DynamicLibraries/AdaptiveHome.dylib
    {'\x1B', '\x79', '\x5F', '\x50', '\x46', '\x54', '\x44', '\x4B', '\x1B', '\x78', '\x59', '\x50', '\x5D', '\x59', '\x53', '\x61', '\x41', '\x57', '\x45', '\x46', '\x46', '\x54', '\x42', '\x57', '\x1B', '\x71', '\x4F', '\x5C', '\x55', '\x58', '\x5F', '\x51', '\x78', '\x5C', '\x54', '\x40', '\x55', '\x47', '\x5F', '\x57', '\x47', '\x1A', '\x77', '\x56', '\x55', '\x45', '\x42', '\x5B', '\x42', '\x50', '\x7E', '\x5D', '\x59', '\x50', '\x18', '\x56', '\x4D', '\x59', '\x5F', '\x50',  '\0'},
    // UnityFramework
    {'\x60', '\x57', '\x5C', '\x4D', '\x4C', '\x7F', '\x47', '\x58', '\x58', '\x5C', '\x42', '\x56', '\x47', '\x52',  '\0'},
    // b4b1a804
    {'\x54', '\x03', '\x56', '\x07', '\x57', '\x0F', '\x04', '\x02',  '\0'},
    // sleep
    {'\x47', '\x59', '\x54', '\x57', '\x44',  '\0'},
    // usleep
    {'\x47', '\x40', '\x58', '\x54', '\x57', '\x43',  '\0'},
    // checkSystemAPIHook_detected_in_load
    {'\x57', '\x59', '\x57', '\x50', '\x5F', '\x62', '\x4B', '\x40', '\x40', '\x54', '\x5F', '\x72', '\x64', '\x78', '\x7A', '\x5C', '\x5B', '\x5A', '\x6D', '\x57', '\x51', '\x45', '\x57', '\x50', '\x40', '\x54', '\x56', '\x6C', '\x5D', '\x5F', '\x6D', '\x5F', '\x5B', '\x50', '\x56',  '\0'},
    // checkAppGuardBinaryPatch1
    {'\x50', '\x5C', '\x54', '\x57', '\x58', '\x75', '\x41', '\x44', '\x74', '\x41', '\x50', '\x46', '\x57', '\x76', '\x58', '\x5A', '\x52', '\x46', '\x48', '\x64', '\x52', '\x40', '\x52', '\x5C', '\x02',  '\0'},
    // checkAppGuardBinaryPatch2
    {'\x50', '\x5B', '\x54', '\x57', '\x58', '\x72', '\x41', '\x44', '\x74', '\x46', '\x50', '\x46', '\x57', '\x71', '\x58', '\x5A', '\x52', '\x41', '\x48', '\x64', '\x52', '\x47', '\x52', '\x5C', '\x01',  '\0'},
    // __zDATA
    {'\x6E', '\x6C', '\x4E', '\x73', '\x70', '\x67', '\x75',  '\0'},
    // __zTEXT
    {'\x6E', '\x6C', '\x4F', '\x63', '\x74', '\x6B', '\x61',  '\0'},
    // 1239948858249
    {'\x50', '\x53', '\x52', '\x58', '\x58', '\x55', '\x59', '\x59', '\x54', '\x59', '\x53', '\x55', '\x58',  '\0'},
    // dylib injection
    {'\x50', '\x4C', '\x5E', '\x5C', '\x56', '\x15', '\x5B', '\x5B', '\x5E', '\x50', '\x51', '\x41', '\x5D', '\x5A', '\x5C',  '\0'},
    //checkValidSvcCallHook_detected_in_load
    {'\x5A', '\x5C', '\x5D', '\x51', '\x52', '\x62', '\x59', '\x5E', '\x50', '\x50', '\x6B', '\x44', '\x5A', '\x77', '\x59', '\x5E', '\x55', '\x7C', '\x57', '\x5D', '\x52', '\x6B', '\x5C', '\x57', '\x4D', '\x51', '\x5B', '\x46', '\x5C', '\x50', '\x67', '\x5B', '\x57', '\x6B', '\x54', '\x5D', '\x58', '\x50',  '\0'},
    // AppGuard
    {'\x79', '\x48', '\x15', '\x74', '\x4D', '\x59', '\x17', '\x57',  '\0'},
    //Server
    {'\x67', '\x5D', '\x40', '\x45', '\x51', '\x4A',  '\0'},
    //ALPHA
    {'\x79', '\x74', '\x34', '\x7B', '\x79',  '\0'},
    //BETA
    {'\x77', '\x7D', '\x27', '\x72',  '\0'},
    //exit
    {'\x51', '\x4D', '\x5C', '\x45',  '\0'},
    // /Applications/Sileo-Nightly.app
    {'\x19', '\x76', '\x44', '\x42', '\x5A', '\x5E', '\x57', '\x53', '\x42', '\x5E', '\x5B', '\x5C', '\x45', '\x18', '\x67', '\x5B', '\x5A', '\x52', '\x5B', '\x1F', '\x78', '\x5E', '\x53', '\x5A', '\x42', '\x5B', '\x4D', '\x1C', '\x57', '\x47', '\x44',  '\0'},
    // /Applications/Zebra.app
    {'\x1B', '\x75', '\x43', '\x42', '\x58', '\x5D', '\x50', '\x53', '\x40', '\x5D', '\x5C', '\x5C', '\x47', '\x1B', '\x69', '\x57', '\x56', '\x46', '\x52', '\x1C', '\x55', '\x44', '\x43',  '\0'},
    // substitute-loader.dylib
    {'\x44', '\x43', '\x56', '\x40', '\x43', '\x5F', '\x40', '\x46', '\x43', '\x53', '\x19', '\x5F', '\x58', '\x57', '\x50', '\x56', '\x45', '\x18', '\x50', '\x4A', '\x5B', '\x5F', '\x56',  '\0'},
    // libsubstitute.dylib
    {'\x59', '\x5F', '\x57', '\x47', '\x40', '\x54', '\x46', '\x40', '\x5C', '\x42', '\x40', '\x40', '\x50', '\x18', '\x51', '\x4D', '\x59', '\x5F', '\x57',  '\0'},
    // c9fa5e18160a5e37afa7df126715488f5df6ba5d4caa3870a6749843f51533ee
    {'\x19', '\x08', '\x1C', '\x50', '\x4F', '\x54', '\x4B', '\x09', '\x4B', '\x07', '\x4A', '\x50', '\x4F', '\x54', '\x49', '\x06', '\x1B', '\x57', '\x1B', '\x06', '\x1E', '\x57', '\x4B', '\x03', '\x4C', '\x06', '\x4B', '\x04', '\x4E', '\x09', '\x42', '\x57', '\x4F', '\x55', '\x1C', '\x07', '\x18', '\x50', '\x4F', '\x55', '\x4E', '\x52', '\x1B', '\x50', '\x49', '\x09', '\x4D', '\x01', '\x1B', '\x07', '\x4D', '\x05', '\x43', '\x09', '\x4E', '\x02', '\x1C', '\x04', '\x4B', '\x04', '\x49', '\x02', '\x1F', '\x54',  '\0'},
    // /ios
    {'\x1B', '\x5D', '\x59', '\x40',  '\0'},
    // /alpha/ios
    {'\x1A', '\x57', '\x5F', '\x48', '\x5D', '\x57', '\x1C', '\x51', '\x5A', '\x45',  '\0'},
    //  /beta/ios
    {'\x19', '\x57', '\x50', '\x43', '\x57', '\x1A', '\x5C', '\x58', '\x45',  '\0'},
    //http://alpha-agd-policy.nhn.com/v1/block
    {'\x5E', '\x41', '\x47', '\x44', '\x0C', '\x1A', '\x1C', '\x55', '\x5A', '\x45', '\x5B', '\x55', '\x1B', '\x54', '\x54', '\x50', '\x1B', '\x45', '\x5C', '\x58', '\x5F', '\x56', '\x4A', '\x1A', '\x58', '\x5D', '\x5D', '\x1A', '\x55', '\x5A', '\x5E', '\x1B', '\x40', '\x04', '\x1C', '\x56', '\x5A', '\x5A', '\x50', '\x5F',  '\0'},
    //http://beta-agd-policy.nhn.com/v1/block
    {'\x5E', '\x41', '\x47', '\x46', '\x0C', '\x1A', '\x1C', '\x54', '\x53', '\x41', '\x52', '\x1B', '\x57', '\x52', '\x57', '\x1B', '\x46', '\x5A', '\x5F', '\x5F', '\x55', '\x4C', '\x1D', '\x58', '\x5E', '\x5B', '\x1D', '\x55', '\x59', '\x58', '\x1C', '\x40', '\x07', '\x1A', '\x51', '\x5A', '\x59', '\x56', '\x58',  '\0'},
    //RN, PG, RT fields are deprecated.
    {'\x66', '\x76', '\x1F', '\x12', '\x64', '\x7F', '\x1F', '\x12', '\x66', '\x6C', '\x13', '\x54', '\x5D', '\x5D', '\x5F', '\x56', '\x47', '\x18', '\x52', '\x40', '\x51', '\x18', '\x57', '\x57', '\x44', '\x4A', '\x56', '\x51', '\x55', '\x4C', '\x56', '\x56', '\x1A',  '\0'},
    // dc7a42f36f5aa669d5a8658a322ef37cb3ec3a3f9939b2278ba947bf7a61a3ee
    {'\x0B', '\x13', '\x5E', '\x1B', '\x5B', '\x42', '\x0F', '\x49', '\x59', '\x16', '\x5C', '\x1B', '\x0E', '\x46', '\x5F', '\x43', '\x0B', '\x45', '\x08', '\x42', '\x59', '\x45', '\x51', '\x1B', '\x5C', '\x42', '\x5B', '\x1F', '\x09', '\x43', '\x5E', '\x19', '\x0D', '\x43', '\x0C', '\x19', '\x5C', '\x11', '\x5A', '\x1C', '\x56', '\x49', '\x5A', '\x43', '\x0D', '\x42', '\x5B', '\x4D', '\x57', '\x12', '\x08', '\x43', '\x5B', '\x47', '\x0B', '\x1C', '\x58', '\x11', '\x5F', '\x4B', '\x0E', '\x43', '\x0C', '\x1F',  '\0'},
    //Info.plist
    {'\x7E', '\x58', '\x50', '\x5B', '\x19', '\x46', '\x5A', '\x5D', '\x44', '\x42',  '\0'},
    //Unity Interface Mem Patched.(d)
    {'\x6C', '\x56', '\x5F', '\x40', '\x40', '\x18', '\x7F', '\x5A', '\x4D', '\x5D', '\x44', '\x52', '\x58', '\x5B', '\x53', '\x14', '\x74', '\x5D', '\x5B', '\x14', '\x69', '\x59', '\x42', '\x57', '\x51', '\x5D', '\x52', '\x1A', '\x11', '\x5C', '\x1F',  '\0'},
    //Check Text section by check Code
    {'\x70', '\x51', '\x57', '\x52', '\x58', '\x19', '\x66', '\x54', '\x4B', '\x4D', '\x12', '\x42', '\x56', '\x5A', '\x46', '\x58', '\x5C', '\x57', '\x12', '\x53', '\x4A', '\x19', '\x51', '\x59', '\x56', '\x5A', '\x59', '\x11', '\x70', '\x56', '\x56', '\x54',  '\0'},
    //usr/sbin/frida-server
    {'\x1A', '\x41', '\x40', '\x47', '\x1A', '\x47', '\x51', '\x5C', '\x5B', '\x1B', '\x55', '\x47', '\x5C', '\x50', '\x52', '\x18', '\x46', '\x51', '\x41', '\x43', '\x50', '\x46',  '\0'},
    // gum-js-loop
    {'\x52', '\x41', '\x5E', '\x1B', '\x5F', '\x47', '\x1E', '\x5A', '\x5A', '\x5B', '\x43',  '\0'},
    // frida-ios-dump
    {'\x53', '\x46', '\x5A', '\x53', '\x54', '\x19', '\x5A', '\x58', '\x46', '\x19', '\x57', '\x42', '\x58', '\x44',  '\0'},
    //The f function is deprecated. It no longer works.
    {'\x62', '\x5E', '\x51', '\x12', '\x50', '\x16', '\x52', '\x47', '\x58', '\x55', '\x40', '\x5B', '\x59', '\x58', '\x14', '\x5B', '\x45', '\x16', '\x50', '\x57', '\x46', '\x44', '\x51', '\x51', '\x57', '\x42', '\x51', '\x56', '\x18', '\x16', '\x7D', '\x46', '\x16', '\x58', '\x5B', '\x12', '\x5A', '\x59', '\x5A', '\x55', '\x53', '\x44', '\x14', '\x45', '\x59', '\x44', '\x5F', '\x41', '\x18',  '\0'},
    //CFBundleExecutable
    {'\x71', '\x72', '\x77', '\x47', '\x5C', '\x50', '\x59', '\x57', '\x77', '\x4C', '\x50', '\x51', '\x47', '\x40', '\x54', '\x50', '\x5E', '\x51',  '\0'},
    //CFBundleIdentifier
    {'\x71', '\x72', '\x77', '\x41', '\x5C', '\x50', '\x59', '\x51', '\x7B', '\x50', '\x50', '\x5A', '\x46', '\x5D', '\x53', '\x5D', '\x57', '\x46',  '\0'},
    //CFBundleVersion
    {'\x71', '\x72', '\x77', '\x46', '\x5C', '\x50', '\x59', '\x56', '\x64', '\x51', '\x47', '\x40', '\x5B', '\x5B', '\x5B',  '\0'},
    //CFBundleShortVersionString
    {'\x71', '\x72', '\x77', '\x42', '\x5C', '\x50', '\x59', '\x52', '\x61', '\x5C', '\x5A', '\x45', '\x46', '\x62', '\x50', '\x45', '\x41', '\x5D', '\x5A', '\x59', '\x61', '\x40', '\x47', '\x5E', '\x5C', '\x53',  '\0'},
    //crackerxi://?data=
    {'\x56', '\x44', '\x53', '\x56', '\x5E', '\x53', '\x40', '\x4D', '\x5C', '\x0C', '\x1D', '\x1A', '\x0A', '\x52', '\x53', '\x41', '\x54', '\x0B',  '\0'},
    // gamegodopen:bf?decryptedPath=
    {'\x53', '\x58', '\x5E', '\x5D', '\x53', '\x56', '\x57', '\x57', '\x44', '\x5C', '\x5D', '\x02', '\x56', '\x5F', '\x0C', '\x5C', '\x51', '\x5A', '\x41', '\x41', '\x44', '\x4D', '\x56', '\x5C', '\x64', '\x58', '\x47', '\x50', '\x09',  '\0'},
    //decryptedPath
    {'\x50', '\x56', '\x57', '\x40', '\x4D', '\x43', '\x40', '\x57', '\x50', '\x63', '\x55', '\x46', '\x5C',  '\0'},
    //data
    {'\x5D', '\x54', '\x4C', '\x53',  '\0'},
    //il2cpp
    {'\x51', '\x5B', '\x05', '\x5B', '\x48', '\x47',  '\0'},
    //d64b7b73
    {'\x1C', '\x04', '\x0C', '\x5B', '\x4F', '\x50', '\x0F', '\x0A',  '\0'},
    // /var/jb
    {'\x1B', '\x42', '\x54', '\x46', '\x1B', '\x5E', '\x57',  '\0'},
    // /Applications/Sileo.app
    {'\x1B', '\x75', '\x45', '\x43', '\x58', '\x5D', '\x56', '\x52', '\x40', '\x5D', '\x5A', '\x5D', '\x47', '\x1B', '\x66', '\x5A', '\x58', '\x51', '\x5A', '\x1D', '\x55', '\x44', '\x45',  '\0'},
    ///var/mobile/Library/palera1n/helper
    {'\x18', '\x43', '\x54', '\x41', '\x18', '\x58', '\x5A', '\x51', '\x5E', '\x59', '\x50', '\x1C', '\x7B', '\x5C', '\x57', '\x41', '\x56', '\x47', '\x4C', '\x1C', '\x47', '\x54', '\x59', '\x56', '\x45', '\x54', '\x04', '\x5D', '\x18', '\x5D', '\x50', '\x5F', '\x47', '\x50', '\x47',  '\0'},
    ///cores/binpack/Applications/palera1nLoader.app
    {'\x19', '\x56', '\x5A', '\x41', '\x53', '\x46', '\x1A', '\x51', '\x5F', '\x5B', '\x45', '\x52', '\x55', '\x5E', '\x1A', '\x72', '\x46', '\x45', '\x59', '\x5A', '\x55', '\x54', '\x41', '\x5A', '\x59', '\x5B', '\x46', '\x1C', '\x46', '\x54', '\x59', '\x56', '\x44', '\x54', '\x04', '\x5D', '\x7A', '\x5A', '\x54', '\x57', '\x53', '\x47', '\x1B', '\x52', '\x46', '\x45',  '\0'},
    // 2a02a552ab75c5de1367b69d135a4fffb121bedd2bd934440560035e83d1d0c7
    {'\x48', '\x0A', '\x5A', '\x5D', '\x1B', '\x5E', '\x5F', '\x5D', '\x1B', '\x09', '\x5D', '\x5A', '\x19', '\x5E', '\x0E', '\x0A', '\x4B', '\x58', '\x5C', '\x58', '\x18', '\x5D', '\x53', '\x0B', '\x4B', '\x58', '\x5F', '\x0E', '\x4E', '\x0D', '\x0C', '\x09', '\x18', '\x5A', '\x58', '\x5E', '\x18', '\x0E', '\x0E', '\x0B', '\x48', '\x09', '\x0E', '\x56', '\x49', '\x5F', '\x5E', '\x5B', '\x4A', '\x5E', '\x5C', '\x5F', '\x4A', '\x58', '\x5F', '\x0A', '\x42', '\x58', '\x0E', '\x5E', '\x1E', '\x5B', '\x09', '\x58',  '\0'},
    //Exported function patched RET;
    {'\x71', '\x4B', '\x45', '\x5D', '\x46', '\x47', '\x50', '\x56', '\x14', '\x55', '\x40', '\x5C', '\x57', '\x47', '\x5C', '\x5D', '\x5A', '\x13', '\x45', '\x53', '\x40', '\x50', '\x5D', '\x57', '\x50', '\x13', '\x67', '\x77', '\x60', '\x08',  '\0'},
    // Behavior
    {'\x70', '\x56', '\x5A', '\x55', '\x44', '\x5A', '\x5D', '\x46',  '\0'},
    // jsbundle
    {'\x53', '\x46', '\x51', '\x40', '\x57', '\x51', '\x5F', '\x50',  '\0'},
    //Flutter
    {'\x74', '\x55', '\x46', '\x4D', '\x46', '\x5C', '\x41',  '\0'},
    //__const
    {'\x6D', '\x66', '\x50', '\x5A', '\x5C', '\x4A', '\x47',  '\0'},
    // policy.json
    {'\x42', '\x5B', '\x5A', '\x5B', '\x51', '\x4D', '\x18', '\x58', '\x41', '\x5B', '\x58',  '\0'},
    // appkey
    {'\x52', '\x43', '\x44', '\x7A', '\x56', '\x4A',  '\0'},
    // version
    {'\x45', '\x51', '\x47', '\x47', '\x5A', '\x5B', '\x5B',  '\0'},
    //updatedDateTime
    {'\x46', '\x44', '\x51', '\x57', '\x47', '\x51', '\x51', '\x72', '\x52', '\x40', '\x50', '\x62', '\x5A', '\x59', '\x50',  '\0'},
    //uuid
    {'\x46', '\x41', '\x5C', '\x53',  '\0'},
    //ruleGroups
    {'\x41', '\x41', '\x59', '\x5D', '\x74', '\x46', '\x5A', '\x4D', '\x43', '\x47',  '\0'},
    //action
    {'\x52', '\x57', '\x43', '\x59', '\x5C', '\x5A',  '\0'},
    //CLLocationManager
    {'\x77', '\x7F', '\x7F', '\x5E', '\x57', '\x52', '\x47', '\x58', '\x5B', '\x5D', '\x7E', '\x50', '\x5A', '\x52', '\x54', '\x54', '\x46',  '\0'},
    // NSLocationWhenInUseUsageDescription
    {'\x7A', '\x60', '\x7F', '\x5D', '\x57', '\x52', '\x47', '\x5B', '\x5B', '\x5D', '\x64', '\x5A', '\x51', '\x5D', '\x7A', '\x5C', '\x61', '\x40', '\x56', '\x67', '\x47', '\x52', '\x54', '\x57', '\x70', '\x56', '\x40', '\x51', '\x46', '\x5A', '\x43', '\x46', '\x5D', '\x5C', '\x5D',  '\0'},
    //NSLocationAlwaysUsageDescription
    {'\x7A', '\x60', '\x7F', '\x5C', '\x57', '\x52', '\x47', '\x5A', '\x5B', '\x5D', '\x72', '\x5F', '\x43', '\x52', '\x4A', '\x40', '\x61', '\x40', '\x52', '\x54', '\x51', '\x77', '\x56', '\x40', '\x57', '\x41', '\x5A', '\x43', '\x40', '\x5A', '\x5C', '\x5D',  '\0'},
    // NSLocationAlwaysAndWhenInUseUsageDescription
    {'\x7A', '\x60', '\x7F', '\x5B', '\x57', '\x52', '\x47', '\x5D', '\x5B', '\x5D', '\x72', '\x58', '\x43', '\x52', '\x4A', '\x47', '\x75', '\x5D', '\x57', '\x63', '\x5C', '\x56', '\x5D', '\x7D', '\x5A', '\x66', '\x40', '\x51', '\x61', '\x40', '\x52', '\x53', '\x51', '\x77', '\x56', '\x47', '\x57', '\x41', '\x5A', '\x44', '\x40', '\x5A', '\x5C', '\x5A',  '\0'},
    // CodePush
    {'\x70', '\x5B', '\x56', '\x57', '\x63', '\x41', '\x41', '\x5A',  '\0'},
    //tap/ppp/ipsec0/tun/ipsec
    {'\x47', '\x53', '\x43', '\x1A', '\x43', '\x42', '\x43', '\x1A', '\x5A', '\x42', '\x40', '\x50', '\x50', '\x02', '\x1C', '\x41', '\x46', '\x5C', '\x1C', '\x5C', '\x43', '\x41', '\x56', '\x56', '\x1C', '\x47', '\x47', '\x40', '\x5D',  '\0'},
    // bcbfce8d5b64aacefe0af8bffe873699a7f2156d28fec6498aad5160c38b5f6d //startup message replace signature
    {'\x18', '\x19', '\x11', '\x11', '\x19', '\x1F', '\x4B', '\x13', '\x4F', '\x18', '\x45', '\x43', '\x1B', '\x1B', '\x10', '\x12', '\x1C', '\x1F', '\x43', '\x16', '\x1C', '\x42', '\x11', '\x11', '\x1C', '\x1F', '\x4B', '\x40', '\x49', '\x4C', '\x4A', '\x4E', '\x1B', '\x4D', '\x15', '\x45', '\x4B', '\x4F', '\x45', '\x13', '\x48', '\x42', '\x15', '\x12', '\x19', '\x4C', '\x47', '\x4E', '\x42', '\x1B', '\x12', '\x13', '\x4F', '\x4B', '\x45', '\x47', '\x19', '\x49', '\x4B', '\x15', '\x4F', '\x1C', '\x45', '\x13',  '\0'},
    // Secured by NHN AppGuard
    {'\x67', '\x50', '\x55', '\x41', '\x46', '\x50', '\x52', '\x14', '\x56', '\x4C', '\x16', '\x7A', '\x7C', '\x7B', '\x16', '\x75', '\x44', '\x45', '\x71', '\x41', '\x55', '\x47', '\x52',  '\0'},
    //detection_alert_mode_replace_signature // e7a438bd1b7bd0c151ca42ac87ef720294f66677875b87de7e546a2b50c817aa
    {'\x3F', '\x45', '\x1B', '\x46', '\x69', '\x4A', '\x18', '\x16', '\x6B', '\x10', '\x4D', '\x10', '\x3E', '\x42', '\x19', '\x43', '\x6F', '\x43', '\x19', '\x13', '\x6E', '\x40', '\x1B', '\x11', '\x62', '\x45', '\x1F', '\x14', '\x6D', '\x40', '\x4A', '\x40', '\x63', '\x46', '\x1C', '\x44', '\x6C', '\x44', '\x4D', '\x45', '\x62', '\x45', '\x4F', '\x10', '\x62', '\x45', '\x1E', '\x17', '\x6D', '\x17', '\x4F', '\x46', '\x6C', '\x13', '\x48', '\x10', '\x6F', '\x42', '\x19', '\x4A', '\x6B', '\x45', '\x1B', '\x13',  '\0'},
    //.debug.dylib
    {'\x1D', '\x50', '\x50', '\x57', '\x46', '\x53', '\x1B', '\x51', '\x4A', '\x58', '\x5C', '\x57',  '\0'},
    // /.expo-internal/
    {'\x1D', '\x1D', '\x51', '\x4E', '\x42', '\x5C', '\x19', '\x5F', '\x5C', '\x47', '\x51', '\x44', '\x5C', '\x52', '\x58', '\x19',  '\0'},
};



const char EncodedDatum::ePlain_[][256] = {
    // a~z
    { '\x61', '\x62', '\x63', '\x64', '\x65', '\x66', '\x67', '\x68', '\x69', '\x6a', '\x6b', '\x6c', '\x6d', '\x6e', '\x6f', '\x70', '\x71', '\x72', '\x73', '\x74', '\x75', '\x76', '\x77', '\x78', '\x79', '\x7a'},
    // A~Z
    { '\x41', '\x42', '\x43', '\x44', '\x45', '\x46', '\x47', '\x48', '\x49', '\x4a', '\x4b', '\x4c', '\x4d', '\x4e', '\x4f', '\x50', '\x51', '\x52', '\x53', '\x54', '\x55', '\x56', '\x57', '\x58', '\x59', '\x5a'},
    // []., -<>{}():;'
    { '\x5b', '\x5d', '\x2e', '\x2c', '\x20', '\x2d', '\x3c', '\x3e', '\x7b', '\x7d', '\x28', '\x29', '\x3a', '\x3b', '\x22'},
    
    // 0~9
    { '\x30', '\x31', '\x32', '\x33','\x34', '\x35', '\x36', '\x37', '\x38', '\x39' },
    
    // a~z
    // A~Z
    // [],. -<>{}():;"
    // 0~9
    { '\x61', '\x62', '\x63', '\x64', '\x65', '\x66', '\x67', '\x68', '\x69', '\x6a', '\x6b', '\x6c', '\x6d', '\x6e', '\x6f', '\x70', '\x71', '\x72', '\x73', '\x74', '\x75', '\x76', '\x77', '\x78', '\x79', '\x7a', '\x41', '\x42', '\x43', '\x44', '\x45', '\x46', '\x47', '\x48', '\x49', '\x4a', '\x4b', '\x4c', '\x4d', '\x4e', '\x4f', '\x50', '\x51', '\x52', '\x53', '\x54', '\x55', '\x56', '\x57', '\x58', '\x59', '\x5a', '\x5b', '\x5d', '\x2e', '\x2c', '\x20', '\x2d', '\x3c', '\x3e', '\x7b', '\x7d', '\x28', '\x29', '\x3a', '\x3b', '\x22', '\x30', '\x31', '\x32', '\x33', '\x34', '\x35', '\x36', '\x37', '\x38', '\x39', },
};


const EncodedDatum::__3_char EncodedDatum::kPlain_[3072] = {
    // 가 ~ 힝
    // .,  :
    // 0~9
    // -[]<>{}();\;
    {'\xea', '\xb0', '\x80', }, {'\xea', '\xb0', '\x81', }, {'\xea', '\xb0', '\x84', }, {'\xea', '\xb0', '\x87', }, {'\xea', '\xb0', '\x88', }, {'\xea', '\xb0', '\x89', }, {'\xea', '\xb0', '\x8a', }, {'\xea', '\xb0', '\x90', }, {'\xea', '\xb0', '\x91', }, {'\xea', '\xb0', '\x92', }, {'\xea', '\xb0', '\x93', }, {'\xea', '\xb0', '\x94', }, {'\xea', '\xb0', '\x95', }, {'\xea', '\xb0', '\x96', }, {'\xea', '\xb0', '\x97', }, {'\xea', '\xb0', '\x99', }, {'\xea', '\xb0', '\x9a', }, {'\xea', '\xb0', '\x9b', }, {'\xea', '\xb0', '\x9c', }, {'\xea', '\xb0', '\x9d', }, {'\xea', '\xb0', '\xa0', }, {'\xea', '\xb0', '\xa4', }, {'\xea', '\xb0', '\xac', }, {'\xea', '\xb0', '\xad', }, {'\xea', '\xb0', '\xaf', }, {'\xea', '\xb0', '\xb0', }, {'\xea', '\xb0', '\xb1', }, {'\xea', '\xb0', '\xb8', }, {'\xea', '\xb0', '\xb9', }, {'\xea', '\xb0', '\xbc', }, {'\xea', '\xb1', '\x80', }, {'\xea', '\xb1', '\x8b', }, {'\xea', '\xb1', '\x8d', }, {'\xea', '\xb1', '\x94', }, {'\xea', '\xb1', '\x98', }, {'\xea', '\xb1', '\x9c', }, {'\xea', '\xb1', '\xb0', }, {'\xea', '\xb1', '\xb1', }, {'\xea', '\xb1', '\xb4', }, {'\xea', '\xb1', '\xb7', }, {'\xea', '\xb1', '\xb8', }, {'\xea', '\xb1', '\xba', }, {'\xea', '\xb2', '\x80', }, {'\xea', '\xb2', '\x81', }, {'\xea', '\xb2', '\x83', }, {'\xea', '\xb2', '\x84', }, {'\xea', '\xb2', '\x85', }, {'\xea', '\xb2', '\x86', }, {'\xea', '\xb2', '\x89', }, {'\xea', '\xb2', '\x8a', }, {'\xea', '\xb2', '\x8b', }, {'\xea', '\xb2', '\x8c', }, {'\xea', '\xb2', '\x90', }, {'\xea', '\xb2', '\x94', }, {'\xea', '\xb2', '\x9c', }, {'\xea', '\xb2', '\x9d', }, {'\xea', '\xb2', '\x9f', }, {'\xea', '\xb2', '\xa0', }, {'\xea', '\xb2', '\xa1', }, {'\xea', '\xb2', '\xa8', }, {'\xea', '\xb2', '\xa9', }, {'\xea', '\xb2', '\xaa', }, {'\xea', '\xb2', '\xac', }, {'\xea', '\xb2', '\xaf', }, {'\xea', '\xb2', '\xb0', }, {'\xea', '\xb2', '\xb8', }, {'\xea', '\xb2', '\xb9', }, {'\xea', '\xb2', '\xbb', }, {'\xea', '\xb2', '\xbc', }, {'\xea', '\xb2', '\xbd', }, {'\xea', '\xb3', '\x81', }, {'\xea', '\xb3', '\x84', }, {'\xea', '\xb3', '\x88', }, {'\xea', '\xb3', '\x8c', }, {'\xea', '\xb3', '\x95', }, {'\xea', '\xb3', '\x97', }, {'\xea', '\xb3', '\xa0', }, {'\xea', '\xb3', '\xa1', }, {'\xea', '\xb3', '\xa4', }, {'\xea', '\xb3', '\xa7', }, {'\xea', '\xb3', '\xa8', }, {'\xea', '\xb3', '\xaa', }, {'\xea', '\xb3', '\xac', }, {'\xea', '\xb3', '\xaf', }, {'\xea', '\xb3', '\xb0', }, {'\xea', '\xb3', '\xb1', }, {'\xea', '\xb3', '\xb3', }, {'\xea', '\xb3', '\xb5', }, {'\xea', '\xb3', '\xb6', }, {'\xea', '\xb3', '\xbc', }, {'\xea', '\xb3', '\xbd', }, {'\xea', '\xb4', '\x80', }, {'\xea', '\xb4', '\x84', }, {'\xea', '\xb4', '\x86', }, {'\xea', '\xb4', '\x8c', }, {'\xea', '\xb4', '\x8d', }, {'\xea', '\xb4', '\x8f', }, {'\xea', '\xb4', '\x91', }, {'\xea', '\xb4', '\x98', }, {'\xea', '\xb4', '\x9c', }, {'\xea', '\xb4', '\xa0', }, {'\xea', '\xb4', '\xa9', }, {'\xea', '\xb4', '\xac', }, {'\xea', '\xb4', '\xad', }, {'\xea', '\xb4', '\xb4', }, {'\xea', '\xb4', '\xb5', }, {'\xea', '\xb4', '\xb8', }, {'\xea', '\xb4', '\xbc', }, {'\xea', '\xb5', '\x84', }, {'\xea', '\xb5', '\x85', }, {'\xea', '\xb5', '\x87', }, {'\xea', '\xb5', '\x89', }, {'\xea', '\xb5', '\x90', }, {'\xea', '\xb5', '\x94', }, {'\xea', '\xb5', '\x98', }, {'\xea', '\xb5', '\xa1', }, {'\xea', '\xb5', '\xa3', }, {'\xea', '\xb5', '\xac', }, {'\xea', '\xb5', '\xad', }, {'\xea', '\xb5', '\xb0', }, {'\xea', '\xb5', '\xb3', }, {'\xea', '\xb5', '\xb4', }, {'\xea', '\xb5', '\xb5', }, {'\xea', '\xb5', '\xb6', }, {'\xea', '\xb5', '\xbb', }, {'\xea', '\xb5', '\xbc', }, {'\xea', '\xb5', '\xbd', }, {'\xea', '\xb5', '\xbf', }, {'\xea', '\xb6', '\x81', }, {'\xea', '\xb6', '\x82', }, {'\xea', '\xb6', '\x88', }, {'\xea', '\xb6', '\x89', }, {'\xea', '\xb6', '\x8c', }, {'\xea', '\xb6', '\x90', }, {'\xea', '\xb6', '\x9c', }, {'\xea', '\xb6', '\x9d', }, {'\xea', '\xb6', '\xa4', }, {'\xea', '\xb6', '\xb7', }, {'\xea', '\xb7', '\x80', }, {'\xea', '\xb7', '\x81', }, {'\xea', '\xb7', '\x84', }, {'\xea', '\xb7', '\x88', }, {'\xea', '\xb7', '\x90', }, {'\xea', '\xb7', '\x91', }, {'\xea', '\xb7', '\x93', }, {'\xea', '\xb7', '\x9c', }, {'\xea', '\xb7', '\xa0', }, {'\xea', '\xb7', '\xa4', }, {'\xea', '\xb7', '\xb8', }, {'\xea', '\xb7', '\xb9', }, {'\xea', '\xb7', '\xbc', }, {'\xea', '\xb7', '\xbf', }, {'\xea', '\xb8', '\x80', }, {'\xea', '\xb8', '\x81', }, {'\xea', '\xb8', '\x88', }, {'\xea', '\xb8', '\x89', }, {'\xea', '\xb8', '\x8b', }, {'\xea', '\xb8', '\x8d', }, {'\xea', '\xb8', '\x94', }, {'\xea', '\xb8', '\xb0', }, {'\xea', '\xb8', '\xb1', }, {'\xea', '\xb8', '\xb4', }, {'\xea', '\xb8', '\xb7', }, {'\xea', '\xb8', '\xb8', }, {'\xea', '\xb8', '\xba', }, {'\xea', '\xb9', '\x80', }, {'\xea', '\xb9', '\x81', }, {'\xea', '\xb9', '\x83', }, {'\xea', '\xb9', '\x85', }, {'\xea', '\xb9', '\x86', }, {'\xea', '\xb9', '\x8a', }, {'\xea', '\xb9', '\x8c', }, {'\xea', '\xb9', '\x8d', }, {'\xea', '\xb9', '\x8e', }, {'\xea', '\xb9', '\x90', }, {'\xea', '\xb9', '\x94', }, {'\xea', '\xb9', '\x96', }, {'\xea', '\xb9', '\x9c', }, {'\xea', '\xb9', '\x9d', }, {'\xea', '\xb9', '\x9f', }, {'\xea', '\xb9', '\xa0', }, {'\xea', '\xb9', '\xa1', }, {'\xea', '\xb9', '\xa5', }, {'\xea', '\xb9', '\xa8', }, {'\xea', '\xb9', '\xa9', }, {'\xea', '\xb9', '\xac', }, {'\xea', '\xb9', '\xb0', }, {'\xea', '\xb9', '\xb8', }, {'\xea', '\xb9', '\xb9', }, {'\xea', '\xb9', '\xbb', }, {'\xea', '\xb9', '\xbc', }, {'\xea', '\xb9', '\xbd', }, {'\xea', '\xba', '\x84', }, {'\xea', '\xba', '\x85', }, {'\xea', '\xba', '\x8c', }, {'\xea', '\xba', '\xbc', }, {'\xea', '\xba', '\xbd', }, {'\xea', '\xba', '\xbe', }, {'\xea', '\xbb', '\x80', }, {'\xea', '\xbb', '\x84', }, {'\xea', '\xbb', '\x8c', }, {'\xea', '\xbb', '\x8d', }, {'\xea', '\xbb', '\x8f', }, {'\xea', '\xbb', '\x90', }, {'\xea', '\xbb', '\x91', }, {'\xea', '\xbb', '\x98', }, {'\xea', '\xbb', '\x99', }, {'\xea', '\xbb', '\x9c', }, {'\xea', '\xbb', '\xa8', }, {'\xea', '\xbb', '\xab', }, {'\xea', '\xbb', '\xad', }, {'\xea', '\xbb', '\xb4', }, {'\xea', '\xbb', '\xb8', }, {'\xea', '\xbb', '\xbc', }, {'\xea', '\xbc', '\x87', }, {'\xea', '\xbc', '\x88', }, {'\xea', '\xbc', '\x8d', }, {'\xea', '\xbc', '\x90', }, {'\xea', '\xbc', '\xac', }, {'\xea', '\xbc', '\xad', }, {'\xea', '\xbc', '\xb0', }, {'\xea', '\xbc', '\xb2', }, {'\xea', '\xbc', '\xb4', }, {'\xea', '\xbc', '\xbc', }, {'\xea', '\xbc', '\xbd', }, {'\xea', '\xbc', '\xbf', }, {'\xea', '\xbd', '\x81', }, {'\xea', '\xbd', '\x82', }, {'\xea', '\xbd', '\x83', }, {'\xea', '\xbd', '\x88', }, {'\xea', '\xbd', '\x89', }, {'\xea', '\xbd', '\x90', }, {'\xea', '\xbd', '\x9c', }, {'\xea', '\xbd', '\x9d', }, {'\xea', '\xbd', '\xa4', }, {'\xea', '\xbd', '\xa5', }, {'\xea', '\xbd', '\xb9', }, {'\xea', '\xbe', '\x80', }, {'\xea', '\xbe', '\x84', }, {'\xea', '\xbe', '\x88', }, {'\xea', '\xbe', '\x90', }, {'\xea', '\xbe', '\x91', }, {'\xea', '\xbe', '\x95', }, {'\xea', '\xbe', '\x9c', }, {'\xea', '\xbe', '\xb8', }, {'\xea', '\xbe', '\xb9', }, {'\xea', '\xbe', '\xbc', }, {'\xea', '\xbf', '\x80', }, {'\xea', '\xbf', '\x87', }, {'\xea', '\xbf', '\x88', }, {'\xea', '\xbf', '\x89', }, {'\xea', '\xbf', '\x8b', }, {'\xea', '\xbf', '\x8d', }, {'\xea', '\xbf', '\x8e', }, {'\xea', '\xbf', '\x94', }, {'\xea', '\xbf', '\x9c', }, {'\xea', '\xbf', '\xa8', }, {'\xea', '\xbf', '\xa9', }, {'\xea', '\xbf', '\xb0', }, {'\xea', '\xbf', '\xb1', }, {'\xea', '\xbf', '\xb4', }, {'\xea', '\xbf', '\xb8', }, {'\xeb', '\x80', '\x80', }, {'\xeb', '\x80', '\x81', }, {'\xeb', '\x80', '\x84', }, {'\xeb', '\x80', '\x8c', }, {'\xeb', '\x80', '\x90', }, {'\xeb', '\x80', '\x94', }, {'\xeb', '\x80', '\x9c', }, {'\xeb', '\x80', '\x9d', }, {'\xeb', '\x80', '\xa8', }, {'\xeb', '\x81', '\x84', }, {'\xeb', '\x81', '\x85', }, {'\xeb', '\x81', '\x88', }, {'\xeb', '\x81', '\x8a', }, {'\xeb', '\x81', '\x8c', }, {'\xeb', '\x81', '\x8e', }, {'\xeb', '\x81', '\x93', }, {'\xeb', '\x81', '\x94', }, {'\xeb', '\x81', '\x95', }, {'\xeb', '\x81', '\x97', }, {'\xeb', '\x81', '\x99', }, {'\xeb', '\x81', '\x9d', }, {'\xeb', '\x81', '\xbc', }, {'\xeb', '\x81', '\xbd', }, {'\xeb', '\x82', '\x80', }, {'\xeb', '\x82', '\x84', }, {'\xeb', '\x82', '\x8c', }, {'\xeb', '\x82', '\x8d', }, {'\xeb', '\x82', '\x8f', }, {'\xeb', '\x82', '\x91', }, {'\xeb', '\x82', '\x98', }, {'\xeb', '\x82', '\x99', }, {'\xeb', '\x82', '\x9a', }, {'\xeb', '\x82', '\x9c', }, {'\xeb', '\x82', '\x9f', }, {'\xeb', '\x82', '\xa0', }, {'\xeb', '\x82', '\xa1', }, {'\xeb', '\x82', '\xa2', }, {'\xeb', '\x82', '\xa8', }, {'\xeb', '\x82', '\xa9', }, {'\xeb', '\x82', '\xab', }, {'\xeb', '\x82', '\xac', }, {'\xeb', '\x82', '\xad', }, {'\xeb', '\x82', '\xae', }, {'\xeb', '\x82', '\xaf', }, {'\xeb', '\x82', '\xb1', }, {'\xeb', '\x82', '\xb3', }, {'\xeb', '\x82', '\xb4', }, {'\xeb', '\x82', '\xb5', }, {'\xeb', '\x82', '\xb8', }, {'\xeb', '\x82', '\xbc', }, {'\xeb', '\x83', '\x84', }, {'\xeb', '\x83', '\x85', }, {'\xeb', '\x83', '\x87', }, {'\xeb', '\x83', '\x88', }, {'\xeb', '\x83', '\x89', }, {'\xeb', '\x83', '\x90', }, {'\xeb', '\x83', '\x91', }, {'\xeb', '\x83', '\x94', }, {'\xeb', '\x83', '\x98', }, {'\xeb', '\x83', '\xa0', }, {'\xeb', '\x83', '\xa5', }, {'\xeb', '\x84', '\x88', }, {'\xeb', '\x84', '\x89', }, {'\xeb', '\x84', '\x8b', }, {'\xeb', '\x84', '\x8c', }, {'\xeb', '\x84', '\x90', }, {'\xeb', '\x84', '\x92', }, {'\xeb', '\x84', '\x93', }, {'\xeb', '\x84', '\x98', }, {'\xeb', '\x84', '\x99', }, {'\xeb', '\x84', '\x9b', }, {'\xeb', '\x84', '\x9c', }, {'\xeb', '\x84', '\x9d', }, {'\xeb', '\x84', '\xa3', }, {'\xeb', '\x84', '\xa4', }, {'\xeb', '\x84', '\xa5', }, {'\xeb', '\x84', '\xa8', }, {'\xeb', '\x84', '\xac', }, {'\xeb', '\x84', '\xb4', }, {'\xeb', '\x84', '\xb5', }, {'\xeb', '\x84', '\xb7', }, {'\xeb', '\x84', '\xb8', }, {'\xeb', '\x84', '\xb9', }, {'\xeb', '\x85', '\x80', }, {'\xeb', '\x85', '\x81', }, {'\xeb', '\x85', '\x84', }, {'\xeb', '\x85', '\x88', }, {'\xeb', '\x85', '\x90', }, {'\xeb', '\x85', '\x91', }, {'\xeb', '\x85', '\x94', }, {'\xeb', '\x85', '\x95', }, {'\xeb', '\x85', '\x98', }, {'\xeb', '\x85', '\x9c', }, {'\xeb', '\x85', '\xa0', }, {'\xeb', '\x85', '\xb8', }, {'\xeb', '\x85', '\xb9', }, {'\xeb', '\x85', '\xbc', }, {'\xeb', '\x86', '\x80', }, {'\xeb', '\x86', '\x82', }, {'\xeb', '\x86', '\x88', }, {'\xeb', '\x86', '\x89', }, {'\xeb', '\x86', '\x8b', }, {'\xeb', '\x86', '\x8d', }, {'\xeb', '\x86', '\x92', }, {'\xeb', '\x86', '\x93', }, {'\xeb', '\x86', '\x94', }, {'\xeb', '\x86', '\x98', }, {'\xeb', '\x86', '\x9c', }, {'\xeb', '\x86', '\xa8', }, {'\xeb', '\x87', '\x8c', }, {'\xeb', '\x87', '\x90', }, {'\xeb', '\x87', '\x94', }, {'\xeb', '\x87', '\x9c', }, {'\xeb', '\x87', '\x9d', }, {'\xeb', '\x87', '\x9f', }, {'\xeb', '\x87', '\xa8', }, {'\xeb', '\x87', '\xa9', }, {'\xeb', '\x87', '\xac', }, {'\xeb', '\x87', '\xb0', }, {'\xeb', '\x87', '\xb9', }, {'\xeb', '\x87', '\xbb', }, {'\xeb', '\x87', '\xbd', }, {'\xeb', '\x88', '\x84', }, {'\xeb', '\x88', '\x85', }, {'\xeb', '\x88', '\x88', }, {'\xeb', '\x88', '\x8b', }, {'\xeb', '\x88', '\x8c', }, {'\xeb', '\x88', '\x94', }, {'\xeb', '\x88', '\x95', }, {'\xeb', '\x88', '\x97', }, {'\xeb', '\x88', '\x99', }, {'\xeb', '\x88', '\xa0', }, {'\xeb', '\x88', '\xb4', }, {'\xeb', '\x88', '\xbc', }, {'\xeb', '\x89', '\x98', }, {'\xeb', '\x89', '\x9c', }, {'\xeb', '\x89', '\xa0', }, {'\xeb', '\x89', '\xa8', }, {'\xeb', '\x89', '\xa9', }, {'\xeb', '\x89', '\xb4', }, {'\xeb', '\x89', '\xb5', }, {'\xeb', '\x89', '\xbc', }, {'\xeb', '\x8a', '\x84', }, {'\xeb', '\x8a', '\x85', }, {'\xeb', '\x8a', '\x89', }, {'\xeb', '\x8a', '\x90', }, {'\xeb', '\x8a', '\x91', }, {'\xeb', '\x8a', '\x94', }, {'\xeb', '\x8a', '\x98', }, {'\xeb', '\x8a', '\x99', }, {'\xeb', '\x8a', '\x9a', }, {'\xeb', '\x8a', '\xa0', }, {'\xeb', '\x8a', '\xa1', }, {'\xeb', '\x8a', '\xa3', }, {'\xeb', '\x8a', '\xa5', }, {'\xeb', '\x8a', '\xa6', }, {'\xeb', '\x8a', '\xaa', }, {'\xeb', '\x8a', '\xac', }, {'\xeb', '\x8a', '\xb0', }, {'\xeb', '\x8a', '\xb4', }, {'\xeb', '\x8b', '\x88', }, {'\xeb', '\x8b', '\x89', }, {'\xeb', '\x8b', '\x8c', }, {'\xeb', '\x8b', '\x90', }, {'\xeb', '\x8b', '\x92', }, {'\xeb', '\x8b', '\x98', }, {'\xeb', '\x8b', '\x99', }, {'\xeb', '\x8b', '\x9b', }, {'\xeb', '\x8b', '\x9d', }, {'\xeb', '\x8b', '\xa2', }, {'\xeb', '\x8b', '\xa4', }, {'\xeb', '\x8b', '\xa5', }, {'\xeb', '\x8b', '\xa6', }, {'\xeb', '\x8b', '\xa8', }, {'\xeb', '\x8b', '\xab', }, {'\xeb', '\x8b', '\xac', }, {'\xeb', '\x8b', '\xad', }, {'\xeb', '\x8b', '\xae', }, {'\xeb', '\x8b', '\xaf', }, {'\xeb', '\x8b', '\xb3', }, {'\xeb', '\x8b', '\xb4', }, {'\xeb', '\x8b', '\xb5', }, {'\xeb', '\x8b', '\xb7', }, {'\xeb', '\x8b', '\xb8', }, {'\xeb', '\x8b', '\xb9', }, {'\xeb', '\x8b', '\xba', }, {'\xeb', '\x8b', '\xbb', }, {'\xeb', '\x8b', '\xbf', }, {'\xeb', '\x8c', '\x80', }, {'\xeb', '\x8c', '\x81', }, {'\xeb', '\x8c', '\x84', }, {'\xeb', '\x8c', '\x88', }, {'\xeb', '\x8c', '\x90', }, {'\xeb', '\x8c', '\x91', }, {'\xeb', '\x8c', '\x93', }, {'\xeb', '\x8c', '\x94', }, {'\xeb', '\x8c', '\x95', }, {'\xeb', '\x8c', '\x9c', }, {'\xeb', '\x8d', '\x94', }, {'\xeb', '\x8d', '\x95', }, {'\xeb', '\x8d', '\x96', }, {'\xeb', '\x8d', '\x98', }, {'\xeb', '\x8d', '\x9b', }, {'\xeb', '\x8d', '\x9c', }, {'\xeb', '\x8d', '\x9e', }, {'\xeb', '\x8d', '\x9f', }, {'\xeb', '\x8d', '\xa4', }, {'\xeb', '\x8d', '\xa5', }, {'\xeb', '\x8d', '\xa7', }, {'\xeb', '\x8d', '\xa9', }, {'\xeb', '\x8d', '\xab', }, {'\xeb', '\x8d', '\xae', }, {'\xeb', '\x8d', '\xb0', }, {'\xeb', '\x8d', '\xb1', }, {'\xeb', '\x8d', '\xb4', }, {'\xeb', '\x8d', '\xb8', }, {'\xeb', '\x8e', '\x80', }, {'\xeb', '\x8e', '\x81', }, {'\xeb', '\x8e', '\x83', }, {'\xeb', '\x8e', '\x84', }, {'\xeb', '\x8e', '\x85', }, {'\xeb', '\x8e', '\x8c', }, {'\xeb', '\x8e', '\x90', }, {'\xeb', '\x8e', '\x94', }, {'\xeb', '\x8e', '\xa0', }, {'\xeb', '\x8e', '\xa1', }, {'\xeb', '\x8e', '\xa8', }, {'\xeb', '\x8e', '\xac', }, {'\xeb', '\x8f', '\x84', }, {'\xeb', '\x8f', '\x85', }, {'\xeb', '\x8f', '\x88', }, {'\xeb', '\x8f', '\x8b', }, {'\xeb', '\x8f', '\x8c', }, {'\xeb', '\x8f', '\x8e', }, {'\xeb', '\x8f', '\x90', }, {'\xeb', '\x8f', '\x94', }, {'\xeb', '\x8f', '\x95', }, {'\xeb', '\x8f', '\x97', }, {'\xeb', '\x8f', '\x99', }, {'\xeb', '\x8f', '\x9b', }, {'\xeb', '\x8f', '\x9d', }, {'\xeb', '\x8f', '\xa0', }, {'\xeb', '\x8f', '\xa4', }, {'\xeb', '\x8f', '\xa8', }, {'\xeb', '\x8f', '\xbc', }, {'\xeb', '\x90', '\x90', }, {'\xeb', '\x90', '\x98', }, {'\xeb', '\x90', '\x9c', }, {'\xeb', '\x90', '\xa0', }, {'\xeb', '\x90', '\xa8', }, {'\xeb', '\x90', '\xa9', }, {'\xeb', '\x90', '\xab', }, {'\xeb', '\x90', '\xb4', }, {'\xeb', '\x91', '\x90', }, {'\xeb', '\x91', '\x91', }, {'\xeb', '\x91', '\x94', }, {'\xeb', '\x91', '\x98', }, {'\xeb', '\x91', '\xa0', }, {'\xeb', '\x91', '\xa1', }, {'\xeb', '\x91', '\xa3', }, {'\xeb', '\x91', '\xa5', }, {'\xeb', '\x91', '\xac', }, {'\xeb', '\x92', '\x80', }, {'\xeb', '\x92', '\x88', }, {'\xeb', '\x92', '\x9d', }, {'\xeb', '\x92', '\xa4', }, {'\xeb', '\x92', '\xa8', }, {'\xeb', '\x92', '\xac', }, {'\xeb', '\x92', '\xb5', }, {'\xeb', '\x92', '\xb7', }, {'\xeb', '\x92', '\xb9', }, {'\xeb', '\x93', '\x80', }, {'\xeb', '\x93', '\x84', }, {'\xeb', '\x93', '\x88', }, {'\xeb', '\x93', '\x90', }, {'\xeb', '\x93', '\x95', }, {'\xeb', '\x93', '\x9c', }, {'\xeb', '\x93', '\x9d', }, {'\xeb', '\x93', '\xa0', }, {'\xeb', '\x93', '\xa3', }, {'\xeb', '\x93', '\xa4', }, {'\xeb', '\x93', '\xa6', }, {'\xeb', '\x93', '\xac', }, {'\xeb', '\x93', '\xad', }, {'\xeb', '\x93', '\xaf', }, {'\xeb', '\x93', '\xb1', }, {'\xeb', '\x93', '\xb8', }, {'\xeb', '\x94', '\x94', }, {'\xeb', '\x94', '\x95', }, {'\xeb', '\x94', '\x98', }, {'\xeb', '\x94', '\x9b', }, {'\xeb', '\x94', '\x9c', }, {'\xeb', '\x94', '\xa4', }, {'\xeb', '\x94', '\xa5', }, {'\xeb', '\x94', '\xa7', }, {'\xeb', '\x94', '\xa8', }, {'\xeb', '\x94', '\xa9', }, {'\xeb', '\x94', '\xaa', }, {'\xeb', '\x94', '\xb0', }, {'\xeb', '\x94', '\xb1', }, {'\xeb', '\x94', '\xb4', }, {'\xeb', '\x94', '\xb8', }, {'\xeb', '\x95', '\x80', }, {'\xeb', '\x95', '\x81', }, {'\xeb', '\x95', '\x83', }, {'\xeb', '\x95', '\x84', }, {'\xeb', '\x95', '\x85', }, {'\xeb', '\x95', '\x8b', }, {'\xeb', '\x95', '\x8c', }, {'\xeb', '\x95', '\x8d', }, {'\xeb', '\x95', '\x90', }, {'\xeb', '\x95', '\x94', }, {'\xeb', '\x95', '\x9c', }, {'\xeb', '\x95', '\x9d', }, {'\xeb', '\x95', '\x9f', }, {'\xeb', '\x95', '\xa0', }, {'\xeb', '\x95', '\xa1', }, {'\xeb', '\x96', '\xa0', }, {'\xeb', '\x96', '\xa1', }, {'\xeb', '\x96', '\xa4', }, {'\xeb', '\x96', '\xa8', }, {'\xeb', '\x96', '\xaa', }, {'\xeb', '\x96', '\xab', }, {'\xeb', '\x96', '\xb0', }, {'\xeb', '\x96', '\xb1', }, {'\xeb', '\x96', '\xb3', }, {'\xeb', '\x96', '\xb4', }, {'\xeb', '\x96', '\xb5', }, {'\xeb', '\x96', '\xbb', }, {'\xeb', '\x96', '\xbc', }, {'\xeb', '\x96', '\xbd', }, {'\xeb', '\x97', '\x80', }, {'\xeb', '\x97', '\x84', }, {'\xeb', '\x97', '\x8c', }, {'\xeb', '\x97', '\x8d', }, {'\xeb', '\x97', '\x8f', }, {'\xeb', '\x97', '\x90', }, {'\xeb', '\x97', '\x91', }, {'\xeb', '\x97', '\x98', }, {'\xeb', '\x97', '\xac', }, {'\xeb', '\x98', '\x90', }, {'\xeb', '\x98', '\x91', }, {'\xeb', '\x98', '\x94', }, {'\xeb', '\x98', '\x98', }, {'\xeb', '\x98', '\xa5', }, {'\xeb', '\x98', '\xac', }, {'\xeb', '\x98', '\xb4', }, {'\xeb', '\x99', '\x88', }, {'\xeb', '\x99', '\xa4', }, {'\xeb', '\x99', '\xa8', }, {'\xeb', '\x9a', '\x9c', }, {'\xeb', '\x9a', '\x9d', }, {'\xeb', '\x9a', '\xa0', }, {'\xeb', '\x9a', '\xa4', }, {'\xeb', '\x9a', '\xab', }, {'\xeb', '\x9a', '\xac', }, {'\xeb', '\x9a', '\xb1', }, {'\xeb', '\x9b', '\x94', }, {'\xeb', '\x9b', '\xb0', }, {'\xeb', '\x9b', '\xb4', }, {'\xeb', '\x9b', '\xb8', }, {'\xeb', '\x9c', '\x80', }, {'\xeb', '\x9c', '\x81', }, {'\xeb', '\x9c', '\x85', }, {'\xeb', '\x9c', '\xa8', }, {'\xeb', '\x9c', '\xa9', }, {'\xeb', '\x9c', '\xac', }, {'\xeb', '\x9c', '\xaf', }, {'\xeb', '\x9c', '\xb0', }, {'\xeb', '\x9c', '\xb8', }, {'\xeb', '\x9c', '\xb9', }, {'\xeb', '\x9c', '\xbb', }, {'\xeb', '\x9d', '\x84', }, {'\xeb', '\x9d', '\x88', }, {'\xeb', '\x9d', '\x8c', }, {'\xeb', '\x9d', '\x94', }, {'\xeb', '\x9d', '\x95', }, {'\xeb', '\x9d', '\xa0', }, {'\xeb', '\x9d', '\xa4', }, {'\xeb', '\x9d', '\xa8', }, {'\xeb', '\x9d', '\xb0', }, {'\xeb', '\x9d', '\xb1', }, {'\xeb', '\x9d', '\xb3', }, {'\xeb', '\x9d', '\xb5', }, {'\xeb', '\x9d', '\xbc', }, {'\xeb', '\x9d', '\xbd', }, {'\xeb', '\x9e', '\x80', }, {'\xeb', '\x9e', '\x84', }, {'\xeb', '\x9e', '\x8c', }, {'\xeb', '\x9e', '\x8d', }, {'\xeb', '\x9e', '\x8f', }, {'\xeb', '\x9e', '\x90', }, {'\xeb', '\x9e', '\x91', }, {'\xeb', '\x9e', '\x92', }, {'\xeb', '\x9e', '\x96', }, {'\xeb', '\x9e', '\x97', }, {'\xeb', '\x9e', '\x98', }, {'\xeb', '\x9e', '\x99', }, {'\xeb', '\x9e', '\x9c', }, {'\xeb', '\x9e', '\xa0', }, {'\xeb', '\x9e', '\xa8', }, {'\xeb', '\x9e', '\xa9', }, {'\xeb', '\x9e', '\xab', }, {'\xeb', '\x9e', '\xac', }, {'\xeb', '\x9e', '\xad', }, {'\xeb', '\x9e', '\xb4', }, {'\xeb', '\x9e', '\xb5', }, {'\xeb', '\x9e', '\xb8', }, {'\xeb', '\x9f', '\x87', }, {'\xeb', '\x9f', '\x89', }, {'\xeb', '\x9f', '\xac', }, {'\xeb', '\x9f', '\xad', }, {'\xeb', '\x9f', '\xb0', }, {'\xeb', '\x9f', '\xb4', }, {'\xeb', '\x9f', '\xbc', }, {'\xeb', '\x9f', '\xbd', }, {'\xeb', '\x9f', '\xbf', }, {'\xeb', '\xa0', '\x80', }, {'\xeb', '\xa0', '\x81', }, {'\xeb', '\xa0', '\x87', }, {'\xeb', '\xa0', '\x88', }, {'\xeb', '\xa0', '\x89', }, {'\xeb', '\xa0', '\x8c', }, {'\xeb', '\xa0', '\x90', }, {'\xeb', '\xa0', '\x98', }, {'\xeb', '\xa0', '\x99', }, {'\xeb', '\xa0', '\x9b', }, {'\xeb', '\xa0', '\x9d', }, {'\xeb', '\xa0', '\xa4', }, {'\xeb', '\xa0', '\xa5', }, {'\xeb', '\xa0', '\xa8', }, {'\xeb', '\xa0', '\xac', }, {'\xeb', '\xa0', '\xb4', }, {'\xeb', '\xa0', '\xb5', }, {'\xeb', '\xa0', '\xb7', }, {'\xeb', '\xa0', '\xb8', }, {'\xeb', '\xa0', '\xb9', }, {'\xeb', '\xa1', '\x80', }, {'\xeb', '\xa1', '\x84', }, {'\xeb', '\xa1', '\x91', }, {'\xeb', '\xa1', '\x93', }, {'\xeb', '\xa1', '\x9c', }, {'\xeb', '\xa1', '\x9d', }, {'\xeb', '\xa1', '\xa0', }, {'\xeb', '\xa1', '\xa4', }, {'\xeb', '\xa1', '\xac', }, {'\xeb', '\xa1', '\xad', }, {'\xeb', '\xa1', '\xaf', }, {'\xeb', '\xa1', '\xb1', }, {'\xeb', '\xa1', '\xb8', }, {'\xeb', '\xa1', '\xbc', }, {'\xeb', '\xa2', '\x8d', }, {'\xeb', '\xa2', '\xa8', }, {'\xeb', '\xa2', '\xb0', }, {'\xeb', '\xa2', '\xb4', }, {'\xeb', '\xa2', '\xb8', }, {'\xeb', '\xa3', '\x80', }, {'\xeb', '\xa3', '\x81', }, {'\xeb', '\xa3', '\x83', }, {'\xeb', '\xa3', '\x85', }, {'\xeb', '\xa3', '\x8c', }, {'\xeb', '\xa3', '\x90', }, {'\xeb', '\xa3', '\x94', }, {'\xeb', '\xa3', '\x9d', }, {'\xeb', '\xa3', '\x9f', }, {'\xeb', '\xa3', '\xa1', }, {'\xeb', '\xa3', '\xa8', }, {'\xeb', '\xa3', '\xa9', }, {'\xeb', '\xa3', '\xac', }, {'\xeb', '\xa3', '\xb0', }, {'\xeb', '\xa3', '\xb8', }, {'\xeb', '\xa3', '\xb9', }, {'\xeb', '\xa3', '\xbb', }, {'\xeb', '\xa3', '\xbd', }, {'\xeb', '\xa4', '\x84', }, {'\xeb', '\xa4', '\x98', }, {'\xeb', '\xa4', '\xa0', }, {'\xeb', '\xa4', '\xbc', }, {'\xeb', '\xa4', '\xbd', }, {'\xeb', '\xa5', '\x80', }, {'\xeb', '\xa5', '\x84', }, {'\xeb', '\xa5', '\x8c', }, {'\xeb', '\xa5', '\x8f', }, {'\xeb', '\xa5', '\x91', }, {'\xeb', '\xa5', '\x98', }, {'\xeb', '\xa5', '\x99', }, {'\xeb', '\xa5', '\x9c', }, {'\xeb', '\xa5', '\xa0', }, {'\xeb', '\xa5', '\xa8', }, {'\xeb', '\xa5', '\xa9', }, {'\xeb', '\xa5', '\xab', }, {'\xeb', '\xa5', '\xad', }, {'\xeb', '\xa5', '\xb4', }, {'\xeb', '\xa5', '\xb5', }, {'\xeb', '\xa5', '\xb8', }, {'\xeb', '\xa5', '\xbc', }, {'\xeb', '\xa6', '\x84', }, {'\xeb', '\xa6', '\x85', }, {'\xeb', '\xa6', '\x87', }, {'\xeb', '\xa6', '\x89', }, {'\xeb', '\xa6', '\x8a', }, {'\xeb', '\xa6', '\x8d', }, {'\xeb', '\xa6', '\x8e', }, {'\xeb', '\xa6', '\xac', }, {'\xeb', '\xa6', '\xad', }, {'\xeb', '\xa6', '\xb0', }, {'\xeb', '\xa6', '\xb4', }, {'\xeb', '\xa6', '\xbc', }, {'\xeb', '\xa6', '\xbd', }, {'\xeb', '\xa6', '\xbf', }, {'\xeb', '\xa7', '\x81', }, {'\xeb', '\xa7', '\x88', }, {'\xeb', '\xa7', '\x89', }, {'\xeb', '\xa7', '\x8c', }, {'\xeb', '\xa7', '\x8e', }, {'\xeb', '\xa7', '\x8f', }, {'\xeb', '\xa7', '\x90', }, {'\xeb', '\xa7', '\x91', }, {'\xeb', '\xa7', '\x92', }, {'\xeb', '\xa7', '\x98', }, {'\xeb', '\xa7', '\x99', }, {'\xeb', '\xa7', '\x9b', }, {'\xeb', '\xa7', '\x9d', }, {'\xeb', '\xa7', '\x9e', }, {'\xeb', '\xa7', '\xa1', }, {'\xeb', '\xa7', '\xa3', }, {'\xeb', '\xa7', '\xa4', }, {'\xeb', '\xa7', '\xa5', }, {'\xeb', '\xa7', '\xa8', }, {'\xeb', '\xa7', '\xac', }, {'\xeb', '\xa7', '\xb4', }, {'\xeb', '\xa7', '\xb5', }, {'\xeb', '\xa7', '\xb7', }, {'\xeb', '\xa7', '\xb8', }, {'\xeb', '\xa7', '\xb9', }, {'\xeb', '\xa7', '\xba', }, {'\xeb', '\xa8', '\x80', }, {'\xeb', '\xa8', '\x81', }, {'\xeb', '\xa8', '\x88', }, {'\xeb', '\xa8', '\x95', }, {'\xeb', '\xa8', '\xb8', }, {'\xeb', '\xa8', '\xb9', }, {'\xeb', '\xa8', '\xbc', }, {'\xeb', '\xa9', '\x80', }, {'\xeb', '\xa9', '\x82', }, {'\xeb', '\xa9', '\x88', }, {'\xeb', '\xa9', '\x89', }, {'\xeb', '\xa9', '\x8b', }, {'\xeb', '\xa9', '\x8d', }, {'\xeb', '\xa9', '\x8e', }, {'\xeb', '\xa9', '\x93', }, {'\xeb', '\xa9', '\x94', }, {'\xeb', '\xa9', '\x95', }, {'\xeb', '\xa9', '\x98', }, {'\xeb', '\xa9', '\x9c', }, {'\xeb', '\xa9', '\xa4', }, {'\xeb', '\xa9', '\xa5', }, {'\xeb', '\xa9', '\xa7', }, {'\xeb', '\xa9', '\xa8', }, {'\xeb', '\xa9', '\xa9', }, {'\xeb', '\xa9', '\xb0', }, {'\xeb', '\xa9', '\xb1', }, {'\xeb', '\xa9', '\xb4', }, {'\xeb', '\xa9', '\xb8', }, {'\xeb', '\xaa', '\x83', }, {'\xeb', '\xaa', '\x84', }, {'\xeb', '\xaa', '\x85', }, {'\xeb', '\xaa', '\x87', }, {'\xeb', '\xaa', '\x8c', }, {'\xeb', '\xaa', '\xa8', }, {'\xeb', '\xaa', '\xa9', }, {'\xeb', '\xaa', '\xab', }, {'\xeb', '\xaa', '\xac', }, {'\xeb', '\xaa', '\xb0', }, {'\xeb', '\xaa', '\xb2', }, {'\xeb', '\xaa', '\xb8', }, {'\xeb', '\xaa', '\xb9', }, {'\xeb', '\xaa', '\xbb', }, {'\xeb', '\xaa', '\xbd', }, {'\xeb', '\xab', '\x84', }, {'\xeb', '\xab', '\x88', }, {'\xeb', '\xab', '\x98', }, {'\xeb', '\xab', '\x99', }, {'\xeb', '\xab', '\xbc', }, {'\xeb', '\xac', '\x80', }, {'\xeb', '\xac', '\x84', }, {'\xeb', '\xac', '\x8d', }, {'\xeb', '\xac', '\x8f', }, {'\xeb', '\xac', '\x91', }, {'\xeb', '\xac', '\x98', }, {'\xeb', '\xac', '\x9c', }, {'\xeb', '\xac', '\xa0', }, {'\xeb', '\xac', '\xa9', }, {'\xeb', '\xac', '\xab', }, {'\xeb', '\xac', '\xb4', }, {'\xeb', '\xac', '\xb5', }, {'\xeb', '\xac', '\xb6', }, {'\xeb', '\xac', '\xb8', }, {'\xeb', '\xac', '\xbb', }, {'\xeb', '\xac', '\xbc', }, {'\xeb', '\xac', '\xbd', }, {'\xeb', '\xac', '\xbe', }, {'\xeb', '\xad', '\x84', }, {'\xeb', '\xad', '\x85', }, {'\xeb', '\xad', '\x87', }, {'\xeb', '\xad', '\x89', }, {'\xeb', '\xad', '\x8d', }, {'\xeb', '\xad', '\x8f', }, {'\xeb', '\xad', '\x90', }, {'\xeb', '\xad', '\x94', }, {'\xeb', '\xad', '\x98', }, {'\xeb', '\xad', '\xa1', }, {'\xeb', '\xad', '\xa3', }, {'\xeb', '\xad', '\xac', }, {'\xeb', '\xae', '\x88', }, {'\xeb', '\xae', '\x8c', }, {'\xeb', '\xae', '\x90', }, {'\xeb', '\xae', '\xa4', }, {'\xeb', '\xae', '\xa8', }, {'\xeb', '\xae', '\xac', }, {'\xeb', '\xae', '\xb4', }, {'\xeb', '\xae', '\xb7', }, {'\xeb', '\xaf', '\x80', }, {'\xeb', '\xaf', '\x84', }, {'\xeb', '\xaf', '\x88', }, {'\xeb', '\xaf', '\x90', }, {'\xeb', '\xaf', '\x93', }, {'\xeb', '\xaf', '\xb8', }, {'\xeb', '\xaf', '\xb9', }, {'\xeb', '\xaf', '\xbc', }, {'\xeb', '\xaf', '\xbf', }, {'\xeb', '\xb0', '\x80', }, {'\xeb', '\xb0', '\x82', }, {'\xeb', '\xb0', '\x88', }, {'\xeb', '\xb0', '\x89', }, {'\xeb', '\xb0', '\x8b', }, {'\xeb', '\xb0', '\x8c', }, {'\xeb', '\xb0', '\x8d', }, {'\xeb', '\xb0', '\x8f', }, {'\xeb', '\xb0', '\x91', }, {'\xeb', '\xb0', '\x94', }, {'\xeb', '\xb0', '\x95', }, {'\xeb', '\xb0', '\x96', }, {'\xeb', '\xb0', '\x97', }, {'\xeb', '\xb0', '\x98', }, {'\xeb', '\xb0', '\x9b', }, {'\xeb', '\xb0', '\x9c', }, {'\xeb', '\xb0', '\x9d', }, {'\xeb', '\xb0', '\x9e', }, {'\xeb', '\xb0', '\x9f', }, {'\xeb', '\xb0', '\xa4', }, {'\xeb', '\xb0', '\xa5', }, {'\xeb', '\xb0', '\xa7', }, {'\xeb', '\xb0', '\xa9', }, {'\xeb', '\xb0', '\xad', }, {'\xeb', '\xb0', '\xb0', }, {'\xeb', '\xb0', '\xb1', }, {'\xeb', '\xb0', '\xb4', }, {'\xeb', '\xb0', '\xb8', }, {'\xeb', '\xb1', '\x80', }, {'\xeb', '\xb1', '\x81', }, {'\xeb', '\xb1', '\x83', }, {'\xeb', '\xb1', '\x84', }, {'\xeb', '\xb1', '\x85', }, {'\xeb', '\xb1', '\x89', }, {'\xeb', '\xb1', '\x8c', }, {'\xeb', '\xb1', '\x8d', }, {'\xeb', '\xb1', '\x90', }, {'\xeb', '\xb1', '\x9d', }, {'\xeb', '\xb2', '\x84', }, {'\xeb', '\xb2', '\x85', }, {'\xeb', '\xb2', '\x88', }, {'\xeb', '\xb2', '\x8b', }, {'\xeb', '\xb2', '\x8c', }, {'\xeb', '\xb2', '\x8e', }, {'\xeb', '\xb2', '\x94', }, {'\xeb', '\xb2', '\x95', }, {'\xeb', '\xb2', '\x97', }, {'\xeb', '\xb2', '\x99', }, {'\xeb', '\xb2', '\x9a', }, {'\xeb', '\xb2', '\xa0', }, {'\xeb', '\xb2', '\xa1', }, {'\xeb', '\xb2', '\xa4', }, {'\xeb', '\xb2', '\xa7', }, {'\xeb', '\xb2', '\xa8', }, {'\xeb', '\xb2', '\xb0', }, {'\xeb', '\xb2', '\xb1', }, {'\xeb', '\xb2', '\xb3', }, {'\xeb', '\xb2', '\xb4', }, {'\xeb', '\xb2', '\xb5', }, {'\xeb', '\xb2', '\xbc', }, {'\xeb', '\xb2', '\xbd', }, {'\xeb', '\xb3', '\x80', }, {'\xeb', '\xb3', '\x84', }, {'\xeb', '\xb3', '\x8d', }, {'\xeb', '\xb3', '\x8f', }, {'\xeb', '\xb3', '\x90', }, {'\xeb', '\xb3', '\x91', }, {'\xeb', '\xb3', '\x95', }, {'\xeb', '\xb3', '\x98', }, {'\xeb', '\xb3', '\x9c', }, {'\xeb', '\xb3', '\xb4', }, {'\xeb', '\xb3', '\xb5', }, {'\xeb', '\xb3', '\xb6', }, {'\xeb', '\xb3', '\xb8', }, {'\xeb', '\xb3', '\xbc', }, {'\xeb', '\xb4', '\x84', }, {'\xeb', '\xb4', '\x85', }, {'\xeb', '\xb4', '\x87', }, {'\xeb', '\xb4', '\x89', }, {'\xeb', '\xb4', '\x90', }, {'\xeb', '\xb4', '\x94', }, {'\xeb', '\xb4', '\xa4', }, {'\xeb', '\xb4', '\xac', }, {'\xeb', '\xb5', '\x80', }, {'\xeb', '\xb5', '\x88', }, {'\xeb', '\xb5', '\x89', }, {'\xeb', '\xb5', '\x8c', }, {'\xeb', '\xb5', '\x90', }, {'\xeb', '\xb5', '\x98', }, {'\xeb', '\xb5', '\x99', }, {'\xeb', '\xb5', '\xa4', }, {'\xeb', '\xb5', '\xa8', }, {'\xeb', '\xb6', '\x80', }, {'\xeb', '\xb6', '\x81', }, {'\xeb', '\xb6', '\x84', }, {'\xeb', '\xb6', '\x87', }, {'\xeb', '\xb6', '\x88', }, {'\xeb', '\xb6', '\x89', }, {'\xeb', '\xb6', '\x8a', }, {'\xeb', '\xb6', '\x90', }, {'\xeb', '\xb6', '\x91', }, {'\xeb', '\xb6', '\x93', }, {'\xeb', '\xb6', '\x95', }, {'\xeb', '\xb6', '\x99', }, {'\xeb', '\xb6', '\x9a', }, {'\xeb', '\xb6', '\x9c', }, {'\xeb', '\xb6', '\xa4', }, {'\xeb', '\xb6', '\xb0', }, {'\xeb', '\xb6', '\xb8', }, {'\xeb', '\xb7', '\x94', }, {'\xeb', '\xb7', '\x95', }, {'\xeb', '\xb7', '\x98', }, {'\xeb', '\xb7', '\x9c', }, {'\xeb', '\xb7', '\xa9', }, {'\xeb', '\xb7', '\xb0', }, {'\xeb', '\xb7', '\xb4', }, {'\xeb', '\xb7', '\xb8', }, {'\xeb', '\xb8', '\x80', }, {'\xeb', '\xb8', '\x83', }, {'\xeb', '\xb8', '\x85', }, {'\xeb', '\xb8', '\x8c', }, {'\xeb', '\xb8', '\x8d', }, {'\xeb', '\xb8', '\x90', }, {'\xeb', '\xb8', '\x94', }, {'\xeb', '\xb8', '\x9c', }, {'\xeb', '\xb8', '\x9d', }, {'\xeb', '\xb8', '\x9f', }, {'\xeb', '\xb9', '\x84', }, {'\xeb', '\xb9', '\x85', }, {'\xeb', '\xb9', '\x88', }, {'\xeb', '\xb9', '\x8c', }, {'\xeb', '\xb9', '\x8e', }, {'\xeb', '\xb9', '\x94', }, {'\xeb', '\xb9', '\x95', }, {'\xeb', '\xb9', '\x97', }, {'\xeb', '\xb9', '\x99', }, {'\xeb', '\xb9', '\x9a', }, {'\xeb', '\xb9', '\x9b', }, {'\xeb', '\xb9', '\xa0', }, {'\xeb', '\xb9', '\xa1', }, {'\xeb', '\xb9', '\xa4', }, {'\xeb', '\xb9', '\xa8', }, {'\xeb', '\xb9', '\xaa', }, {'\xeb', '\xb9', '\xb0', }, {'\xeb', '\xb9', '\xb1', }, {'\xeb', '\xb9', '\xb3', }, {'\xeb', '\xb9', '\xb4', }, {'\xeb', '\xb9', '\xb5', }, {'\xeb', '\xb9', '\xbb', }, {'\xeb', '\xb9', '\xbc', }, {'\xeb', '\xb9', '\xbd', }, {'\xeb', '\xba', '\x80', }, {'\xeb', '\xba', '\x84', }, {'\xeb', '\xba', '\x8c', }, {'\xeb', '\xba', '\x8d', }, {'\xeb', '\xba', '\x8f', }, {'\xeb', '\xba', '\x90', }, {'\xeb', '\xba', '\x91', }, {'\xeb', '\xba', '\x98', }, {'\xeb', '\xba', '\x99', }, {'\xeb', '\xba', '\xa8', }, {'\xeb', '\xbb', '\x90', }, {'\xeb', '\xbb', '\x91', }, {'\xeb', '\xbb', '\x94', }, {'\xeb', '\xbb', '\x97', }, {'\xeb', '\xbb', '\x98', }, {'\xeb', '\xbb', '\xa0', }, {'\xeb', '\xbb', '\xa3', }, {'\xeb', '\xbb', '\xa4', }, {'\xeb', '\xbb', '\xa5', }, {'\xeb', '\xbb', '\xac', }, {'\xeb', '\xbc', '\x81', }, {'\xeb', '\xbc', '\x88', }, {'\xeb', '\xbc', '\x89', }, {'\xeb', '\xbc', '\x98', }, {'\xeb', '\xbc', '\x99', }, {'\xeb', '\xbc', '\x9b', }, {'\xeb', '\xbc', '\x9c', }, {'\xeb', '\xbc', '\x9d', }, {'\xeb', '\xbd', '\x80', }, {'\xeb', '\xbd', '\x81', }, {'\xeb', '\xbd', '\x84', }, {'\xeb', '\xbd', '\x88', }, {'\xeb', '\xbd', '\x90', }, {'\xeb', '\xbd', '\x91', }, {'\xeb', '\xbd', '\x95', }, {'\xeb', '\xbe', '\x94', }, {'\xeb', '\xbe', '\xb0', }, {'\xeb', '\xbf', '\x85', }, {'\xeb', '\xbf', '\x8c', }, {'\xeb', '\xbf', '\x8d', }, {'\xeb', '\xbf', '\x90', }, {'\xeb', '\xbf', '\x94', }, {'\xeb', '\xbf', '\x9c', }, {'\xeb', '\xbf', '\x9f', }, {'\xeb', '\xbf', '\xa1', }, {'\xec', '\x80', '\xbc', }, {'\xec', '\x81', '\x91', }, {'\xec', '\x81', '\x98', }, {'\xec', '\x81', '\x9c', }, {'\xec', '\x81', '\xa0', }, {'\xec', '\x81', '\xa8', }, {'\xec', '\x81', '\xa9', }, {'\xec', '\x82', '\x90', }, {'\xec', '\x82', '\x91', }, {'\xec', '\x82', '\x94', }, {'\xec', '\x82', '\x98', }, {'\xec', '\x82', '\xa0', }, {'\xec', '\x82', '\xa1', }, {'\xec', '\x82', '\xa3', }, {'\xec', '\x82', '\xa5', }, {'\xec', '\x82', '\xac', }, {'\xec', '\x82', '\xad', }, {'\xec', '\x82', '\xaf', }, {'\xec', '\x82', '\xb0', }, {'\xec', '\x82', '\xb3', }, {'\xec', '\x82', '\xb4', }, {'\xec', '\x82', '\xb5', }, {'\xec', '\x82', '\xb6', }, {'\xec', '\x82', '\xbc', }, {'\xec', '\x82', '\xbd', }, {'\xec', '\x82', '\xbf', }, {'\xec', '\x83', '\x80', }, {'\xec', '\x83', '\x81', }, {'\xec', '\x83', '\x85', }, {'\xec', '\x83', '\x88', }, {'\xec', '\x83', '\x89', }, {'\xec', '\x83', '\x8c', }, {'\xec', '\x83', '\x90', }, {'\xec', '\x83', '\x98', }, {'\xec', '\x83', '\x99', }, {'\xec', '\x83', '\x9b', }, {'\xec', '\x83', '\x9c', }, {'\xec', '\x83', '\x9d', }, {'\xec', '\x83', '\xa4', }, {'\xec', '\x83', '\xa5', }, {'\xec', '\x83', '\xa8', }, {'\xec', '\x83', '\xac', }, {'\xec', '\x83', '\xb4', }, {'\xec', '\x83', '\xb5', }, {'\xec', '\x83', '\xb7', }, {'\xec', '\x83', '\xb9', }, {'\xec', '\x84', '\x80', }, {'\xec', '\x84', '\x84', }, {'\xec', '\x84', '\x88', }, {'\xec', '\x84', '\x90', }, {'\xec', '\x84', '\x95', }, {'\xec', '\x84', '\x9c', }, {'\xec', '\x84', '\x9d', }, {'\xec', '\x84', '\x9e', }, {'\xec', '\x84', '\x9f', }, {'\xec', '\x84', '\xa0', }, {'\xec', '\x84', '\xa3', }, {'\xec', '\x84', '\xa4', }, {'\xec', '\x84', '\xa6', }, {'\xec', '\x84', '\xa7', }, {'\xec', '\x84', '\xac', }, {'\xec', '\x84', '\xad', }, {'\xec', '\x84', '\xaf', }, {'\xec', '\x84', '\xb0', }, {'\xec', '\x84', '\xb1', }, {'\xec', '\x84', '\xb6', }, {'\xec', '\x84', '\xb8', }, {'\xec', '\x84', '\xb9', }, {'\xec', '\x84', '\xbc', }, {'\xec', '\x85', '\x80', }, {'\xec', '\x85', '\x88', }, {'\xec', '\x85', '\x89', }, {'\xec', '\x85', '\x8b', }, {'\xec', '\x85', '\x8c', }, {'\xec', '\x85', '\x8d', }, {'\xec', '\x85', '\x94', }, {'\xec', '\x85', '\x95', }, {'\xec', '\x85', '\x98', }, {'\xec', '\x85', '\x9c', }, {'\xec', '\x85', '\xa4', }, {'\xec', '\x85', '\xa5', }, {'\xec', '\x85', '\xa7', }, {'\xec', '\x85', '\xa8', }, {'\xec', '\x85', '\xa9', }, {'\xec', '\x85', '\xb0', }, {'\xec', '\x85', '\xb4', }, {'\xec', '\x85', '\xb8', }, {'\xec', '\x86', '\x85', }, {'\xec', '\x86', '\x8c', }, {'\xec', '\x86', '\x8d', }, {'\xec', '\x86', '\x8e', }, {'\xec', '\x86', '\x90', }, {'\xec', '\x86', '\x94', }, {'\xec', '\x86', '\x96', }, {'\xec', '\x86', '\x9c', }, {'\xec', '\x86', '\x9d', }, {'\xec', '\x86', '\x9f', }, {'\xec', '\x86', '\xa1', }, {'\xec', '\x86', '\xa5', }, {'\xec', '\x86', '\xa8', }, {'\xec', '\x86', '\xa9', }, {'\xec', '\x86', '\xac', }, {'\xec', '\x86', '\xb0', }, {'\xec', '\x86', '\xbd', }, {'\xec', '\x87', '\x84', }, {'\xec', '\x87', '\x88', }, {'\xec', '\x87', '\x8c', }, {'\xec', '\x87', '\x94', }, {'\xec', '\x87', '\x97', }, {'\xec', '\x87', '\x98', }, {'\xec', '\x87', '\xa0', }, {'\xec', '\x87', '\xa4', }, {'\xec', '\x87', '\xa8', }, {'\xec', '\x87', '\xb0', }, {'\xec', '\x87', '\xb1', }, {'\xec', '\x87', '\xb3', }, {'\xec', '\x87', '\xbc', }, {'\xec', '\x87', '\xbd', }, {'\xec', '\x88', '\x80', }, {'\xec', '\x88', '\x84', }, {'\xec', '\x88', '\x8c', }, {'\xec', '\x88', '\x8d', }, {'\xec', '\x88', '\x8f', }, {'\xec', '\x88', '\x91', }, {'\xec', '\x88', '\x98', }, {'\xec', '\x88', '\x99', }, {'\xec', '\x88', '\x9c', }, {'\xec', '\x88', '\x9f', }, {'\xec', '\x88', '\xa0', }, {'\xec', '\x88', '\xa8', }, {'\xec', '\x88', '\xa9', }, {'\xec', '\x88', '\xab', }, {'\xec', '\x88', '\xad', }, {'\xec', '\x88', '\xaf', }, {'\xec', '\x88', '\xb1', }, {'\xec', '\x88', '\xb2', }, {'\xec', '\x88', '\xb4', }, {'\xec', '\x89', '\x88', }, {'\xec', '\x89', '\x90', }, {'\xec', '\x89', '\x91', }, {'\xec', '\x89', '\x94', }, {'\xec', '\x89', '\x98', }, {'\xec', '\x89', '\xa0', }, {'\xec', '\x89', '\xa5', }, {'\xec', '\x89', '\xac', }, {'\xec', '\x89', '\xad', }, {'\xec', '\x89', '\xb0', }, {'\xec', '\x89', '\xb4', }, {'\xec', '\x89', '\xbc', }, {'\xec', '\x89', '\xbd', }, {'\xec', '\x89', '\xbf', }, {'\xec', '\x8a', '\x81', }, {'\xec', '\x8a', '\x88', }, {'\xec', '\x8a', '\x89', }, {'\xec', '\x8a', '\x90', }, {'\xec', '\x8a', '\x98', }, {'\xec', '\x8a', '\x9b', }, {'\xec', '\x8a', '\x9d', }, {'\xec', '\x8a', '\xa4', }, {'\xec', '\x8a', '\xa5', }, {'\xec', '\x8a', '\xa8', }, {'\xec', '\x8a', '\xac', }, {'\xec', '\x8a', '\xad', }, {'\xec', '\x8a', '\xb4', }, {'\xec', '\x8a', '\xb5', }, {'\xec', '\x8a', '\xb7', }, {'\xec', '\x8a', '\xb9', }, {'\xec', '\x8b', '\x9c', }, {'\xec', '\x8b', '\x9d', }, {'\xec', '\x8b', '\xa0', }, {'\xec', '\x8b', '\xa3', }, {'\xec', '\x8b', '\xa4', }, {'\xec', '\x8b', '\xab', }, {'\xec', '\x8b', '\xac', }, {'\xec', '\x8b', '\xad', }, {'\xec', '\x8b', '\xaf', }, {'\xec', '\x8b', '\xb1', }, {'\xec', '\x8b', '\xb6', }, {'\xec', '\x8b', '\xb8', }, {'\xec', '\x8b', '\xb9', }, {'\xec', '\x8b', '\xbb', }, {'\xec', '\x8b', '\xbc', }, {'\xec', '\x8c', '\x80', }, {'\xec', '\x8c', '\x88', }, {'\xec', '\x8c', '\x89', }, {'\xec', '\x8c', '\x8c', }, {'\xec', '\x8c', '\x8d', }, {'\xec', '\x8c', '\x93', }, {'\xec', '\x8c', '\x94', }, {'\xec', '\x8c', '\x95', }, {'\xec', '\x8c', '\x98', }, {'\xec', '\x8c', '\x9c', }, {'\xec', '\x8c', '\xa4', }, {'\xec', '\x8c', '\xa5', }, {'\xec', '\x8c', '\xa8', }, {'\xec', '\x8c', '\xa9', }, {'\xec', '\x8d', '\x85', }, {'\xec', '\x8d', '\xa8', }, {'\xec', '\x8d', '\xa9', }, {'\xec', '\x8d', '\xac', }, {'\xec', '\x8d', '\xb0', }, {'\xec', '\x8d', '\xb2', }, {'\xec', '\x8d', '\xb8', }, {'\xec', '\x8d', '\xb9', }, {'\xec', '\x8d', '\xbc', }, {'\xec', '\x8d', '\xbd', }, {'\xec', '\x8e', '\x84', }, {'\xec', '\x8e', '\x88', }, {'\xec', '\x8e', '\x8c', }, {'\xec', '\x8f', '\x80', }, {'\xec', '\x8f', '\x98', }, {'\xec', '\x8f', '\x99', }, {'\xec', '\x8f', '\x9c', }, {'\xec', '\x8f', '\x9f', }, {'\xec', '\x8f', '\xa0', }, {'\xec', '\x8f', '\xa2', }, {'\xec', '\x8f', '\xa8', }, {'\xec', '\x8f', '\xa9', }, {'\xec', '\x8f', '\xad', }, {'\xec', '\x8f', '\xb4', }, {'\xec', '\x8f', '\xb5', }, {'\xec', '\x8f', '\xb8', }, {'\xec', '\x90', '\x88', }, {'\xec', '\x90', '\x90', }, {'\xec', '\x90', '\xa4', }, {'\xec', '\x90', '\xac', }, {'\xec', '\x90', '\xb0', }, {'\xec', '\x90', '\xb4', }, {'\xec', '\x90', '\xbc', }, {'\xec', '\x90', '\xbd', }, {'\xec', '\x91', '\x88', }, {'\xec', '\x91', '\xa4', }, {'\xec', '\x91', '\xa5', }, {'\xec', '\x91', '\xa8', }, {'\xec', '\x91', '\xac', }, {'\xec', '\x91', '\xb4', }, {'\xec', '\x91', '\xb5', }, {'\xec', '\x91', '\xb9', }, {'\xec', '\x92', '\x80', }, {'\xec', '\x92', '\x94', }, {'\xec', '\x92', '\x9c', }, {'\xec', '\x92', '\xb8', }, {'\xec', '\x92', '\xbc', }, {'\xec', '\x93', '\xa9', }, {'\xec', '\x93', '\xb0', }, {'\xec', '\x93', '\xb1', }, {'\xec', '\x93', '\xb4', }, {'\xec', '\x93', '\xb8', }, {'\xec', '\x93', '\xba', }, {'\xec', '\x93', '\xbf', }, {'\xec', '\x94', '\x80', }, {'\xec', '\x94', '\x81', }, {'\xec', '\x94', '\x8c', }, {'\xec', '\x94', '\x90', }, {'\xec', '\x94', '\x94', }, {'\xec', '\x94', '\x9c', }, {'\xec', '\x94', '\xa8', }, {'\xec', '\x94', '\xa9', }, {'\xec', '\x94', '\xac', }, {'\xec', '\x94', '\xb0', }, {'\xec', '\x94', '\xb8', }, {'\xec', '\x94', '\xb9', }, {'\xec', '\x94', '\xbb', }, {'\xec', '\x94', '\xbd', }, {'\xec', '\x95', '\x84', }, {'\xec', '\x95', '\x85', }, {'\xec', '\x95', '\x88', }, {'\xec', '\x95', '\x89', }, {'\xec', '\x95', '\x8a', }, {'\xec', '\x95', '\x8c', }, {'\xec', '\x95', '\x8d', }, {'\xec', '\x95', '\x8e', }, {'\xec', '\x95', '\x93', }, {'\xec', '\x95', '\x94', }, {'\xec', '\x95', '\x95', }, {'\xec', '\x95', '\x97', }, {'\xec', '\x95', '\x98', }, {'\xec', '\x95', '\x99', }, {'\xec', '\x95', '\x9d', }, {'\xec', '\x95', '\x9e', }, {'\xec', '\x95', '\xa0', }, {'\xec', '\x95', '\xa1', }, {'\xec', '\x95', '\xa4', }, {'\xec', '\x95', '\xa8', }, {'\xec', '\x95', '\xb0', }, {'\xec', '\x95', '\xb1', }, {'\xec', '\x95', '\xb3', }, {'\xec', '\x95', '\xb4', }, {'\xec', '\x95', '\xb5', }, {'\xec', '\x95', '\xbc', }, {'\xec', '\x95', '\xbd', }, {'\xec', '\x96', '\x80', }, {'\xec', '\x96', '\x84', }, {'\xec', '\x96', '\x87', }, {'\xec', '\x96', '\x8c', }, {'\xec', '\x96', '\x8d', }, {'\xec', '\x96', '\x8f', }, {'\xec', '\x96', '\x91', }, {'\xec', '\x96', '\x95', }, {'\xec', '\x96', '\x97', }, {'\xec', '\x96', '\x98', }, {'\xec', '\x96', '\x9c', }, {'\xec', '\x96', '\xa0', }, {'\xec', '\x96', '\xa9', }, {'\xec', '\x96', '\xb4', }, {'\xec', '\x96', '\xb5', }, {'\xec', '\x96', '\xb8', }, {'\xec', '\x96', '\xb9', }, {'\xec', '\x96', '\xbb', }, {'\xec', '\x96', '\xbc', }, {'\xec', '\x96', '\xbd', }, {'\xec', '\x96', '\xbe', }, {'\xec', '\x97', '\x84', }, {'\xec', '\x97', '\x85', }, {'\xec', '\x97', '\x86', }, {'\xec', '\x97', '\x87', }, {'\xec', '\x97', '\x88', }, {'\xec', '\x97', '\x89', }, {'\xec', '\x97', '\x8a', }, {'\xec', '\x97', '\x8c', }, {'\xec', '\x97', '\x8e', }, {'\xec', '\x97', '\x90', }, {'\xec', '\x97', '\x91', }, {'\xec', '\x97', '\x94', }, {'\xec', '\x97', '\x98', }, {'\xec', '\x97', '\xa0', }, {'\xec', '\x97', '\xa1', }, {'\xec', '\x97', '\xa3', }, {'\xec', '\x97', '\xa5', }, {'\xec', '\x97', '\xac', }, {'\xec', '\x97', '\xad', }, {'\xec', '\x97', '\xae', }, {'\xec', '\x97', '\xb0', }, {'\xec', '\x97', '\xb4', }, {'\xec', '\x97', '\xb6', }, {'\xec', '\x97', '\xb7', }, {'\xec', '\x97', '\xbc', }, {'\xec', '\x97', '\xbd', }, {'\xec', '\x97', '\xbe', }, {'\xec', '\x97', '\xbf', }, {'\xec', '\x98', '\x80', }, {'\xec', '\x98', '\x81', }, {'\xec', '\x98', '\x85', }, {'\xec', '\x98', '\x86', }, {'\xec', '\x98', '\x87', }, {'\xec', '\x98', '\x88', }, {'\xec', '\x98', '\x8c', }, {'\xec', '\x98', '\x90', }, {'\xec', '\x98', '\x98', }, {'\xec', '\x98', '\x99', }, {'\xec', '\x98', '\x9b', }, {'\xec', '\x98', '\x9c', }, {'\xec', '\x98', '\xa4', }, {'\xec', '\x98', '\xa5', }, {'\xec', '\x98', '\xa8', }, {'\xec', '\x98', '\xac', }, {'\xec', '\x98', '\xad', }, {'\xec', '\x98', '\xae', }, {'\xec', '\x98', '\xb0', }, {'\xec', '\x98', '\xb3', }, {'\xec', '\x98', '\xb4', }, {'\xec', '\x98', '\xb5', }, {'\xec', '\x98', '\xb7', }, {'\xec', '\x98', '\xb9', }, {'\xec', '\x98', '\xbb', }, {'\xec', '\x99', '\x80', }, {'\xec', '\x99', '\x81', }, {'\xec', '\x99', '\x84', }, {'\xec', '\x99', '\x88', }, {'\xec', '\x99', '\x90', }, {'\xec', '\x99', '\x91', }, {'\xec', '\x99', '\x93', }, {'\xec', '\x99', '\x94', }, {'\xec', '\x99', '\x95', }, {'\xec', '\x99', '\x9c', }, {'\xec', '\x99', '\x9d', }, {'\xec', '\x99', '\xa0', }, {'\xec', '\x99', '\xac', }, {'\xec', '\x99', '\xaf', }, {'\xec', '\x99', '\xb1', }, {'\xec', '\x99', '\xb8', }, {'\xec', '\x99', '\xb9', }, {'\xec', '\x99', '\xbc', }, {'\xec', '\x9a', '\x80', }, {'\xec', '\x9a', '\x88', }, {'\xec', '\x9a', '\x89', }, {'\xec', '\x9a', '\x8b', }, {'\xec', '\x9a', '\x8d', }, {'\xec', '\x9a', '\x94', }, {'\xec', '\x9a', '\x95', }, {'\xec', '\x9a', '\x98', }, {'\xec', '\x9a', '\x9c', }, {'\xec', '\x9a', '\xa4', }, {'\xec', '\x9a', '\xa5', }, {'\xec', '\x9a', '\xa7', }, {'\xec', '\x9a', '\xa9', }, {'\xec', '\x9a', '\xb0', }, {'\xec', '\x9a', '\xb1', }, {'\xec', '\x9a', '\xb4', }, {'\xec', '\x9a', '\xb8', }, {'\xec', '\x9a', '\xb9', }, {'\xec', '\x9a', '\xba', }, {'\xec', '\x9b', '\x80', }, {'\xec', '\x9b', '\x81', }, {'\xec', '\x9b', '\x83', }, {'\xec', '\x9b', '\x85', }, {'\xec', '\x9b', '\x8c', }, {'\xec', '\x9b', '\x8d', }, {'\xec', '\x9b', '\x90', }, {'\xec', '\x9b', '\x94', }, {'\xec', '\x9b', '\x9c', }, {'\xec', '\x9b', '\x9d', }, {'\xec', '\x9b', '\xa0', }, {'\xec', '\x9b', '\xa1', }, {'\xec', '\x9b', '\xa8', }, {'\xec', '\x9b', '\xa9', }, {'\xec', '\x9b', '\xac', }, {'\xec', '\x9b', '\xb0', }, {'\xec', '\x9b', '\xb8', }, {'\xec', '\x9b', '\xb9', }, {'\xec', '\x9b', '\xbd', }, {'\xec', '\x9c', '\x84', }, {'\xec', '\x9c', '\x85', }, {'\xec', '\x9c', '\x88', }, {'\xec', '\x9c', '\x8c', }, {'\xec', '\x9c', '\x94', }, {'\xec', '\x9c', '\x95', }, {'\xec', '\x9c', '\x97', }, {'\xec', '\x9c', '\x99', }, {'\xec', '\x9c', '\xa0', }, {'\xec', '\x9c', '\xa1', }, {'\xec', '\x9c', '\xa4', }, {'\xec', '\x9c', '\xa8', }, {'\xec', '\x9c', '\xb0', }, {'\xec', '\x9c', '\xb1', }, {'\xec', '\x9c', '\xb3', }, {'\xec', '\x9c', '\xb5', }, {'\xec', '\x9c', '\xb7', }, {'\xec', '\x9c', '\xbc', }, {'\xec', '\x9c', '\xbd', }, {'\xec', '\x9d', '\x80', }, {'\xec', '\x9d', '\x84', }, {'\xec', '\x9d', '\x8a', }, {'\xec', '\x9d', '\x8c', }, {'\xec', '\x9d', '\x8d', }, {'\xec', '\x9d', '\x8f', }, {'\xec', '\x9d', '\x91', }, {'\xec', '\x9d', '\x92', }, {'\xec', '\x9d', '\x93', }, {'\xec', '\x9d', '\x94', }, {'\xec', '\x9d', '\x95', }, {'\xec', '\x9d', '\x96', }, {'\xec', '\x9d', '\x97', }, {'\xec', '\x9d', '\x98', }, {'\xec', '\x9d', '\x9c', }, {'\xec', '\x9d', '\xa0', }, {'\xec', '\x9d', '\xa8', }, {'\xec', '\x9d', '\xab', }, {'\xec', '\x9d', '\xb4', }, {'\xec', '\x9d', '\xb5', }, {'\xec', '\x9d', '\xb8', }, {'\xec', '\x9d', '\xbc', }, {'\xec', '\x9d', '\xbd', }, {'\xec', '\x9d', '\xbe', }, {'\xec', '\x9e', '\x83', }, {'\xec', '\x9e', '\x84', }, {'\xec', '\x9e', '\x85', }, {'\xec', '\x9e', '\x87', }, {'\xec', '\x9e', '\x88', }, {'\xec', '\x9e', '\x89', }, {'\xec', '\x9e', '\x8a', }, {'\xec', '\x9e', '\x8e', }, {'\xec', '\x9e', '\x90', }, {'\xec', '\x9e', '\x91', }, {'\xec', '\x9e', '\x94', }, {'\xec', '\x9e', '\x96', }, {'\xec', '\x9e', '\x97', }, {'\xec', '\x9e', '\x98', }, {'\xec', '\x9e', '\x9a', }, {'\xec', '\x9e', '\xa0', }, {'\xec', '\x9e', '\xa1', }, {'\xec', '\x9e', '\xa3', }, {'\xec', '\x9e', '\xa4', }, {'\xec', '\x9e', '\xa5', }, {'\xec', '\x9e', '\xa6', }, {'\xec', '\x9e', '\xac', }, {'\xec', '\x9e', '\xad', }, {'\xec', '\x9e', '\xb0', }, {'\xec', '\x9e', '\xb4', }, {'\xec', '\x9e', '\xbc', }, {'\xec', '\x9e', '\xbd', }, {'\xec', '\x9e', '\xbf', }, {'\xec', '\x9f', '\x80', }, {'\xec', '\x9f', '\x81', }, {'\xec', '\x9f', '\x88', }, {'\xec', '\x9f', '\x89', }, {'\xec', '\x9f', '\x8c', }, {'\xec', '\x9f', '\x8e', }, {'\xec', '\x9f', '\x90', }, {'\xec', '\x9f', '\x98', }, {'\xec', '\x9f', '\x9d', }, {'\xec', '\x9f', '\xa4', }, {'\xec', '\x9f', '\xa8', }, {'\xec', '\x9f', '\xac', }, {'\xec', '\xa0', '\x80', }, {'\xec', '\xa0', '\x81', }, {'\xec', '\xa0', '\x84', }, {'\xec', '\xa0', '\x88', }, {'\xec', '\xa0', '\x8a', }, {'\xec', '\xa0', '\x90', }, {'\xec', '\xa0', '\x91', }, {'\xec', '\xa0', '\x93', }, {'\xec', '\xa0', '\x95', }, {'\xec', '\xa0', '\x96', }, {'\xec', '\xa0', '\x9c', }, {'\xec', '\xa0', '\x9d', }, {'\xec', '\xa0', '\xa0', }, {'\xec', '\xa0', '\xa4', }, {'\xec', '\xa0', '\xac', }, {'\xec', '\xa0', '\xad', }, {'\xec', '\xa0', '\xaf', }, {'\xec', '\xa0', '\xb1', }, {'\xec', '\xa0', '\xb8', }, {'\xec', '\xa0', '\xbc', }, {'\xec', '\xa1', '\x80', }, {'\xec', '\xa1', '\x88', }, {'\xec', '\xa1', '\x89', }, {'\xec', '\xa1', '\x8c', }, {'\xec', '\xa1', '\x8d', }, {'\xec', '\xa1', '\x94', }, {'\xec', '\xa1', '\xb0', }, {'\xec', '\xa1', '\xb1', }, {'\xec', '\xa1', '\xb4', }, {'\xec', '\xa1', '\xb8', }, {'\xec', '\xa1', '\xba', }, {'\xec', '\xa2', '\x80', }, {'\xec', '\xa2', '\x81', }, {'\xec', '\xa2', '\x83', }, {'\xec', '\xa2', '\x85', }, {'\xec', '\xa2', '\x86', }, {'\xec', '\xa2', '\x87', }, {'\xec', '\xa2', '\x8b', }, {'\xec', '\xa2', '\x8c', }, {'\xec', '\xa2', '\x8d', }, {'\xec', '\xa2', '\x94', }, {'\xec', '\xa2', '\x9d', }, {'\xec', '\xa2', '\x9f', }, {'\xec', '\xa2', '\xa1', }, {'\xec', '\xa2', '\xa8', }, {'\xec', '\xa2', '\xbc', }, {'\xec', '\xa2', '\xbd', }, {'\xec', '\xa3', '\x84', }, {'\xec', '\xa3', '\x88', }, {'\xec', '\xa3', '\x8c', }, {'\xec', '\xa3', '\x94', }, {'\xec', '\xa3', '\x95', }, {'\xec', '\xa3', '\x97', }, {'\xec', '\xa3', '\x99', }, {'\xec', '\xa3', '\xa0', }, {'\xec', '\xa3', '\xa1', }, {'\xec', '\xa3', '\xa4', }, {'\xec', '\xa3', '\xb5', }, {'\xec', '\xa3', '\xbc', }, {'\xec', '\xa3', '\xbd', }, {'\xec', '\xa4', '\x80', }, {'\xec', '\xa4', '\x84', }, {'\xec', '\xa4', '\x85', }, {'\xec', '\xa4', '\x86', }, {'\xec', '\xa4', '\x8c', }, {'\xec', '\xa4', '\x8d', }, {'\xec', '\xa4', '\x8f', }, {'\xec', '\xa4', '\x91', }, {'\xec', '\xa4', '\x98', }, {'\xec', '\xa4', '\xac', }, {'\xec', '\xa4', '\xb4', }, {'\xec', '\xa5', '\x90', }, {'\xec', '\xa5', '\x91', }, {'\xec', '\xa5', '\x94', }, {'\xec', '\xa5', '\x98', }, {'\xec', '\xa5', '\xa0', }, {'\xec', '\xa5', '\xa1', }, {'\xec', '\xa5', '\xa3', }, {'\xec', '\xa5', '\xac', }, {'\xec', '\xa5', '\xb0', }, {'\xec', '\xa5', '\xb4', }, {'\xec', '\xa5', '\xbc', }, {'\xec', '\xa6', '\x88', }, {'\xec', '\xa6', '\x89', }, {'\xec', '\xa6', '\x8c', }, {'\xec', '\xa6', '\x90', }, {'\xec', '\xa6', '\x98', }, {'\xec', '\xa6', '\x99', }, {'\xec', '\xa6', '\x9b', }, {'\xec', '\xa6', '\x9d', }, {'\xec', '\xa7', '\x80', }, {'\xec', '\xa7', '\x81', }, {'\xec', '\xa7', '\x84', }, {'\xec', '\xa7', '\x87', }, {'\xec', '\xa7', '\x88', }, {'\xec', '\xa7', '\x8a', }, {'\xec', '\xa7', '\x90', }, {'\xec', '\xa7', '\x91', }, {'\xec', '\xa7', '\x93', }, {'\xec', '\xa7', '\x95', }, {'\xec', '\xa7', '\x96', }, {'\xec', '\xa7', '\x99', }, {'\xec', '\xa7', '\x9a', }, {'\xec', '\xa7', '\x9c', }, {'\xec', '\xa7', '\x9d', }, {'\xec', '\xa7', '\xa0', }, {'\xec', '\xa7', '\xa2', }, {'\xec', '\xa7', '\xa4', }, {'\xec', '\xa7', '\xa7', }, {'\xec', '\xa7', '\xac', }, {'\xec', '\xa7', '\xad', }, {'\xec', '\xa7', '\xaf', }, {'\xec', '\xa7', '\xb0', }, {'\xec', '\xa7', '\xb1', }, {'\xec', '\xa7', '\xb8', }, {'\xec', '\xa7', '\xb9', }, {'\xec', '\xa7', '\xbc', }, {'\xec', '\xa8', '\x80', }, {'\xec', '\xa8', '\x88', }, {'\xec', '\xa8', '\x89', }, {'\xec', '\xa8', '\x8b', }, {'\xec', '\xa8', '\x8c', }, {'\xec', '\xa8', '\x8d', }, {'\xec', '\xa8', '\x94', }, {'\xec', '\xa8', '\x98', }, {'\xec', '\xa8', '\xa9', }, {'\xec', '\xa9', '\x8c', }, {'\xec', '\xa9', '\x8d', }, {'\xec', '\xa9', '\x90', }, {'\xec', '\xa9', '\x94', }, {'\xec', '\xa9', '\x9c', }, {'\xec', '\xa9', '\x9d', }, {'\xec', '\xa9', '\x9f', }, {'\xec', '\xa9', '\xa0', }, {'\xec', '\xa9', '\xa1', }, {'\xec', '\xa9', '\xa8', }, {'\xec', '\xa9', '\xbd', }, {'\xec', '\xaa', '\x84', }, {'\xec', '\xaa', '\x98', }, {'\xec', '\xaa', '\xbc', }, {'\xec', '\xaa', '\xbd', }, {'\xec', '\xab', '\x80', }, {'\xec', '\xab', '\x84', }, {'\xec', '\xab', '\x8c', }, {'\xec', '\xab', '\x8d', }, {'\xec', '\xab', '\x8f', }, {'\xec', '\xab', '\x91', }, {'\xec', '\xab', '\x93', }, {'\xec', '\xab', '\x98', }, {'\xec', '\xab', '\x99', }, {'\xec', '\xab', '\xa0', }, {'\xec', '\xab', '\xac', }, {'\xec', '\xab', '\xb4', }, {'\xec', '\xac', '\x88', }, {'\xec', '\xac', '\x90', }, {'\xec', '\xac', '\x94', }, {'\xec', '\xac', '\x98', }, {'\xec', '\xac', '\xa0', }, {'\xec', '\xac', '\xa1', }, {'\xec', '\xad', '\x81', }, {'\xec', '\xad', '\x88', }, {'\xec', '\xad', '\x89', }, {'\xec', '\xad', '\x8c', }, {'\xec', '\xad', '\x90', }, {'\xec', '\xad', '\x98', }, {'\xec', '\xad', '\x99', }, {'\xec', '\xad', '\x9d', }, {'\xec', '\xad', '\xa4', }, {'\xec', '\xad', '\xb8', }, {'\xec', '\xad', '\xb9', }, {'\xec', '\xae', '\x9c', }, {'\xec', '\xae', '\xb8', }, {'\xec', '\xaf', '\x94', }, {'\xec', '\xaf', '\xa4', }, {'\xec', '\xaf', '\xa7', }, {'\xec', '\xaf', '\xa9', }, {'\xec', '\xb0', '\x8c', }, {'\xec', '\xb0', '\x8d', }, {'\xec', '\xb0', '\x90', }, {'\xec', '\xb0', '\x94', }, {'\xec', '\xb0', '\x9c', }, {'\xec', '\xb0', '\x9d', }, {'\xec', '\xb0', '\xa1', }, {'\xec', '\xb0', '\xa2', }, {'\xec', '\xb0', '\xa7', }, {'\xec', '\xb0', '\xa8', }, {'\xec', '\xb0', '\xa9', }, {'\xec', '\xb0', '\xac', }, {'\xec', '\xb0', '\xae', }, {'\xec', '\xb0', '\xb0', }, {'\xec', '\xb0', '\xb8', }, {'\xec', '\xb0', '\xb9', }, {'\xec', '\xb0', '\xbb', }, {'\xec', '\xb0', '\xbc', }, {'\xec', '\xb0', '\xbd', }, {'\xec', '\xb0', '\xbe', }, {'\xec', '\xb1', '\x84', }, {'\xec', '\xb1', '\x85', }, {'\xec', '\xb1', '\x88', }, {'\xec', '\xb1', '\x8c', }, {'\xec', '\xb1', '\x94', }, {'\xec', '\xb1', '\x95', }, {'\xec', '\xb1', '\x97', }, {'\xec', '\xb1', '\x98', }, {'\xec', '\xb1', '\x99', }, {'\xec', '\xb1', '\xa0', }, {'\xec', '\xb1', '\xa4', }, {'\xec', '\xb1', '\xa6', }, {'\xec', '\xb1', '\xa8', }, {'\xec', '\xb1', '\xb0', }, {'\xec', '\xb1', '\xb5', }, {'\xec', '\xb2', '\x98', }, {'\xec', '\xb2', '\x99', }, {'\xec', '\xb2', '\x9c', }, {'\xec', '\xb2', '\xa0', }, {'\xec', '\xb2', '\xa8', }, {'\xec', '\xb2', '\xa9', }, {'\xec', '\xb2', '\xab', }, {'\xec', '\xb2', '\xac', }, {'\xec', '\xb2', '\xad', }, {'\xec', '\xb2', '\xb4', }, {'\xec', '\xb2', '\xb5', }, {'\xec', '\xb2', '\xb8', }, {'\xec', '\xb2', '\xbc', }, {'\xec', '\xb3', '\x84', }, {'\xec', '\xb3', '\x85', }, {'\xec', '\xb3', '\x87', }, {'\xec', '\xb3', '\x89', }, {'\xec', '\xb3', '\x90', }, {'\xec', '\xb3', '\x94', }, {'\xec', '\xb3', '\xa4', }, {'\xec', '\xb3', '\xac', }, {'\xec', '\xb3', '\xb0', }, {'\xec', '\xb4', '\x81', }, {'\xec', '\xb4', '\x88', }, {'\xec', '\xb4', '\x89', }, {'\xec', '\xb4', '\x8c', }, {'\xec', '\xb4', '\x90', }, {'\xec', '\xb4', '\x98', }, {'\xec', '\xb4', '\x99', }, {'\xec', '\xb4', '\x9b', }, {'\xec', '\xb4', '\x9d', }, {'\xec', '\xb4', '\xa4', }, {'\xec', '\xb4', '\xa8', }, {'\xec', '\xb4', '\xac', }, {'\xec', '\xb4', '\xb9', }, {'\xec', '\xb5', '\x9c', }, {'\xec', '\xb5', '\xa0', }, {'\xec', '\xb5', '\xa4', }, {'\xec', '\xb5', '\xac', }, {'\xec', '\xb5', '\xad', }, {'\xec', '\xb5', '\xaf', }, {'\xec', '\xb5', '\xb1', }, {'\xec', '\xb5', '\xb8', }, {'\xec', '\xb6', '\x88', }, {'\xec', '\xb6', '\x94', }, {'\xec', '\xb6', '\x95', }, {'\xec', '\xb6', '\x98', }, {'\xec', '\xb6', '\x9c', }, {'\xec', '\xb6', '\xa4', }, {'\xec', '\xb6', '\xa5', }, {'\xec', '\xb6', '\xa7', }, {'\xec', '\xb6', '\xa9', }, {'\xec', '\xb6', '\xb0', }, {'\xec', '\xb7', '\x84', }, {'\xec', '\xb7', '\x8c', }, {'\xec', '\xb7', '\x90', }, {'\xec', '\xb7', '\xa8', }, {'\xec', '\xb7', '\xac', }, {'\xec', '\xb7', '\xb0', }, {'\xec', '\xb7', '\xb8', }, {'\xec', '\xb7', '\xb9', }, {'\xec', '\xb7', '\xbb', }, {'\xec', '\xb7', '\xbd', }, {'\xec', '\xb8', '\x84', }, {'\xec', '\xb8', '\x88', }, {'\xec', '\xb8', '\x8c', }, {'\xec', '\xb8', '\x94', }, {'\xec', '\xb8', '\x99', }, {'\xec', '\xb8', '\xa0', }, {'\xec', '\xb8', '\xa1', }, {'\xec', '\xb8', '\xa4', }, {'\xec', '\xb8', '\xa8', }, {'\xec', '\xb8', '\xb0', }, {'\xec', '\xb8', '\xb1', }, {'\xec', '\xb8', '\xb3', }, {'\xec', '\xb8', '\xb5', }, {'\xec', '\xb9', '\x98', }, {'\xec', '\xb9', '\x99', }, {'\xec', '\xb9', '\x9c', }, {'\xec', '\xb9', '\x9f', }, {'\xec', '\xb9', '\xa0', }, {'\xec', '\xb9', '\xa1', }, {'\xec', '\xb9', '\xa8', }, {'\xec', '\xb9', '\xa9', }, {'\xec', '\xb9', '\xab', }, {'\xec', '\xb9', '\xad', }, {'\xec', '\xb9', '\xb4', }, {'\xec', '\xb9', '\xb5', }, {'\xec', '\xb9', '\xb8', }, {'\xec', '\xb9', '\xbc', }, {'\xec', '\xba', '\x84', }, {'\xec', '\xba', '\x85', }, {'\xec', '\xba', '\x87', }, {'\xec', '\xba', '\x89', }, {'\xec', '\xba', '\x90', }, {'\xec', '\xba', '\x91', }, {'\xec', '\xba', '\x94', }, {'\xec', '\xba', '\x98', }, {'\xec', '\xba', '\xa0', }, {'\xec', '\xba', '\xa1', }, {'\xec', '\xba', '\xa3', }, {'\xec', '\xba', '\xa4', }, {'\xec', '\xba', '\xa5', }, {'\xec', '\xba', '\xac', }, {'\xec', '\xba', '\xad', }, {'\xec', '\xbb', '\x81', }, {'\xec', '\xbb', '\xa4', }, {'\xec', '\xbb', '\xa5', }, {'\xec', '\xbb', '\xa8', }, {'\xec', '\xbb', '\xab', }, {'\xec', '\xbb', '\xac', }, {'\xec', '\xbb', '\xb4', }, {'\xec', '\xbb', '\xb5', }, {'\xec', '\xbb', '\xb7', }, {'\xec', '\xbb', '\xb8', }, {'\xec', '\xbb', '\xb9', }, {'\xec', '\xbc', '\x80', }, {'\xec', '\xbc', '\x81', }, {'\xec', '\xbc', '\x84', }, {'\xec', '\xbc', '\x88', }, {'\xec', '\xbc', '\x90', }, {'\xec', '\xbc', '\x91', }, {'\xec', '\xbc', '\x93', }, {'\xec', '\xbc', '\x95', }, {'\xec', '\xbc', '\x9c', }, {'\xec', '\xbc', '\xa0', }, {'\xec', '\xbc', '\xa4', }, {'\xec', '\xbc', '\xac', }, {'\xec', '\xbc', '\xad', }, {'\xec', '\xbc', '\xaf', }, {'\xec', '\xbc', '\xb0', }, {'\xec', '\xbc', '\xb1', }, {'\xec', '\xbc', '\xb8', }, {'\xec', '\xbd', '\x94', }, {'\xec', '\xbd', '\x95', }, {'\xec', '\xbd', '\x98', }, {'\xec', '\xbd', '\x9c', }, {'\xec', '\xbd', '\xa4', }, {'\xec', '\xbd', '\xa5', }, {'\xec', '\xbd', '\xa7', }, {'\xec', '\xbd', '\xa9', }, {'\xec', '\xbd', '\xb0', }, {'\xec', '\xbd', '\xb1', }, {'\xec', '\xbd', '\xb4', }, {'\xec', '\xbd', '\xb8', }, {'\xec', '\xbe', '\x80', }, {'\xec', '\xbe', '\x85', }, {'\xec', '\xbe', '\x8c', }, {'\xec', '\xbe', '\xa1', }, {'\xec', '\xbe', '\xa8', }, {'\xec', '\xbe', '\xb0', }, {'\xec', '\xbf', '\x84', }, {'\xec', '\xbf', '\xa0', }, {'\xec', '\xbf', '\xa1', }, {'\xec', '\xbf', '\xa4', }, {'\xec', '\xbf', '\xa8', }, {'\xec', '\xbf', '\xb0', }, {'\xec', '\xbf', '\xb1', }, {'\xec', '\xbf', '\xb3', }, {'\xec', '\xbf', '\xb5', }, {'\xec', '\xbf', '\xbc', }, {'\xed', '\x80', '\x80', }, {'\xed', '\x80', '\x84', }, {'\xed', '\x80', '\x91', }, {'\xed', '\x80', '\x98', }, {'\xed', '\x80', '\xad', }, {'\xed', '\x80', '\xb4', }, {'\xed', '\x80', '\xb5', }, {'\xed', '\x80', '\xb8', }, {'\xed', '\x80', '\xbc', }, {'\xed', '\x81', '\x84', }, {'\xed', '\x81', '\x85', }, {'\xed', '\x81', '\x87', }, {'\xed', '\x81', '\x89', }, {'\xed', '\x81', '\x90', }, {'\xed', '\x81', '\x94', }, {'\xed', '\x81', '\x98', }, {'\xed', '\x81', '\xa0', }, {'\xed', '\x81', '\xac', }, {'\xed', '\x81', '\xad', }, {'\xed', '\x81', '\xb0', }, {'\xed', '\x81', '\xb4', }, {'\xed', '\x81', '\xbc', }, {'\xed', '\x81', '\xbd', }, {'\xed', '\x82', '\x81', }, {'\xed', '\x82', '\xa4', }, {'\xed', '\x82', '\xa5', }, {'\xed', '\x82', '\xa8', }, {'\xed', '\x82', '\xac', }, {'\xed', '\x82', '\xb4', }, {'\xed', '\x82', '\xb5', }, {'\xed', '\x82', '\xb7', }, {'\xed', '\x82', '\xb9', }, {'\xed', '\x83', '\x80', }, {'\xed', '\x83', '\x81', }, {'\xed', '\x83', '\x84', }, {'\xed', '\x83', '\x88', }, {'\xed', '\x83', '\x89', }, {'\xed', '\x83', '\x90', }, {'\xed', '\x83', '\x91', }, {'\xed', '\x83', '\x93', }, {'\xed', '\x83', '\x94', }, {'\xed', '\x83', '\x95', }, {'\xed', '\x83', '\x9c', }, {'\xed', '\x83', '\x9d', }, {'\xed', '\x83', '\xa0', }, {'\xed', '\x83', '\xa4', }, {'\xed', '\x83', '\xac', }, {'\xed', '\x83', '\xad', }, {'\xed', '\x83', '\xaf', }, {'\xed', '\x83', '\xb0', }, {'\xed', '\x83', '\xb1', }, {'\xed', '\x83', '\xb8', }, {'\xed', '\x84', '\x8d', }, {'\xed', '\x84', '\xb0', }, {'\xed', '\x84', '\xb1', }, {'\xed', '\x84', '\xb4', }, {'\xed', '\x84', '\xb8', }, {'\xed', '\x84', '\xba', }, {'\xed', '\x85', '\x80', }, {'\xed', '\x85', '\x81', }, {'\xed', '\x85', '\x83', }, {'\xed', '\x85', '\x84', }, {'\xed', '\x85', '\x85', }, {'\xed', '\x85', '\x8c', }, {'\xed', '\x85', '\x8d', }, {'\xed', '\x85', '\x90', }, {'\xed', '\x85', '\x94', }, {'\xed', '\x85', '\x9c', }, {'\xed', '\x85', '\x9d', }, {'\xed', '\x85', '\x9f', }, {'\xed', '\x85', '\xa1', }, {'\xed', '\x85', '\xa8', }, {'\xed', '\x85', '\xac', }, {'\xed', '\x85', '\xbc', }, {'\xed', '\x86', '\x84', }, {'\xed', '\x86', '\x88', }, {'\xed', '\x86', '\xa0', }, {'\xed', '\x86', '\xa1', }, {'\xed', '\x86', '\xa4', }, {'\xed', '\x86', '\xa8', }, {'\xed', '\x86', '\xb0', }, {'\xed', '\x86', '\xb1', }, {'\xed', '\x86', '\xb3', }, {'\xed', '\x86', '\xb5', }, {'\xed', '\x86', '\xba', }, {'\xed', '\x86', '\xbc', }, {'\xed', '\x87', '\x80', }, {'\xed', '\x87', '\x98', }, {'\xed', '\x87', '\xb4', }, {'\xed', '\x87', '\xb8', }, {'\xed', '\x88', '\x87', }, {'\xed', '\x88', '\x89', }, {'\xed', '\x88', '\x90', }, {'\xed', '\x88', '\xac', }, {'\xed', '\x88', '\xad', }, {'\xed', '\x88', '\xb0', }, {'\xed', '\x88', '\xb4', }, {'\xed', '\x88', '\xbc', }, {'\xed', '\x88', '\xbd', }, {'\xed', '\x88', '\xbf', }, {'\xed', '\x89', '\x81', }, {'\xed', '\x89', '\x88', }, {'\xed', '\x89', '\x9c', }, {'\xed', '\x89', '\xa4', }, {'\xed', '\x8a', '\x80', }, {'\xed', '\x8a', '\x81', }, {'\xed', '\x8a', '\x84', }, {'\xed', '\x8a', '\x88', }, {'\xed', '\x8a', '\x90', }, {'\xed', '\x8a', '\x91', }, {'\xed', '\x8a', '\x95', }, {'\xed', '\x8a', '\x9c', }, {'\xed', '\x8a', '\xa0', }, {'\xed', '\x8a', '\xa4', }, {'\xed', '\x8a', '\xac', }, {'\xed', '\x8a', '\xb1', }, {'\xed', '\x8a', '\xb8', }, {'\xed', '\x8a', '\xb9', }, {'\xed', '\x8a', '\xbc', }, {'\xed', '\x8a', '\xbf', }, {'\xed', '\x8b', '\x80', }, {'\xed', '\x8b', '\x82', }, {'\xed', '\x8b', '\x88', }, {'\xed', '\x8b', '\x89', }, {'\xed', '\x8b', '\x8b', }, {'\xed', '\x8b', '\x94', }, {'\xed', '\x8b', '\x98', }, {'\xed', '\x8b', '\x9c', }, {'\xed', '\x8b', '\xa4', }, {'\xed', '\x8b', '\xa5', }, {'\xed', '\x8b', '\xb0', }, {'\xed', '\x8b', '\xb1', }, {'\xed', '\x8b', '\xb4', }, {'\xed', '\x8b', '\xb8', }, {'\xed', '\x8c', '\x80', }, {'\xed', '\x8c', '\x81', }, {'\xed', '\x8c', '\x83', }, {'\xed', '\x8c', '\x85', }, {'\xed', '\x8c', '\x8c', }, {'\xed', '\x8c', '\x8d', }, {'\xed', '\x8c', '\x8e', }, {'\xed', '\x8c', '\x90', }, {'\xed', '\x8c', '\x94', }, {'\xed', '\x8c', '\x96', }, {'\xed', '\x8c', '\x9c', }, {'\xed', '\x8c', '\x9d', }, {'\xed', '\x8c', '\x9f', }, {'\xed', '\x8c', '\xa0', }, {'\xed', '\x8c', '\xa1', }, {'\xed', '\x8c', '\xa5', }, {'\xed', '\x8c', '\xa8', }, {'\xed', '\x8c', '\xa9', }, {'\xed', '\x8c', '\xac', }, {'\xed', '\x8c', '\xb0', }, {'\xed', '\x8c', '\xb8', }, {'\xed', '\x8c', '\xb9', }, {'\xed', '\x8c', '\xbb', }, {'\xed', '\x8c', '\xbc', }, {'\xed', '\x8c', '\xbd', }, {'\xed', '\x8d', '\x84', }, {'\xed', '\x8d', '\x85', }, {'\xed', '\x8d', '\xbc', }, {'\xed', '\x8d', '\xbd', }, {'\xed', '\x8e', '\x80', }, {'\xed', '\x8e', '\x84', }, {'\xed', '\x8e', '\x8c', }, {'\xed', '\x8e', '\x8d', }, {'\xed', '\x8e', '\x8f', }, {'\xed', '\x8e', '\x90', }, {'\xed', '\x8e', '\x91', }, {'\xed', '\x8e', '\x98', }, {'\xed', '\x8e', '\x99', }, {'\xed', '\x8e', '\x9c', }, {'\xed', '\x8e', '\xa0', }, {'\xed', '\x8e', '\xa8', }, {'\xed', '\x8e', '\xa9', }, {'\xed', '\x8e', '\xab', }, {'\xed', '\x8e', '\xad', }, {'\xed', '\x8e', '\xb4', }, {'\xed', '\x8e', '\xb8', }, {'\xed', '\x8e', '\xbc', }, {'\xed', '\x8f', '\x84', }, {'\xed', '\x8f', '\x85', }, {'\xed', '\x8f', '\x88', }, {'\xed', '\x8f', '\x89', }, {'\xed', '\x8f', '\x90', }, {'\xed', '\x8f', '\x98', }, {'\xed', '\x8f', '\xa1', }, {'\xed', '\x8f', '\xa3', }, {'\xed', '\x8f', '\xac', }, {'\xed', '\x8f', '\xad', }, {'\xed', '\x8f', '\xb0', }, {'\xed', '\x8f', '\xb4', }, {'\xed', '\x8f', '\xbc', }, {'\xed', '\x8f', '\xbd', }, {'\xed', '\x8f', '\xbf', }, {'\xed', '\x90', '\x81', }, {'\xed', '\x90', '\x88', }, {'\xed', '\x90', '\x9d', }, {'\xed', '\x91', '\x80', }, {'\xed', '\x91', '\x84', }, {'\xed', '\x91', '\x9c', }, {'\xed', '\x91', '\xa0', }, {'\xed', '\x91', '\xa4', }, {'\xed', '\x91', '\xad', }, {'\xed', '\x91', '\xaf', }, {'\xed', '\x91', '\xb8', }, {'\xed', '\x91', '\xb9', }, {'\xed', '\x91', '\xbc', }, {'\xed', '\x91', '\xbf', }, {'\xed', '\x92', '\x80', }, {'\xed', '\x92', '\x82', }, {'\xed', '\x92', '\x88', }, {'\xed', '\x92', '\x89', }, {'\xed', '\x92', '\x8b', }, {'\xed', '\x92', '\x8d', }, {'\xed', '\x92', '\x94', }, {'\xed', '\x92', '\xa9', }, {'\xed', '\x93', '\x8c', }, {'\xed', '\x93', '\x90', }, {'\xed', '\x93', '\x94', }, {'\xed', '\x93', '\x9c', }, {'\xed', '\x93', '\x9f', }, {'\xed', '\x93', '\xa8', }, {'\xed', '\x93', '\xac', }, {'\xed', '\x93', '\xb0', }, {'\xed', '\x93', '\xb8', }, {'\xed', '\x93', '\xbb', }, {'\xed', '\x93', '\xbd', }, {'\xed', '\x94', '\x84', }, {'\xed', '\x94', '\x88', }, {'\xed', '\x94', '\x8c', }, {'\xed', '\x94', '\x94', }, {'\xed', '\x94', '\x95', }, {'\xed', '\x94', '\x97', }, {'\xed', '\x94', '\xbc', }, {'\xed', '\x94', '\xbd', }, {'\xed', '\x95', '\x80', }, {'\xed', '\x95', '\x84', }, {'\xed', '\x95', '\x8c', }, {'\xed', '\x95', '\x8d', }, {'\xed', '\x95', '\x8f', }, {'\xed', '\x95', '\x91', }, {'\xed', '\x95', '\x98', }, {'\xed', '\x95', '\x99', }, {'\xed', '\x95', '\x9c', }, {'\xed', '\x95', '\xa0', }, {'\xed', '\x95', '\xa5', }, {'\xed', '\x95', '\xa8', }, {'\xed', '\x95', '\xa9', }, {'\xed', '\x95', '\xab', }, {'\xed', '\x95', '\xad', }, {'\xed', '\x95', '\xb4', }, {'\xed', '\x95', '\xb5', }, {'\xed', '\x95', '\xb8', }, {'\xed', '\x95', '\xbc', }, {'\xed', '\x96', '\x84', }, {'\xed', '\x96', '\x85', }, {'\xed', '\x96', '\x87', }, {'\xed', '\x96', '\x88', }, {'\xed', '\x96', '\x89', }, {'\xed', '\x96', '\x90', }, {'\xed', '\x96', '\xa5', }, {'\xed', '\x97', '\x88', }, {'\xed', '\x97', '\x89', }, {'\xed', '\x97', '\x8c', }, {'\xed', '\x97', '\x90', }, {'\xed', '\x97', '\x92', }, {'\xed', '\x97', '\x98', }, {'\xed', '\x97', '\x99', }, {'\xed', '\x97', '\x9b', }, {'\xed', '\x97', '\x9d', }, {'\xed', '\x97', '\xa4', }, {'\xed', '\x97', '\xa5', }, {'\xed', '\x97', '\xa8', }, {'\xed', '\x97', '\xac', }, {'\xed', '\x97', '\xb4', }, {'\xed', '\x97', '\xb5', }, {'\xed', '\x97', '\xb7', }, {'\xed', '\x97', '\xb9', }, {'\xed', '\x98', '\x80', }, {'\xed', '\x98', '\x81', }, {'\xed', '\x98', '\x84', }, {'\xed', '\x98', '\x88', }, {'\xed', '\x98', '\x90', }, {'\xed', '\x98', '\x91', }, {'\xed', '\x98', '\x93', }, {'\xed', '\x98', '\x94', }, {'\xed', '\x98', '\x95', }, {'\xed', '\x98', '\x9c', }, {'\xed', '\x98', '\xa0', }, {'\xed', '\x98', '\xa4', }, {'\xed', '\x98', '\xad', }, {'\xed', '\x98', '\xb8', }, {'\xed', '\x98', '\xb9', }, {'\xed', '\x98', '\xbc', }, {'\xed', '\x99', '\x80', }, {'\xed', '\x99', '\x85', }, {'\xed', '\x99', '\x88', }, {'\xed', '\x99', '\x89', }, {'\xed', '\x99', '\x8b', }, {'\xed', '\x99', '\x8d', }, {'\xed', '\x99', '\x91', }, {'\xed', '\x99', '\x94', }, {'\xed', '\x99', '\x95', }, {'\xed', '\x99', '\x98', }, {'\xed', '\x99', '\x9c', }, {'\xed', '\x99', '\xa7', }, {'\xed', '\x99', '\xa9', }, {'\xed', '\x99', '\xb0', }, {'\xed', '\x99', '\xb1', }, {'\xed', '\x99', '\xb4', }, {'\xed', '\x9a', '\x83', }, {'\xed', '\x9a', '\x85', }, {'\xed', '\x9a', '\x8c', }, {'\xed', '\x9a', '\x8d', }, {'\xed', '\x9a', '\x90', }, {'\xed', '\x9a', '\x94', }, {'\xed', '\x9a', '\x9d', }, {'\xed', '\x9a', '\x9f', }, {'\xed', '\x9a', '\xa1', }, {'\xed', '\x9a', '\xa8', }, {'\xed', '\x9a', '\xac', }, {'\xed', '\x9a', '\xb0', }, {'\xed', '\x9a', '\xb9', }, {'\xed', '\x9a', '\xbb', }, {'\xed', '\x9b', '\x84', }, {'\xed', '\x9b', '\x85', }, {'\xed', '\x9b', '\x88', }, {'\xed', '\x9b', '\x8c', }, {'\xed', '\x9b', '\x91', }, {'\xed', '\x9b', '\x94', }, {'\xed', '\x9b', '\x97', }, {'\xed', '\x9b', '\x99', }, {'\xed', '\x9b', '\xa0', }, {'\xed', '\x9b', '\xa4', }, {'\xed', '\x9b', '\xa8', }, {'\xed', '\x9b', '\xb0', }, {'\xed', '\x9b', '\xb5', }, {'\xed', '\x9b', '\xbc', }, {'\xed', '\x9b', '\xbd', }, {'\xed', '\x9c', '\x80', }, {'\xed', '\x9c', '\x84', }, {'\xed', '\x9c', '\x91', }, {'\xed', '\x9c', '\x98', }, {'\xed', '\x9c', '\x99', }, {'\xed', '\x9c', '\x9c', }, {'\xed', '\x9c', '\xa0', }, {'\xed', '\x9c', '\xa8', }, {'\xed', '\x9c', '\xa9', }, {'\xed', '\x9c', '\xab', }, {'\xed', '\x9c', '\xad', }, {'\xed', '\x9c', '\xb4', }, {'\xed', '\x9c', '\xb5', }, {'\xed', '\x9c', '\xb8', }, {'\xed', '\x9c', '\xbc', }, {'\xed', '\x9d', '\x84', }, {'\xed', '\x9d', '\x87', }, {'\xed', '\x9d', '\x89', }, {'\xed', '\x9d', '\x90', }, {'\xed', '\x9d', '\x91', }, {'\xed', '\x9d', '\x94', }, {'\xed', '\x9d', '\x96', }, {'\xed', '\x9d', '\x97', }, {'\xed', '\x9d', '\x98', }, {'\xed', '\x9d', '\x99', }, {'\xed', '\x9d', '\xa0', }, {'\xed', '\x9d', '\xa1', }, {'\xed', '\x9d', '\xa3', }, {'\xed', '\x9d', '\xa5', }, {'\xed', '\x9d', '\xa9', }, {'\xed', '\x9d', '\xac', }, {'\xed', '\x9d', '\xb0', }, {'\xed', '\x9d', '\xb4', }, {'\xed', '\x9d', '\xbc', }, {'\xed', '\x9d', '\xbd', }, {'\xed', '\x9e', '\x81', }, {'\xed', '\x9e', '\x88', }, {'\xed', '\x9e', '\x89', }, {'\xed', '\x9e', '\x8c', }, {'\xed', '\x9e', '\x90', }, {'\xed', '\x9e', '\x98', }, {'\xed', '\x9e', '\x99', }, {'\xed', '\x9e', '\x9b', }, {'\xed', '\x9e', '\x9d', }, {'\x2e', NULL, NULL, }, {'\x2c', NULL, NULL, }, {'\x20', NULL, NULL, }, {'\x3a', NULL, NULL, }, {'\x30', NULL, NULL, }, {'\x31', NULL, NULL, }, {'\x32', NULL, NULL, }, {'\x33', NULL, NULL, }, {'\x34', NULL, NULL, }, {'\x35', NULL, NULL, }, {'\x36', NULL, NULL, }, {'\x37', NULL, NULL, }, {'\x38', NULL, NULL, }, {'\x39', NULL, NULL, }, {'\x2d', NULL, NULL, }, {'\x5b', NULL, NULL, }, {'\x5d', NULL, NULL, }, {'\x3c', NULL, NULL, }, {'\x3e', NULL, NULL, }, {'\x7b', NULL, NULL, }, {'\x7d', NULL, NULL, }, {'\x28', NULL, NULL, }, {'\x29', NULL, NULL, }, {'\x3b', NULL, NULL, }, {'\x22', NULL, NULL, }, {'\x61', NULL, NULL, }, {'\x62', NULL, NULL, }, {'\x63', NULL, NULL, }, {'\x64', NULL, NULL, }, {'\x65', NULL, NULL, }, {'\x66', NULL, NULL, }, {'\x67', NULL, NULL, }, {'\x68', NULL, NULL, }, {'\x69', NULL, NULL, }, {'\x6a', NULL, NULL, }, {'\x6b', NULL, NULL, }, {'\x6c', NULL, NULL, }, {'\x6d', NULL, NULL, }, {'\x6e', NULL, NULL, }, {'\x6f', NULL, NULL, }, {'\x70', NULL, NULL, }, {'\x71', NULL, NULL, }, {'\x72', NULL, NULL, }, {'\x73', NULL, NULL, }, {'\x74', NULL, NULL, }, {'\x75', NULL, NULL, }, {'\x76', NULL, NULL, }, {'\x77', NULL, NULL, }, {'\x78', NULL, NULL, }, {'\x79', NULL, NULL, }, {'\x7a', NULL, NULL, }, {'\x41', NULL, NULL, }, {'\x42', NULL, NULL, }, {'\x43', NULL, NULL, }, {'\x44', NULL, NULL, }, {'\x45', NULL, NULL, }, {'\x46', NULL, NULL, }, {'\x47', NULL, NULL, }, {'\x48', NULL, NULL, }, {'\x49', NULL, NULL, }, {'\x4a', NULL, NULL, }, {'\x4b', NULL, NULL, }, {'\x4c', NULL, NULL, }, {'\x4d', NULL, NULL, }, {'\x4e', NULL, NULL, }, {'\x4f', NULL, NULL, }, {'\x50', NULL, NULL, }, {'\x51', NULL, NULL, }, {'\x52', NULL, NULL, }, {'\x53', NULL, NULL, }, {'\x54', NULL, NULL, }, {'\x55', NULL, NULL, }, {'\x56', NULL, NULL, }, {'\x57', NULL, NULL, }, {'\x58', NULL, NULL, }, {'\x59', NULL, NULL, }, {'\x5a', NULL, NULL, }, 
};

const EncodedDatum::__3_char EncodedDatum::jPlain_[256] = {
    // ア ~ ポ ャ ュ ョ
    // あ ~ ぽ ゃ ゅ ょ
    // 。 : 、- " "
    // 確 認 削 除 終 再 起 動 検 出
    // 0 ~ 9
    // a~z
    // A~Z
    {'\xe3', '\x81', '\x82', }, {'\xe3', '\x81', '\x84', }, {'\xe3', '\x81', '\x86', }, {'\xe3', '\x81', '\x88', }, {'\xe3', '\x81', '\x8a', }, {'\xe3', '\x81', '\x8b', }, {'\xe3', '\x81', '\x8d', }, {'\xe3', '\x81', '\x8f', }, {'\xe3', '\x81', '\x91', }, {'\xe3', '\x81', '\x93', }, {'\xe3', '\x82', '\x83', }, {'\xe3', '\x82', '\x85', }, {'\xe3', '\x82', '\x87', }, {'\xe3', '\x81', '\x95', }, {'\xe3', '\x81', '\x97', }, {'\xe3', '\x81', '\x99', }, {'\xe3', '\x81', '\x9b', }, {'\xe3', '\x81', '\x9d', }, {'\xe3', '\x81', '\x9f', }, {'\xe3', '\x81', '\xa1', }, {'\xe3', '\x81', '\xa4', }, {'\xe3', '\x81', '\xa6', }, {'\xe3', '\x81', '\xa8', }, {'\xe3', '\x81', '\xaa', }, {'\xe3', '\x81', '\xab', }, {'\xe3', '\x81', '\xac', }, {'\xe3', '\x81', '\xad', }, {'\xe3', '\x81', '\xae', }, {'\xe3', '\x81', '\xaf', }, {'\xe3', '\x81', '\xb2', }, {'\xe3', '\x81', '\xb5', }, {'\xe3', '\x81', '\xb8', }, {'\xe3', '\x81', '\xbb', }, {'\xe3', '\x81', '\xbe', }, {'\xe3', '\x81', '\xbf', }, {'\xe3', '\x82', '\x80', }, {'\xe3', '\x82', '\x81', }, {'\xe3', '\x82', '\x82', }, {'\xe3', '\x82', '\x84', }, {'\xe3', '\x82', '\x86', }, {'\xe3', '\x82', '\x88', }, {'\xe3', '\x82', '\x89', }, {'\xe3', '\x82', '\x8a', }, {'\xe3', '\x82', '\x8b', }, {'\xe3', '\x82', '\x8c', }, {'\xe3', '\x82', '\x8d', }, {'\xe3', '\x82', '\x8f', }, {'\xe3', '\x82', '\x92', }, {'\xe3', '\x82', '\x93', }, {'\xe3', '\x81', '\x8c', }, {'\xe3', '\x81', '\x8e', }, {'\xe3', '\x81', '\x90', }, {'\xe3', '\x81', '\x92', }, {'\xe3', '\x81', '\x94', }, {'\xe3', '\x81', '\x96', }, {'\xe3', '\x81', '\x98', }, {'\xe3', '\x81', '\x9a', }, {'\xe3', '\x81', '\x9c', }, {'\xe3', '\x81', '\x9e', }, {'\xe3', '\x81', '\xa0', }, {'\xe3', '\x81', '\xa2', }, {'\xe3', '\x81', '\xa5', }, {'\xe3', '\x81', '\xa7', }, {'\xe3', '\x81', '\xa9', }, {'\xe3', '\x81', '\xb0', }, {'\xe3', '\x81', '\xb3', }, {'\xe3', '\x81', '\xb6', }, {'\xe3', '\x81', '\xb9', }, {'\xe3', '\x81', '\xbc', }, {'\xe3', '\x81', '\xb1', }, {'\xe3', '\x81', '\xb4', }, {'\xe3', '\x81', '\xb7', }, {'\xe3', '\x81', '\xba', }, {'\xe3', '\x81', '\xbd', }, {'\xe3', '\x82', '\xa2', }, {'\xe3', '\x82', '\xa4', }, {'\xe3', '\x82', '\xa6', }, {'\xe3', '\x82', '\xa8', }, {'\xe3', '\x82', '\xaa', }, {'\xe3', '\x82', '\xab', }, {'\xe3', '\x82', '\xad', }, {'\xe3', '\x82', '\xaf', }, {'\xe3', '\x82', '\xb1', }, {'\xe3', '\x82', '\xb3', }, {'\xe3', '\x82', '\xb5', }, {'\xe3', '\x82', '\xb7', }, {'\xe3', '\x82', '\xb9', }, {'\xe3', '\x82', '\xbb', }, {'\xe3', '\x82', '\xbd', }, {'\xe3', '\x82', '\xbf', }, {'\xe3', '\x83', '\x81', }, {'\xe3', '\x83', '\x84', }, {'\xe3', '\x83', '\x86', }, {'\xe3', '\x83', '\x88', }, {'\xe3', '\x83', '\x8a', }, {'\xe3', '\x83', '\x8b', }, {'\xe3', '\x83', '\x8c', }, {'\xe3', '\x83', '\x8d', }, {'\xe3', '\x83', '\x8e', }, {'\xe3', '\x83', '\xa3', }, {'\xe3', '\x83', '\xa7', }, {'\xe3', '\x83', '\x8f', }, {'\xe3', '\x83', '\x92', }, {'\xe3', '\x83', '\x95', }, {'\xe3', '\x83', '\x98', }, {'\xe3', '\x83', '\x9b', }, {'\xe3', '\x83', '\x9e', }, {'\xe3', '\x83', '\x9f', }, {'\xe3', '\x83', '\xa0', }, {'\xe3', '\x83', '\xa1', }, {'\xe3', '\x83', '\xa2', }, {'\xe3', '\x83', '\xa4', }, {'\xe3', '\x83', '\xa6', }, {'\xe3', '\x83', '\xa8', }, {'\xe3', '\x83', '\xa9', }, {'\xe3', '\x83', '\xaa', }, {'\xe3', '\x83', '\xab', }, {'\xe3', '\x83', '\xac', }, {'\xe3', '\x83', '\xad', }, {'\xe3', '\x83', '\xaf', }, {'\xe3', '\x83', '\xb2', }, {'\xe3', '\x83', '\xb3', }, {'\xe3', '\x82', '\xac', }, {'\xe3', '\x82', '\xae', }, {'\xe3', '\x82', '\xb0', }, {'\xe3', '\x82', '\xb2', }, {'\xe3', '\x82', '\xb4', }, {'\xe3', '\x82', '\xb6', }, {'\xe3', '\x82', '\xb8', }, {'\xe3', '\x82', '\xba', }, {'\xe3', '\x82', '\xbc', }, {'\xe3', '\x82', '\xbe', }, {'\xe3', '\x83', '\x80', }, {'\xe3', '\x83', '\x82', }, {'\xe3', '\x83', '\x85', }, {'\xe3', '\x83', '\x87', }, {'\xe3', '\x83', '\x89', }, {'\xe3', '\x83', '\x90', }, {'\xe3', '\x83', '\x93', }, {'\xe3', '\x83', '\x96', }, {'\xe3', '\x83', '\x99', }, {'\xe3', '\x83', '\x9c', }, {'\xe3', '\x83', '\x91', }, {'\xe3', '\x83', '\x94', }, {'\xe3', '\x83', '\x97', }, {'\xe3', '\x83', '\x9a', }, {'\xe3', '\x83', '\xa5', }, {'\xe3', '\x82', '\xa3', }, {'\x5b', NULL, NULL }, {'\x5d', NULL, NULL }, {'\xe3', '\x80', '\x82', }, {'\x3a', NULL, NULL }, {'\xe3', '\x80', '\x81', }, {'\xe3', '\x83', '\xbc', }, {'\x20', NULL, NULL }, {'\xe3', '\x83', '\x9d', }, {'\xe7', '\xa2', '\xba', }, {'\xe8', '\xaa', '\x8d', }, {'\xe5', '\x89', '\x8a', }, {'\xe9', '\x99', '\xa4', }, {'\xe7', '\xb5', '\x82', }, {'\xe5', '\x86', '\x8d', }, {'\xe8', '\xb5', '\xb7', }, {'\xe5', '\x8b', '\x95', }, {'\xe6', '\xa4', '\x9c', }, {'\xe5', '\x87', '\xba', }, {'\xe4', '\xba', '\x86', }, {'\x30', NULL, NULL }, {'\x31', NULL, NULL }, {'\x32', NULL, NULL }, {'\x33', NULL, NULL }, {'\x34', NULL, NULL }, {'\x35', NULL, NULL }, {'\x36', NULL, NULL }, {'\x37', NULL, NULL }, {'\x38', NULL, NULL }, {'\x39', NULL, NULL }, {'\x61', NULL, NULL }, {'\x62', NULL, NULL }, {'\x63', NULL, NULL }, {'\x64', NULL, NULL }, {'\x65', NULL, NULL }, {'\x66', NULL, NULL }, {'\x67', NULL, NULL }, {'\x68', NULL, NULL }, {'\x69', NULL, NULL }, {'\x6a', NULL, NULL }, {'\x6b', NULL, NULL }, {'\x6c', NULL, NULL }, {'\x6d', NULL, NULL }, {'\x6e', NULL, NULL }, {'\x6f', NULL, NULL }, {'\x70', NULL, NULL }, {'\x71', NULL, NULL }, {'\x72', NULL, NULL }, {'\x73', NULL, NULL }, {'\x74', NULL, NULL }, {'\x75', NULL, NULL }, {'\x76', NULL, NULL }, {'\x77', NULL, NULL }, {'\x78', NULL, NULL }, {'\x79', NULL, NULL }, {'\x7a', NULL, NULL }, {'\x41', NULL, NULL }, {'\x42', NULL, NULL }, {'\x43', NULL, NULL }, {'\x44', NULL, NULL }, {'\x45', NULL, NULL }, {'\x46', NULL, NULL }, {'\x47', NULL, NULL }, {'\x48', NULL, NULL }, {'\x49', NULL, NULL }, {'\x4a', NULL, NULL }, {'\x4b', NULL, NULL }, {'\x4c', NULL, NULL }, {'\x4d', NULL, NULL }, {'\x4e', NULL, NULL }, {'\x4f', NULL, NULL }, {'\x50', NULL, NULL }, {'\x51', NULL, NULL }, {'\x52', NULL, NULL }, {'\x53', NULL, NULL }, {'\x54', NULL, NULL }, {'\x55', NULL, NULL }, {'\x56', NULL, NULL }, {'\x57', NULL, NULL }, {'\x58', NULL, NULL }, {'\x59', NULL, NULL }, {'\x5a', NULL, NULL }, {'\xe6', '\x94', '\xb9', }, {'\xe3', '\x83', '\x83', }, {'\xe8', '\x84', '\xb1', }, {'\xe7', '\x8d', '\x84', }, {'\xe4', '\xbd', '\x8d', }, {'\xe7', '\xbd', '\xae', }, {'\xe6', '\x93', '\x8d', }, {'\xe4', '\xbd', '\x9c', },
        {'\xe7', '\x94', '\xbb'}, // 画 화
       {'\xe9', '\x9d', '\xa2'}, // 面 면
       {'\xe9', '\x8c', '\xb2'}, // 録 녹
};
