/*
================================================================================
檔案代號:hrbi_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbi_file
(
hrbi01      varchar2(50) NOT NULL,   /*旧人员ID                               */
hrbi02      varchar2(50),            /*新增人员ID                             */
hrbi03      date,                    /*申请日期                               */
hrbi04      varchar2(50),            /*工号                                   */
hrbi05      date,                    /*入司日期                               */
hrbi06      varchar2(20),            /*部门编号                               */
hrbi07      varchar2(10),            /*员工状态                               */
hrbi08      varchar2(50),            /*职位编号                               */
hrbi09      varchar2(50),            /*成本中心                               */
hrbi10      date,                    /*公司年薪起算日期                       */
hrbi11      varchar2(255),           /*回聘日期                               */
hrbi12      varchar2(255),           /*原用人部门意见                         */
hrbi13      varchar2(255),           /*回聘部门意见                           */
hrbi14      varchar2(255),           /*HR部门意见                             */
hrbi15      varchar2(255),           /*备注                                   */
hrbiud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbiud02    varchar2(40),            /*自订栏位-文字                          */
hrbiud03    varchar2(40),            /*自订栏位-文字                          */
hrbiud04    varchar2(40),            /*自订栏位-文字                          */
hrbiud05    varchar2(40),            /*自订栏位-文字                          */
hrbiud06    varchar2(40),            /*自订栏位-文字                          */
hrbiud07    number(15,3),            /*自订栏位-数值                          */
hrbiud08    number(15,3),            /*自订栏位-数值                          */
hrbiud09    number(15,3),            /*自订栏位-数值                          */
hrbiud10    number(10),              /*自订栏位-整数                          */
hrbiud11    number(10),              /*自订栏位-整数                          */
hrbiud12    number(10),              /*自订栏位-整数                          */
hrbiud13    date,                    /*自订栏位-日期                          */
hrbiud14    date,                    /*自订栏位-日期                          */
hrbiud15    date,                    /*自订栏位-日期                          */
hrbiconf    varchar2(1),             /*审核状态                               */
hrbiuser    varchar2(10),            /*资料所有者                             */
hrbigrup    varchar2(10),            /*资料所有群                             */
hrbimodu    varchar2(10),            /*资料更改者                             */
hrbidate    date,                    /*最近修改日                             */
hrbiorig    varchar2(10),            /*资料简历部门                           */
hrbioriu    varchar2(10)             /*资料建立者                             */
);

alter table hrbi_file add  constraint tpc_hrbi_pk primary key  (hrbi01) enable validate;
grant select on hrbi_file to tiptopgp;
grant update on hrbi_file to tiptopgp;
grant delete on hrbi_file to tiptopgp;
grant insert on hrbi_file to tiptopgp;
grant index on hrbi_file to public;
grant select on hrbi_file to ods;
