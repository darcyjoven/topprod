/*
================================================================================
檔案代號:hrbx_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbx_file
(
hrbx01      varchar2(20) NOT NULL,   /*单据编号                               */
hrbx02      varchar2(50),            /*考勤机型号                             */
hrbx03      date,                    /*采集日期                               */
hrbx04      varchar2(50),            /*采集人                                 */
hrbx05      varchar2(1),             /*忽略持卡人校验                         */
hrbx06      varchar2(255),           /*备注                                   */
hrbxud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbxud02    varchar2(40),            /*自订栏位-文字                          */
hrbxud03    varchar2(40),            /*自订栏位-文字                          */
hrbxud04    varchar2(40),            /*自订栏位-文字                          */
hrbxud05    varchar2(40),            /*自订栏位-文字                          */
hrbxud06    varchar2(40),            /*自订栏位-文字                          */
hrbxud07    number(15,3),            /*自订栏位-数值                          */
hrbxud08    number(15,3),            /*自订栏位-数值                          */
hrbxud09    number(15,3),            /*自订栏位-数值                          */
hrbxud10    number(10),              /*自订栏位-整数                          */
hrbxud11    number(10),              /*自订栏位-整数                          */
hrbxud12    number(10),              /*自订栏位-整数                          */
hrbxud13    date,                    /*自订栏位-日期                          */
hrbxud14    date,                    /*自订栏位-日期                          */
hrbxud15    date,                    /*自订栏位-日期                          */
hrbxuser    varchar2(10),            /*资料所有者                             */
hrbxgrup    varchar2(10),            /*资料所有群                             */
hrbxmodu    varchar2(10),            /*资料更改者                             */
hrbxdate    date,                    /*最近修改日                             */
hrbxorig    varchar2(10),            /*资料建立部门                           */
hrbxoriu    varchar2(10),            /*资料建立者                             */
hrbx07      varchar2(40),
hrbx08      number(5)
);

alter table hrbx_file add  constraint tpc_hrbx_pk primary key  (hrbx01) enable validate;
grant select on hrbx_file to tiptopgp;
grant update on hrbx_file to tiptopgp;
grant delete on hrbx_file to tiptopgp;
grant insert on hrbx_file to tiptopgp;
grant index on hrbx_file to public;
grant select on hrbx_file to ods;
