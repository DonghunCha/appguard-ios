//
//  EncodedDatum.h
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 18..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef EncodedDatum_h
#define EncodedDatum_h

#include <stdio.h>

class __attribute__((visibility("hidden"))) EncodedDatum
{
public:
    enum Encoded
    {
        Cydia_app = 0,                          // /Applications/Cydia.app
        sbin_sshd,                              // /usr/sbin/sshd
        bin_sshd,                               // /usr/bin/sshd
        sftp_server,                            // /usr/libexec/sftp-server
        apt,                                    // /private/var/lib/apt
        cydia_log,                              // /private/var/tmp/cydia.log
        lib_cydia,                              // /private/var/lib/cydia
        stash,                                  // /private/var/stash
        applications,                           // /Applications
        gamehacker,                             // gamehacker
        gameplayerd,                            // GamePlayerd
        flex,                                   // flex
        memsearch,                              // memsearch
        debugger,                               // debugger
        text_integrity,                         // TEXT segment integrity
        sandbox_detected,                       // sandbox detect
        text_segment,                           // __TEXT
        __text,                                 // __text
        dynamic_libraries,                      // /Library/MobileSubstrate/DynamicLibraries
        plist,                                  // .plist
        LSApplicationWorkspace,                 // LSApplicationWorkspace
        defaultWorkspace,                       // defaultWorkspace
        allApplications,                        // allApplications
        detected,                               // detected
        block,                                  // block
        signature_integrity,                    // Signature integrity
        appguardPolicyQueue,                    // com.nhnent.appguardPolicyQueue
        policy_ag,                              // policy.ag
        cdn_address,                            // https://adam.cdn.toastoven.net
        alert_text,                             // This application will shut down according to the security policy.
        alert_code,                             // Code : %d
        alert_title,                            // AppGuard Alert
        alpha_server,                           // https://alpha-api-logncrash.cloud.toast.com
        beta_server,                            // https://beta-api-logncrash.cloud.toast.com
        real_server,                            // https://api-logncrash.cloud.toast.com
        _bin_bash,                              // /bin/bash
        _bin_sh,                                // /bin/sh
        _usr_sbin_sshd,                         // /usr/sbin/sshd
        ssh_keysign,                            // /usr/libexec/ssh-keysign
        sshd_config,                            // /etc/ssh/sshd_config
        MobileSubstrate_dylib_path,             // /Library/MobileSubstrate/MobileSubstrate.dylib
        _var_cache_apt,                         // /var/cache/apt
        _var_lib_apt,                           // /var/lib/apt
        _var_lib_cydia,                         // /var/lib/cydia
        _var_log_syslog,                        // /var/log/syslog
        _var_tmp_cydia_log,                     // /var/tmp/cydia.log
        _etc_apt,                               // /etc/apt
        isatty,                                 // isatty
        cydia_url,                              // cydia://
        temp_ag_file,                           // /private/AG.txt
        content_type,                           // Content-Type
        octet_stream,                           // application/octet-stream
        gamegemios,                             // GameGemiOS
        igameguardian,                          // iGameGuardian
        appguardExitQueue,                      // com.nhnent.appgaurdExitQueue
        cryptid,                                // cryptid
        appgaurdEncryptionQueue,                // com.nhnent.appgaurdEncryptionQueue
        hackValue,                              // 0610
        ptrace,                                 // ptrace
        sc_info,                                // /SC_Info
        _dylib,                                 // .dylib
        com_apple_storekit,                     // com.apple.StoreKit
        substrate_binary_path,                  // /Frameworks/CydiaSubstrate.framework/CydiaSubstrate
        appguardCheckQueue,                     // com.nhn.appguardCheckQueue
        MobileSubstrate_dylib,                  // MobileSubstrate.dylib
        libsubstrate_dylib,                     // libsubstrate.dylib
        TweakInject_dylib,                      // TweakInject.dylib
        SubstrateLoader_dylib,                  // SubstrateLoader.dylib
        CydiaSubstrate,                         // CydiaSubstrate
        Debug_Target,                           // Debug Target
        Debug_Machine_Info,                     // Debug Machine Info
        DYLD_INSERT_LIBRARIES,                  // DYLD_INSERT_LIBRARIES
        uiapplication,                          // UIApplication
        nsstring,                               // NSString
        nsfilemanager,                          // NSFileManager
        appguardPinningQueue,                   // com.nhnent.appguardPinningQueue
        Diresu,                                 // Diresu
        ToastMemoryInformationManager,          // ToastMemoryInformationManager
        AGNController,                          // AGNController
        SSLPinning,                             // SSL Pinning
        https_url,                              // https://agd-policy.nhn.com/monitor/l7check
        default_appkey,                         // H167g8Uttivf8jtH
        RNCryptorLoader,                        // RNCryptorLoader
        s____,                                  // s::::
        b____,                                  // b::::
        free,                                   // free
        initWithOperations____,                 // initWithOperations::::
        cryptor,                                // cryptor
        buffer,                                 // buffer
        addData__,                              // addData::
        removeData__,                           // removeData::
        setResponseQueue_,                      // setResponseQueue:
        randomDataOfLength_,                    // randomDataOfLength:
        initWithHandler_,                       // initWithHandler:
        synchronousResultForCryptor____,        // synchronousResultForCryptor::::
        setQueue_,                              // setQueue:
        error,                                  // error
        finish,                                 // finish
        send,                                   // send
        AppGuard_Test_Version,                  // AppGuard Test Version.
        Free_AppGuard_Abuser,                   // Free AppGuard Abuser
        real_realtime_policy_url,               // https://api-appguard-policy.cloud.toast.com/v1/block
        BLOCK,                                  // BLOCK
        appguardBlockQueue,                     // com.nhnent.appguardBlockQueue
        read,                                   // read
        write,                                  // write
        sendto,                                 // sendto
        sendmsg,                                // sendmsg
        recv,                                   // recv
        recvfrom,                               // recvfrom
        recvmsg,                                // recvmsg
        AQPattern,                              // AQPattern
        _Z12hookingSVC80v,                      // _Z12hookingSVC80v
        ABLicense,                              // /Library/BawAppie/ABypass/ABLicense
        ABypass_dylib,                          // ///././Library//./MobileSubstrate///DynamicLibraries///././/!ABypass2.dylib
        _Z19startAuthenticationv,               // _Z19startAuthenticationv
        _Z13getRealOffsety,                     // _Z13getRealOffsety
        _Z16calculateAddressx,                  // _Z16calculateAddressx
        _MSSafeMode,                            // _MSSafeMode
        substitute,                             // substitute
        AppFirewall_dylib,                      // /Library/MobileSubstrate/DynamicLibraries/AppFirewall.dylib
        kernbypass_plist,                       // /var/mobile/Library/Preferences/jp.akusio.kernbypass.plist
        signer_integrity,                       // signer integrity
        iapCracker_plist,                       // /var/mobile/Library/Preferences/com.laxus.iosgodsiapcracker.plist
        Suspected_IAP_hacking,                  // Suspected IAP hacking
        NHN_JB_TEST,                            // NHN_JB_TEST
        CHECK_PROTECT_ERROR_STRING,             // 0445c80
        CHECK_SIGNER_PROTECT_ERROR_STRING,      // 1235c8
        AdaptiveHome_dylib,                     // /Library/MobileSubstrate/DynamicLibraries/AdaptiveHome.dylib
        UnityFramework,                         // UnityFramework
        UnityHashSignatureCheck,                // b4b1a804
        sleep,                                  // sleep
        usleep,                                 // usleep
        checkSystemAPIHook_detected_in_load,    // checkSystemAPIHook_detected_in_load
        checkAppGuardBinaryPatch1,              // checkAppGuardBinaryPatch1
        checkAppGuardBinaryPatch2,              // checkAppGuardBinaryPatch2
        zDATA,                                  // __zDATA
        zTEXT,                                  // __zTEXT
        CHECK_DYLIB_INJECTION_ERROR,            // 1239948858249
        dylib_injection,                        // dylib injection
        checkValidSvcCallHook_detected_in_load, // checkValidSvcCallHook_detected_in_load
        appguard_plist_dict_key,                // AppGuard
        appguard_plist_env_key,                 // Server
        env_alpha,                              // ALPHA
        env_beta,                               // BETA
        fname_exit, //exit
        Sileo_Nightly_app, // /Applications/Sileo-Nightly.app
        Zebra_app, // /Applications/Zebra.app
        substitute_loader_dylib, // substitute-loader.dylib
        libsubstitute_dylib, // libsubstitute.dylib
        updated_protectlevel_signature_prefix, //c9fa5e18160a5e37afa7df126715488f5df6ba5d4caa3870a6749843f51533ee
        cdn_policy_sub_path,// /ios
        cdn_policy_sub_path_alpha, // /alpha/ios
        cdn_policy_sub_path_beta,  // /beta/ios
        alpha_realtime_policy_url, // http://alpha-agd-policy.nhn.com/v1/block
        beta_realtime_policy_url, // http://beta-agd-policy.nhn.com/v1/block
        callback_json_field_deprecate_log, // RN, PG, RT fields are deprecated.
        updated_infoplist_signature, //dc7a42f36f5aa669d5a8658a322ef37cb3ec3a3f9939b2278ba947bf7a61a3ee
        info_plist, // Info.plist
        unity_interface_patched, //Unity Interface Mem Patched.(d)
        check_text_section_by_check_code, //Check Text section by check Code
        frida_server_bin_path, ///usr/sbin/frida-server
        gum_js_loop_thread_name, //gum-js-loop
        frida_ios_dump, // frida-ios-dump
        f_function_deprecated, // The f function is deprecated. It no longer works.
        plist_key_CFBundleExecutable, //CFBundleExecutable
        plist_key_CFBundleIdentifier, // CFBundleIdentifier
        plist_key_CFBundleVersion, //CFBundleVersion
        plist_key_CFBundleShortVersionString, //CFBundleShortVersionString
        crackerxi_url_scheme_data, // crackerxi://?data=
        igamegod_url_scheme_bfdecrypt_decryptedPath, // gamegodopen:bf?decryptedPath=
        url_scheme_query_key_decryptedPath, //decryptedPath
        url_scheme_query_key_data, //data
        section_name_il2cpp,// il2cpp
        UnityIl2cppSignatureCheck, //d64b7b73
        _var_jb_path, // /var/jb
        _application_sileoapp_path, ///Applications/Sileo.app
        _var_mobile_library_palera1n_helper, // /var/mobile/Library/palera1n/helper
        _cores_binback_application_palera1nloader_app, ///cores/binpack/Applications/palera1nLoader.app
        protector_injected_apikey_signature, // 2a02a552ab75c5de1367b69d135a4fffb121bedd2bd934440560035e83d1d0c7
        status_monitor_detail_msg_exported_function_patched,
        Behavior_pattern, // Behavior
        string_jsbundle, // jsbundle
        string_Flutter, // Flutter
        section_name_const, // __const
        policy_json, //policy.json
        policy_json_key_appkey, //appKey
        policy_json_key_version, //version
        policy_json_key_updatedDateTime, //updatedDateTime
        policy_json_key_uuid, //uuid
        policy_json_key_ruleGroups, //ruleGroups
        policy_json_key_action, //action
        class_name_locationmanager, // CLLocationManager
        plist_key_nslocation_when_in_use_usage_desc, //NSLocationWhenInUseUsageDescription
        plist_key_nslocation_always_usage_desc,//NSLocationAlwaysUsageDescription
        plist_key_nslocation_always_and_when_in_use_usage_desc, // NSLocationAlwaysAndWhenInUseUsageDescription
        string_code_push, //CodePush
        string_vpn_interfaces, //tap/ppp/ipsec0/tun/ipsec/utun
        startup_message_replace_signature, //bcbfce8d5b64aacefe0af8bffe873699a7f2156d28fec6498aad5160c38b5f6d //startup message replace signature
        secured_by_nhn_appguard, // Secured by NHN AppGuard
        detection_alert_mode_replace_signature, // e7a438bd1b7bd0c151ca42ac87ef720294f66677875b87de7e546a2b50c817aa
        debug_dylib,    // .debug.dylib
        string_expo_intenal_path  // /.expo-internal/
    };
    
    struct __3_char{
       char string[3];
    };


    static const char encoded_[][256];
    static const char keys_[][16];
    
    static const char ePlain_[][256];
    static const __3_char kPlain_[3072];
    static const __3_char jPlain_[256];
};

#endif /* EncodedDatum_h */
