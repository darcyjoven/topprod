/*
================================================================================
檔案代號:hratz_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hratz_file
(
hratz01     varchar2(20) NOT NULL,   /*姓名                                   */
hratz02     varchar2(20) NOT NULL,   /*性别                                   */
hratz03     varchar2(60) NOT NULL,   /*民族                                   */
hratz04     number(4) NOT NULL,      /*出生日期                               */
hratz05     number(2) NOT NULL,      /*住址                                   */
hratz06     date,                    /*证件号码                               */
hratz07     date,                    /*发证日期                               */
hratz08     varchar2(1) NOT NULL,    /*失效日期                               */
hratz09     varchar2(255),           /*发证机关                               */
hratz10     blob,                    /*证件照片                               */
hratzud01   varchar2(255),           /*照片                                   */
hratzud02   varchar2(40),            /*员工工号                               */
hratzud03   varchar2(40),            /*是否引用                               */
hratzud04   varchar2(40),            /*自订栏位-文字                          */
hratzud05   varchar2(40),            /*自订栏位-文字                          */
hratzud06   varchar2(40),            /*自订栏位-文字                          */
hratzud07   number(15,3),            /*自订栏位-数值                          */
hratzud08   number(15,3),            /*自订栏位-数值                          */
hratzud09   number(15,3),            /*自订栏位-数值                          */
hratzud10   number(10),              /*自订栏位-整数                          */
hratzud11   number(10),              /*自订栏位-整数                          */
hratzud12   number(10),              /*自订栏位-整数                          */
hratzud13   date,                    /*自订栏位-日期                          */
hratzud14   date,                    /*自订栏位-日期                          */
hratzud15   date,                    /*自订栏位-日期                          */
hratzuser   varchar2(10),            /*资料所有者                             */
hratzgrup   varchar2(10),            /*资料所有群                             */
hratzmodu   varchar2(10),            /*资料更改者                             */
hratzdate   date,                    /*最近修改日                             */
hratzorig   varchar2(10),            /*资料建立部门                           */
hratzoriu   varchar2(10)             /*资料建立者                             */
);

alter table hratz_file add  constraint tpc_hratz_pk primary key  (hratz01,hratz04,hratz05) enable validate;
grant select on hratz_file to tiptopgp;
grant update on hratz_file to tiptopgp;
grant delete on hratz_file to tiptopgp;
grant insert on hratz_file to tiptopgp;
grant index on hratz_file to public;
grant select on hratz_file to ods;
