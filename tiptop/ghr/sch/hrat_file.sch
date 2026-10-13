/*
================================================================================
檔案代號:hrat_file
檔案名稱:员工信息表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrat_file
(
hrat01      varchar2(50) NOT NULL,   /*员工编号                               */
hrat02      varchar2(50) NOT NULL,   /*员工姓名                               */
hrat03      varchar2(20) NOT NULL,   /*公司编号                               */
hrat04      varchar2(20) NOT NULL,   /*部门编号                               */
hrat05      varchar2(50) NOT NULL,   /*主职位                                 */
hrat06      varchar2(50),            /*直接主管                               */
hrat07      varchar2(1),             /*部门主管否                             */
hrat08      number(20),              /*自然编号                               */
hrat09      varchar2(1),             /*编制内人员否                           */
hrat10      varchar2(50),            /*宿舍号                                 */
hrat11      varchar2(1),             /*外派人员否                             */
hrat12      varchar2(10),            /*证件类型                               */
hrat13      varchar2(50),            /*证件号码                               */
hrat14      date,                    /*证件到证日期                           */
hrat15      date,                    /*出生日期                               */
hrat16      number(5,2),             /*年龄                                   */
hrat17      varchar2(10),            /*性别                                   */
hrat18      varchar2(900),           /*籍贯                                   */
hrat19      varchar2(10),            /*员工状态                               */
hrat20      varchar2(10),            /*员工属性编号                           */
hrat21      varchar2(10),            /*直接&间接                              */
hrat22      varchar2(10),            /*学历                                   */
hrat23      varchar2(50),            /*主修专业                               */
hrat24      varchar2(10),            /*婚姻状况                               */
hrat25      date,                    /*入司日期                               */
hrat26      date,                    /*预计转正日期                           */
hrat27      date,                    /*实际转正日期                           */
hrat28      varchar2(10),            /*国家地区                               */
hrat29      varchar2(10),            /*民族                                   */
hrat30      varchar2(10),            /*户口性质                               */
hrat31      varchar2(50),            /*密码                                   */
hrat32      varchar2(255),           /*照片                                   */
hrat33      varchar2(1),             /*储备人员否                             */
hrat34      varchar2(10),            /*政治面貌                               */
hrat35      date,                    /*阴历生日                               */
hrat36      date,                    /*首次工作日期                           */
hrat37      number(5),               /*其他企业工作工龄                       */
hrat38      date,                    /*计工龄开始日期                         */
hrat39      number(5),               /*公司承认工龄                           */
hrat40      varchar2(10),            /*所属地区                               */
hrat41      varchar2(10),            /*所属厂区                               */
hrat42      varchar2(10),            /*所属成本中心                           */
hrat43      varchar2(10),            /*招聘来源编号                           */
hrat44      varchar2(10),            /*介绍人                                 */
hrat45      varchar2(100),           /*户口所在地                             */
hrat46      varchar2(100),           /*现居地址                               */
hrat47      varchar2(100),           /*现住宅电话                             */
hrat48      varchar2(40),            /*英文名                                 */
hrat49      varchar2(20),            /*手机号码                               */
hrat50      varchar2(20),            /*办公号码                               */
hrat51      varchar2(100),           /*公司邮箱                               */
hrat52      varchar2(50),            /*审核代理人                             */
hrat53      varchar2(1),             /*是否综合工时                           */
hrat54      varchar2(1),             /*是否入会                               */
hrat55      number(10,2),            /*身高                                   */
hrat56      number(10,2),            /*体重                                   */
hrat57      number(10,2),            /*视力                                   */
hrat58      varchar2(10),            /*用工类型                               */
hrat59      varchar2(10),            /*健康状况                               */
hrat60      varchar2(1000),          /*个人既往病史                           */
hrat61      varchar2(1000),          /*性格特征                               */
hrat62      varchar2(1000),          /*兴趣爱好                               */
hrat63      varchar2(1000),          /*性格评测记录                           */
hrat64      varchar2(10),            /*职级                                   */
hrat65      varchar2(255),           /*备注                                   */
hratconf    varchar2(1),             /*是否审核                               */
hratacti    varchar2(1),             /*资料有效否                             */
hratuser    varchar2(10),            /*资料所有者                             */
hratgrup    varchar2(10),            /*资料所有群                             */
hratmodu    varchar2(10),            /*资料更改者                             */
hratdate    date,                    /*最近修改日                             */
hratorig    varchar2(10),            /*资料建立部门                           */
hratoriu    varchar2(10),            /*资料建立者                             */
hratid      varchar2(10) NOT NULL,   /*员工ID                                 */
hrat66      varchar2(20),            /*报到时间                               */
hrat67      varchar2(10),            /*职称                                   */
hrat68      varchar2(10),            /*社保缴交地                             */
hrat69      date,                    /*现职开始日期                           */
hrat70      date,                    /*居留证到期日期                         */
hrat71      varchar2(10),            /*职等代号                               */
hrat72      varchar2(10),            /*机密等级代号                           */
hrat73      varchar2(10),            /*是否签订三方协议                       */
hrat74      date,                    /*职称授予时间                           */
hrat75      varchar2(20),            /*招聘负责人                             */
hrat76      varchar2(300),           /*身份证地址                             */
hrat77      date,                    /*最后工作日                             */
hrat78      number(5),               /*职称类别                               */
hrat79      varchar2(20),            /*审批等级                               */
hrat80      varchar2(20),            /*是否建档                               */
hrat81      varchar2(20),            /*存档地点                               */
hrat82      varchar2(20),            /*异动记录                               */
hrat83      varchar2(20),            /*是否关键岗位                           */
hrat84      varchar2(20),            /*时:分:秒                               */
hrat85      date,                    /*建档日期                               */
hrat86      varchar2(10),            /*考勤类型                               */
hrat87      varchar2(40),            /*课别                                   */
hrat88      varchar2(40),            /*组别                                   */
hrat89      number(5),               /*证件有效期                             */
hrat90      varchar2(60),            /*考勤方式                               */
hrat91      varchar2(20),            /*薪资类别                               */
hrat92      varchar2(1),
hrat93      varchar2(10),            /*分析类型                               */
hrat94      varchar2(40),
hrat95      varchar2(50),
hrat96      varchar2(40),
ta_hrat01   varchar2(1),             /*是否乘坐班车                           */
ta_hrat02   varchar2(1),             /*是否食堂就餐                           */
ta_hrat03   varchar2(1),             /*是否公司住宿                           */
hrat97      varchar2(20)
);

create        index tc_hrat_01 on hrat_file (hrat01);
alter table hrat_file add  constraint tpc_hrat_pk unique (hratid) enable validate;
alter table hrat_file add  constraint hrat01 unique (hrat01) enable validate;
grant select on hrat_file to tiptopgp;
grant update on hrat_file to tiptopgp;
grant delete on hrat_file to tiptopgp;
grant insert on hrat_file to tiptopgp;
grant index on hrat_file to public;
grant select on hrat_file to ods;
