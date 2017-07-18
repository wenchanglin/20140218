//
//  Preview.m
//  PlayerDemo
//
//  Created by Netsdk on 15/4/22.
//
//

#import <Foundation/Foundation.h>
#import "Preview.h"
#import "hcnetsdk.h"
#import "IOSPlayM4.h"

typedef struct tagHANDLE_STRUCT
{
    int iPreviewID;
    int iPlayPort;
    UIView *pView;
    tagHANDLE_STRUCT()
    {
        iPreviewID = -1;
        iPlayPort = -1;
        pView = NULL;
    }
}HANDLE_STRUCT,*LPHANDLE_STRUCT;

HANDLE_STRUCT g_struHandle;
// preview callback function
void fRealDataCallBack_V30(LONG lRealHandle, DWORD dwDataType, BYTE *pBuffer, DWORD dwBufSize, void* pUser)
{
    LPHANDLE_STRUCT pHandle = (LPHANDLE_STRUCT)pUser;
    switch (dwDataType)
    {
        case NET_DVR_SYSHEAD:
            if(pHandle->iPlayPort != -1)
            {
                break;
            }
            if(!PlayM4_GetPort(&pHandle->iPlayPort))
            {
                break;
            }
            if (dwBufSize > 0 )
            {
                if (!PlayM4_SetStreamOpenMode(pHandle->iPlayPort, STREAME_REALTIME))
                {
                    break;
                }
                if (!PlayM4_OpenStream(pHandle->iPlayPort, pBuffer , dwBufSize, 2*1024*1024))
                {
                    break;
                }
                DDLogDebug(@"lRealHanle:%d",lRealHandle);
                dispatch_async(dispatch_get_main_queue(), ^{
                    int iRet = PlayM4_Play(pHandle->iPlayPort,(__bridge void *) pHandle->pView);
                    if (iRet== 1)
                    {
                        BOOL b=PlayM4_RenderPrivateData(pHandle->iPlayPort, PLAYM4_RENDER_MD, false);
                        if(b==0){
                            DDLogError(@"去除失败");
                            int error=NET_DVR_GetLastError();
                            char *msg=NET_DVR_GetErrorMsg();
                            printf("error:%d,msg:%s",error,msg);
                        }

                    }
                    
                });
            }
            break;
        default:
            if (dwBufSize > 0 && pHandle->iPlayPort != -1)
            {
                if(!PlayM4_InputData(pHandle->iPlayPort, pBuffer, dwBufSize))
                {
                    break;
                }
            }
            break;
    }
}


int startPreview(int iUserID, int iStartChan, UIView *pView, int iIndex)
{
    // request stream
    NET_DVR_PREVIEWINFO struPreviewInfo = {0};
    struPreviewInfo.lChannel = iStartChan + iIndex;
    struPreviewInfo.dwStreamType = 1;
    struPreviewInfo.bBlocked = 1;
    g_struHandle.pView = pView;

    g_struHandle.iPreviewID = NET_DVR_RealPlay_V40(iUserID, &struPreviewInfo, fRealDataCallBack_V30, &g_struHandle);
    if (g_struHandle.iPreviewID == -1)
    {
        DDLogError(@"NET_DVR_RealPlay_V40 failed:%d",NET_DVR_GetLastError());
       char *msg= NET_DVR_GetErrorMsg();
        if (msg!=NULL) {
            NSString *msgStr=[NSString stringWithUTF8String:msg];
            DDLogError(@"msg:%@",msgStr);
        }
        return -1;
    }
    DDLogError(@"NET_DVR_RealPlay_V40 succ");
    
    return g_struHandle.iPreviewID;
}

void stopPreview(int iIndex)
{
    dispatch_async_main_safe(^{
        NET_DVR_StopRealPlay(g_struHandle.iPreviewID);
        PlayM4_StopSound();
        
        int iPlayPort=g_struHandle.iPlayPort;
        if (!PlayM4_Stop(iPlayPort))
        {
            DDLogError(@"PlayM4_Stop failed");
        }
        if(!PlayM4_CloseStream(iPlayPort))
        {
            DDLogError(@"PlayM4_CloseStream failed");
        }
        if (!PlayM4_FreePort(iPlayPort))
        {
            DDLogError(@"PlayM4_FreePort failed");
        }
        g_struHandle.iPlayPort=-1;
    });
    

}
