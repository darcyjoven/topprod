/*
================================================================================
檔案代號:hrdw_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdw_file
(
hrdw01      varchar2(20) NOT NULL,   /*员工ID                                 */
hrdw02      varchar2(20) NOT NULL,   /*统筹参数ID                             */
hrdw03      varchar2(100) NOT NULL,  /*薪资月                                 */
hrdw04      number(20,6),            /*个人缴费金额                           */
hrdw05      number(20,6),            /*单位缴费金额                           */
hrdw06      number(20,6),            /*个人补缴金额                           */
hrdw07      number(20,6),            /*单位补缴金额                           */
hrdw08      varchar2(255),           /*备注                                   */
hrdwacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdwuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdwgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdwmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdwdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdworiu    varchar2(10),            /*资料建立者                             */
hrdworig    varchar2(10),            /*资料建立部门                           */
hrdwud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdwud02    varchar2(40),            /*自订栏位-文字                          */
hrdwud03    varchar2(40),            /*自订栏位-文字                          */
hrdwud04    varchar2(40),            /*自订栏位-文字                          */
hrdwud05    varchar2(40),            /*自订栏位-文字                          */
hrdwud06    varchar2(40),            /*自订栏位-文字                          */
hrdwud07    number(15,3),            /*自订栏位-数值                          */
hrdwud08    number(15,3),            /*自订栏位-数值                          */
hrdwud09    number(15,3),            /*自订栏位-数值                          */
hrdwud10    number(10),              /*自订栏位-整数                          */
hrdwud11    number(10),              /*自订栏位-整数                          */
hrdwud12    number(10),              /*自订栏位-整数                          */
hrdwud13    date,                    /*自订栏位-日期                          */
hrdwud14    date,                    /*自订栏位-日期                          */
hrdwud15    date                     /*自订栏位-日期                          */
);

alter table hrdw_file add  constraint tpc_hrdw_pk primary key  (hrdw01,hrdw02,hrdw03) enable validate;
grant select on hrdw_file to tiptopgp;
grant update on hrdw_file to tiptopgp;
grant delete on hrdw_file to tiptopgp;
grant insert on hrdw_file to tiptopgp;
grant index on hrdw_file to public;
grant select on hrdw_file to ods;
