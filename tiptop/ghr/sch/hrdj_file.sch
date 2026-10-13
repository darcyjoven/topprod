/*
================================================================================
檔案代號:hrdj_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdj_file
(
hrdj01      varchar2(20) NOT NULL,   /*项目编号                               */
hrdj02      varchar2(100),           /*项目名称                               */
hrdj03      varchar2(20),            /*公司编号                               */
hrdj04      varchar2(1),             /*累计次数                               */
hrdj05      varchar2(1),             /*累积分钟                               */
hrdj06      varchar2(1),             /*累计小时                               */
hrdj07      varchar2(1),             /*累计天数                               */
hrdjacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrdjuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrdjgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrdjmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrdjdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrdjoriu    varchar2(10),            /*资料建立者                             */
hrdjorig    varchar2(10),            /*资料建立部门                           */
hrdjud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdjud02    varchar2(40),            /*自订栏位-文字                          */
hrdjud03    varchar2(40),            /*自订栏位-文字                          */
hrdjud04    varchar2(40),            /*自订栏位-文字                          */
hrdjud05    varchar2(40),            /*自订栏位-文字                          */
hrdjud06    varchar2(40),            /*自订栏位-文字                          */
hrdjud07    number(15,3),            /*自订栏位-数值                          */
hrdjud08    number(15,3),            /*自订栏位-数值                          */
hrdjud09    number(15,3),            /*自订栏位-数值                          */
hrdjud10    number(10),              /*自订栏位-整数                          */
hrdjud11    number(10),              /*自订栏位-整数                          */
hrdjud12    number(10),              /*自订栏位-整数                          */
hrdjud13    date,                    /*自订栏位-日期                          */
hrdjud14    date,                    /*自订栏位-日期                          */
hrdjud15    date                     /*自订栏位-日期                          */
);

alter table hrdj_file add  constraint tpc_hrdj_pk primary key  (hrdj01) enable validate;
grant select on hrdj_file to tiptopgp;
grant update on hrdj_file to tiptopgp;
grant delete on hrdj_file to tiptopgp;
grant insert on hrdj_file to tiptopgp;
grant index on hrdj_file to public;
grant select on hrdj_file to ods;
