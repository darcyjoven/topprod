/*
================================================================================
檔案代號:hrcx_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcx_file
(
hrcx01      varchar2(50) NOT NULL,   /*员工ID                                 */
hrcx02      varchar2(50) NOT NULL,   /*临时卡卡号                             */
hrcx03      varchar2(10),            /*借用原因                               */
hrcx04      date NOT NULL,           /*生效日期                               */
hrcx05      varchar2(10),            /*生效时间                               */
hrcx06      date,                    /*归还日期                               */
hrcx07      varchar2(10),            /*归还时间                               */
hrcx08      varchar2(1),             /*临时卡归还否                           */
hrcx09      varchar2(255),           /*备注                                   */
hrcxud01    varchar2(255),           /*自订栏位-Textedit                      */
hrcxud02    varchar2(40),            /*自订栏位-文字                          */
hrcxud03    varchar2(40),            /*自订栏位-文字                          */
hrcxud04    varchar2(40),            /*自订栏位-文字                          */
hrcxud05    varchar2(40),            /*自订栏位-文字                          */
hrcxud06    varchar2(40),            /*自订栏位-文字                          */
hrcxud07    number(15,3),            /*自订栏位-数值                          */
hrcxud08    number(15,3),            /*自订栏位-数值                          */
hrcxud09    number(15,3),            /*自订栏位-数值                          */
hrcxud10    number(10),              /*自订栏位-整数                          */
hrcxud11    number(10),              /*自订栏位-整数                          */
hrcxud12    number(10),              /*自订栏位-整数                          */
hrcxud13    date,                    /*自订栏位-日期                          */
hrcxud14    date,                    /*自订栏位-日期                          */
hrcxud15    date,                    /*自订栏位-日期                          */
hrcxuser    varchar2(10),            /*资料所有者                             */
hrcxgrup    varchar2(10),            /*资料所有群                             */
hrcxmodu    varchar2(10),            /*资料更改者                             */
hrcxdate    date,                    /*最近修改日                             */
hrcxorig    varchar2(10),            /*资料建立部门                           */
hrcxoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrcx_file add  constraint tpc_hrcx_pk primary key  (hrcx01,hrcx02,hrcx04) enable validate;
grant select on hrcx_file to tiptopgp;
grant update on hrcx_file to tiptopgp;
grant delete on hrcx_file to tiptopgp;
grant insert on hrcx_file to tiptopgp;
grant index on hrcx_file to public;
grant select on hrcx_file to ods;
