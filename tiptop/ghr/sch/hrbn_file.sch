/*
================================================================================
檔案代號:hrbn_file
檔案名稱:员工考勤方式记录表
檔案目的:记录员工考勤方式
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbn_file
(
hrbn01      varchar2(50) NOT NULL,   /*员工ID                                 */
hrbn02      varchar2(60) NOT NULL,   /*考勤方式                               */
hrbn03      date,                    /*设置日期                               */
hrbn04      date NOT NULL,           /*生效日期                               */
hrbn05      date,                    /*失效日期                               */
hrbn06      varchar2(255),           /*备注                                   */
hrbnud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbnud02    varchar2(40),            /*自订栏位-文字                          */
hrbnud03    varchar2(40),            /*自订栏位-文字                          */
hrbnud04    varchar2(40),            /*自订栏位-文字                          */
hrbnud05    varchar2(40),            /*自订栏位-文字                          */
hrbnud06    varchar2(40),            /*自订栏位-文字                          */
hrbnud07    number(15,3),            /*自订栏位-数值                          */
hrbnud08    number(15,3),            /*自订栏位-数值                          */
hrbnud09    number(15,3),            /*自订栏位-数值                          */
hrbnud10    number(10),              /*自订栏位-整数                          */
hrbnud11    number(10),              /*自订栏位-整数                          */
hrbnud12    number(10),              /*自订栏位-整数                          */
hrbnud13    date,                    /*自订栏位-日期                          */
hrbnud14    date,                    /*自订栏位-日期                          */
hrbnud15    date,                    /*自订栏位-日期                          */
hrbnuser    varchar2(10),            /*资料所有者                             */
hrbngrup    varchar2(10),            /*资料所有群                             */
hrbnmodu    varchar2(10),            /*资料更改者                             */
hrbndate    date,                    /*最近修改日                             */
hrbnorig    varchar2(10),            /*资料建立部门                           */
hrbnoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrbn_file add  constraint tpc_hrbn_pk primary key  (hrbn01,hrbn04) enable validate;
grant select on hrbn_file to tiptopgp;
grant update on hrbn_file to tiptopgp;
grant delete on hrbn_file to tiptopgp;
grant insert on hrbn_file to tiptopgp;
grant index on hrbn_file to public;
grant select on hrbn_file to ods;
