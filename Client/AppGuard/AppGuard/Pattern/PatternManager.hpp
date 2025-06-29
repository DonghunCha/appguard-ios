//
//  PatternManager.hpp
//  appguard-ios
//
//  Created by NHNENT on 2016. 5. 11..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef PatternManager_hpp
#define PatternManager_hpp

#include <stdio.h>
#include "AGCommon.hpp"
#include "FilePattern.h"
#include "ProcPattern.h"
#include "AGResourceIntegrityPattern.hpp"
#include "AGLocationSpoofPattern.hpp"
#include "EncodedDatum.h"
#include "ASString.h"
#include "AppGuardChecker.hpp"
#include "SimulatorManager.hpp"
#include "EnvironmentManager.hpp"
#include "Singleton.hpp"
#include "Log.h"
#include "Util.h"


class AG_PRIVATE_API PatternManager
{
public:
    PatternManager();
    ~PatternManager();
    
    void initPatterns();
    void releasePatterns();
    
    std::vector<FilePattern*>& getFilePatterns();
    std::vector<ProcPattern*>& getProcPatterns();
    std::vector<AGLocationSpoofPattern*>& getLocationSpoofPatterns();
    std::vector<AGResourceIntegrityPattern*>& getResourceIntegrityPatterns();
    std::vector<Pattern*>& getScreenCapturePatterns();
    std::vector<Pattern*>& getScreenRecordPatterns();
    std::vector<Pattern*>& getVPNDetectionPatterns();
    std::vector<Pattern*>& getMacroToolPatterns();
    void setVersion(std::string version);
    std::string getVersion();
    void setResponse(AGResponseType jailbreak,
                     AGResponseType cheating,
                     AGResponseType debugger,
                     AGResponseType modification,
                     AGResponseType simulator,
                     AGResponseType hook,
                     AGResponseType network,
                     AGResponseType location,
                     AGResponseType screenCapture,
                     AGResponseType screenRecord,
                     AGResponseType macroTool,
                     AGResponseType vpnDetection
                     );
    
    void setResponseFilePattern();
    void setResponseProcPattern();
    void setResponseResourceIntegrityPattern();
    void setResponseLocationSpoofPattern();
    void setResponseScreenCapture();
    void setResponseScreenRecord();
    void setResponseVPNDetection();
    void setResponseMacroTool();

    
    AGResponseType getResponseType(int value);
    AGResponseType getResponseTypeOfJailbreak();
    AGResponseType getResponseTypeOfCheating();
    AGResponseType getResponseTypeOfDebugger();
    AGResponseType getResponseTypeOfModification();
    AGResponseType getResponseTypeOfSimulator();
    AGResponseType getResponseTypeOfHook();
    AGResponseType getResponseTypeOfNetwork();
    AGResponseType getResponseTypeOfLocationSpoof();
    AGResponseType getResponseTypeOfScreenCapture();
    AGResponseType getResponseTypeScreenRecord();
    AGResponseType getResponseTypeVPNDetection();
    AGResponseType getResponseTypeMacroTool();
    void offDebug();
    
private:
    AGResponseType jailbreak_     = AGResponseTypeDetect;
    AGResponseType cheating_      = AGResponseTypeDetect;
    AGResponseType debugger_      = AGResponseTypeDetect;
    AGResponseType modification_  = AGResponseTypeDetect;
    AGResponseType simulator_     = AGResponseTypeDetect;
    AGResponseType hook_          = AGResponseTypeDetect;
    AGResponseType network_       = AGResponseTypeDetect;
    AGResponseType locationSpoof_      = AGResponseTypeDetect;
    AGResponseType screenCapture_   = AGResponseTypeDetect;
    AGResponseType screenRecord_    = AGResponseTypeDetect;
    AGResponseType vpnDetection_    = AGResponseTypeDetect;
    AGResponseType macroTool_    = AGResponseTypeDetect;

    bool debugOn = true;
    
 
    void setResponseType(AGResponseType jailbreak,
                         AGResponseType cheating,
                         AGResponseType debugger,
                         AGResponseType modification,
                         AGResponseType simulator,
                         AGResponseType hook,
                         AGResponseType network,
                         AGResponseType location,
                         AGResponseType screenCapture,
                         AGResponseType screenRecord,
                         AGResponseType macroTool,
                         AGResponseType vpnDetection
                         );

    void setResponseTypeOfJailbreak(AGResponseType type);
    void setResponseTypeOfCheating(AGResponseType type);
    void setResponseTypeOfDebugger(AGResponseType type);
    void setResponseTypeOfModification(AGResponseType type);
    void setResponseTypeOfSimulator(AGResponseType type);
    void setResponseTypeOfHook(AGResponseType type);
    void setResponseTypeOfNetwork(AGResponseType type);
    void setResponseTypeOfLocationSpoof(AGResponseType type);
    void setResponseTypeOfScreenCapture(AGResponseType type);
    void setResponseTypeOfScreenRecord(AGResponseType type);
    void setResponseTypeOfVPNDetection(AGResponseType type);
    void setResponseTypeOfMacroTool(AGResponseType type);
    
    std::vector<FilePattern*> filePatterns_;
    std::vector<ProcPattern*> procPatterns_;
    std::vector<AGResourceIntegrityPattern*> resourceIntegrityPattern_;
    std::vector<AGLocationSpoofPattern*> locationSpoofPatterns_;
    std::vector<Pattern*> screenCapturePatterns_;
    std::vector<Pattern*> screenRecordPatterns_;
    std::vector<Pattern*> VPNDetectionPatterns_;
    std::vector<Pattern*> macroToolPatterns_;

    void initFilePatterns();
    void initProcPatterns();
    void initResourceIntegrityPatterns();
    void initLocationSpoofPatterns();
    void initScreenRecordPatterns();
    void initScreenCapturePatterns();
    void initVPNDetectionPatterns();
    void initMacroToolPatterns();

    std::string patternVersion_;
};

#endif /* PatternManager_hpp */
