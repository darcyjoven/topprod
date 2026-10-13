/*
================================================================================
檔案代號:hrcg_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcg_file
(
hrcg01      varchar2(20) NOT NULL,   /*公司编号                               */
hrcg02      number(2) NOT NULL,      /*工龄/年                                */
hrcg03      number(2) NOT NULL,      /*法定年假天数                           */
hrcg04      number(2) NOT NULL,      /*福利年假天数                           */
hrcg05      varchar2(255),           /*备注                                   */
hrcgud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcgud02    varchar2(40),            /*自订栏位-文字                          */
hrcgud03    varchar2(40),            /*自订栏位-文字                          */
hrcgud04    varchar2(40),            /*自订栏位-文字                          */
hrcgud05    varchar2(40),            /*自订栏位-文字                          */
hrcgud06    varchar2(40),            /*自订栏位-文字                          */
hrcgud07    number(15,3),            /*自订栏位-数值                          */
hrcgud08    number(15,3),            /*自订栏位-数值                          */
hrcgud09    number(15,3),            /*自订栏位-数值                          */
hrcgud10    number(10),              /*自订栏位-整数                          */
hrcgud11    number(10),              /*自订栏位-整数                          */
hrcgud12    number(10),              /*自订栏位-整数                          */
hrcgud13    date,                    /*自订栏位-日期                          */
hrcgud14    date,                    /*自订栏位-日期                          */
hrcgud15    date,                    /*自订栏位-日期                          */
hrcguser    varchar2(10),            /*资料所有者                             */
hrcggrup    varchar2(10),            /*资料所有群                             */
hrcgmodu    varchar2(10),            /*资料更改者                             */
hrcgdate    date,                    /*最近修改日                             */
hrcgorig    varchar2(10),            /*资料建立部门                           */
hrcgoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrcg_file add  constraint tpc_hrcg_pk primary key  (hrcg01,hrcg02) enable validate;
grant select on hrcg_file to tiptopgp;
grant update on hrcg_file to tiptopgp;
grant delete on hrcg_file to tiptopgp;
grant insert on hrcg_file to tiptopgp;
grant index on hrcg_file to public;
grant select on hrcg_file to ods;
