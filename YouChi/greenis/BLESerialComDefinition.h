//
//  BLESerialComDefinition.h
//  BLESerialComManager
//
//  Created by 王 维 on 3/10/13.
//  Copyright (c) 2013 王 维. All rights reserved.
//

#ifndef BLESerialComManager_BLESerialComDefinition_h
#define BLESerialComManager_BLESerialComDefinition_h

typedef enum _result_code{
    RESULT_SUCCESS                      = 0,
    
    RESULT_ERROR_BASE                   = 1,
    RESULT_ERROR_PORT_INVALID           = RESULT_ERROR_BASE + 1,
    RESULT_ERROR_STATE_WRONG            = RESULT_ERROR_BASE + 2,
    RESULT_ERROR_NULL_ADDRESS           = RESULT_ERROR_BASE + 3,
    RESULT_ERROR_DISCOVER_TIMEOUT       = RESULT_ERROR_BASE + 4,
    
    RESULT_CODE_TYPE_END
}resultCodeType;

typedef enum _central_state{
    
    CENTRAL_STATE_UNKNOWN,
    CENTRAL_STATE_RESETTING,
    CENTRAL_STATE_UNSUPPORTED,
    CENTRAL_STATE_UNAUTHORIZED,
    CENTRAL_STATE_POWEREDOFF,
    CENTRAL_STATE_POWEREDON,
    
    CENTRAL_STATE_END
    
}centralStateType;


/*paramsPackage4Configure*/
typedef struct _configure_params{
    //unsigned char address[6];
    unsigned int  lengthOfPackage;//接收到的包长度，作为通知上层的依据
}paramsPackage4Configure;


/*paramsPackage4Open*/
typedef struct _open_params{
    
}paramsPackage4Open;

/*paramsPackage4Write*/
typedef struct _write_params{

}paramsPackage4Write;

/*paramsPackage4Read*/
typedef struct _read_params{

}paramsPackage4Read;

/*paramsPackage4Close*/
typedef struct _close_params{
    
}paramsPackage4Close;




#endif
