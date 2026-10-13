/*
================================================================================
檔案代號:hrda_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrda_file
(
hrda00      varchar2(20) NOT NULL,   /*周期性薪资ID                           */
hrda01      varchar2(20),            /*员工ID                                 */
hrda02      varchar2(20),            /*周期性薪资                             */
hrda03      varchar2(100),           /*开始薪资月度                           */
hrda04      varchar2(100),           /*结束薪资月度                           */
hrda05      number(15,2),            /*每月金额                               */
hrda06      number(15,2),            /*应发生金额                             */
hrda07      number(15,2),            /*累计发生总金额                         */
hrda08      varchar2(100),           /*备注                                   */
hrdaacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdauser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdagrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdamodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdadate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdaoriu    varchar2(10),            /*资料建立者                             */
hrdaorig    varchar2(10),            /*资料建立部门                           */
hrdaud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdaud02    varchar2(40),            /*自订栏位-文字                          */
hrdaud03    varchar2(40),            /*自订栏位-文字                          */
hrdaud04    varchar2(40),            /*自订栏位-文字                          */
hrdaud05    varchar2(40),            /*自订栏位-文字                          */
hrdaud06    varchar2(40),            /*自订栏位-文字                          */
hrdaud07    number(15,3),            /*自订栏位-数值                          */
hrdaud08    number(15,3),            /*自订栏位-数值                          */
hrdaud09    number(15,3),            /*自订栏位-数值                          */
hrdaud10    number(10),              /*自订栏位-整数                          */
hrdaud11    number(10),              /*自订栏位-整数                          */
hrdaud12    number(10),              /*自订栏位-整数                          */
hrdaud13    date,                    /*自订栏位-日期                          */
hrdaud14    date,                    /*自订栏位-日期                          */
hrdaud15    date                     /*自订栏位-日期                          */
);

alter table hrda_file add  constraint tpc_hrda_pk primary key  (hrda00) enable validate;
grant select on hrda_file to tiptopgp;
grant update on hrda_file to tiptopgp;
grant delete on hrda_file to tiptopgp;
grant insert on hrda_file to tiptopgp;
grant index on hrda_file to public;
grant select on hrda_file to ods;
