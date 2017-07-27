
//
//  InterfaceDefines.h
//  kq_banbo_app
//
//  Created by hcy on 2016/11/28.
//  Copyright © 2016年 yzChina. All rights reserved.
//

#ifndef InterfaceDefines_h
#define InterfaceDefines_h
//接口定义
#define CompanyKey @"COMPANY"
#define ProjectKey @"PROJECT"
#define AppID   @"1188196862"

#define QingQiuTou @"http://mapi.51zhgd.com/"
//#define QingQiuTou @"http://120.26.57.155:8888/kq_banbo_app/"
//#define QingQiuTou @"http://192.168.0.211:8080/kq_banbo_app/"
#define huanjingtou @"http://www.51zhgd.com/"
//#define huanjingtou @"http://120.26.57.155:8888/zhgd_test/"//155测试
//#define huanjingtou @"http://192.168.0.198:8080/zhihuigongdi/"
#define Inter_Login                 @"user/login"   //登录
//home 人数
#define Inter_HomeTotal             @"home/getmaininfo"
//班组、0-30天信息
#define Inter_HomeDetail            @"home/getdetails"
//monitor(二个暂未用)
#define Inter_updateIPChannel       @"monitor/updateipchannel"
#define Inter_getNVRInfo            @"monitor/getnvrinfo"

//获取萤石token
#define Inter_getYSNVRInfo          @"ys/getyingstoken"
//获取萤石设备
#define Inter_getYSSeriaNum         @"ys/getdevicetypes"
//累计报道人数
#define Inter_getRecords            @"register/getrecords"
//新增签到
#define Inter_enableReport          @"register/enableop"
//签到界面录入信息
#define Inter_validUserId           @"register/getlastvaliduserid"
//签到界面保存员工信息
#define Inter_saveReport            @"register/save"
//血压计采集
#define Inter_addBloodPressure      @"register/addBloodPressure"
//心电图采集
#define Inter_addHeartRate          @"register/addHeartRate"

//签到总人数
#define Inter_RealNameUserNum       @"realname/getusernum"
//工地总人数
#define Inter_RealNameSelectUserNum @"realname/getselectedusernum"
//签到员工健康
#define Inter_RealNameProjectHealth @"realname/getHealthInfo"
//查看血压
#define Inter_RealNameGetDetail     @"realname/getDetailHealthInfo"
#define Inter_getHeartRateInfo      @"realname/getHeartRateInfo"
//宿舍管理-获取所有宿舍楼
#define Inter_RequestAllDorm        @"dorm/getDormBuildingInfo"
//宿舍管理-获取每个楼有多少房间
#define Inter_RequestAllRoom        @"dorm/getDormRoomInfo"
//宿舍分配
#define Inter_AssignGroupToRoom     @"dorm/assignGroup"
//common
//上传身份证头像
#define Inter_UploadFile            @"upload/uploadfile"
//下载身份证头像
#define Inter_GetCardPic            @"realname/getIdCardPic"
//检查蓝牙权限
#define Inter_checkBlueTooeh        @"user/gettonometer"
//上传生活照
#define Inter_UploadDailyPhoto      @"upload/uploadlifepic"
//下载头像
#define Inter_GetHeadPic            @"update/getcard"
//下载生活照
#define Inter_GetLifePic            @"realname/getLifePic"
//上传身份证照
#define Inter_IdCardPicUpload       @"upload/uploadcardpic"

//实名管理－工资列表
#define Inter_RealNameSalary        @"realname/getsalary"
//实名管理－工人名册
#define Inter_RealNameUserDetail    @"realname/getuserdetails"
//实名管理－信息管理
#define Inter_RealNameContactDetail @"realname/getcontactdetails"
//实名管理－考勤管理
#define Inter_RealNameUserRecord    @"realname/getuserrecords"
//实名管理－银行卡
#define Inter_RealNameBankCard      @"realname/getbankcards"
//实名管理-健康管理
#define Inter_RealNameHealth        @"realname/getHealthData"

//考情统计用工地列表页面

//大小班组
#define Inter_GroupGetGroup         @"group/getgroups"
#define Inter_GroupGetSubGroup      @"group/getsubgroups"
#endif /* InterfaceDefines_h */
