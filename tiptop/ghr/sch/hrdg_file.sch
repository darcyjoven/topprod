/*
================================================================================
檔案代號:hrdg_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdg_file
(
hrdg01      number(15) NOT NULL,     /*班次变更编号                           */
hrdg02      date NOT NULL,           /*日期                                   */
hrdg03      varchar2(60) NOT NULL,   /*员工ID                                 */
hrdg04      varchar2(60),            /*原班次                                 */
hrdg05      varchar2(60),            /*原补充时间                             */
hrdg06      varchar2(60) NOT NULL,   /*新班次                                 */
hrdg07      varchar2(60),            /*新补充时间                             */
hrdg08      varchar2(255),           /*变更原因                               */
hrdg09      varchar2(255),           /*备注                                   */
hrdgconf    varchar2(1),             /*审核状态                               */
hrdgacti    varchar2(1) NOT NULL,    /*资料有效否                             */
hrdgud01    varchar2(255),           /*自订栏位-Textedit                      */
hrdgud02    varchar2(40),            /*自订栏位-文字                          */
hrdgud03    varchar2(40),            /*自订栏位-文字                          */
hrdgud04    varchar2(40),            /*自订栏位-文字                          */
hrdgud05    varchar2(40),            /*自订栏位-文字                          */
hrdgud06    varchar2(40),            /*自订栏位-文字                          */
hrdgud07    number(15,3),            /*自订栏位-数值                          */
hrdgud08    number(15,3),            /*自订栏位-数值                          */
hrdgud09    number(15,3),            /*自订栏位-数值                          */
hrdgud10    number(10),              /*自订栏位-整数                          */
hrdgud11    number(10),              /*自订栏位-整数                          */
hrdgud12    number(10),              /*自订栏位-整数                          */
hrdgud13    date,                    /*自订栏位-日期                          */
hrdgud14    date,                    /*自订栏位-日期                          */
hrdgud15    date,                    /*自订栏位-日期                          */
hrdguser    varchar2(10),            /*资料所有者                             */
hrdggrup    varchar2(10),            /*资料所有群                             */
hrdgmodu    varchar2(10),            /*资料更改者                             */
hrdgdate    date,                    /*最近修改日                             */
hrdgorig    varchar2(10),            /*资料建立部门                           */
hrdgoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrdg_file add  constraint tpc_hrdg_pk primary key  (hrdg01) enable validate;
grant select on hrdg_file to tiptopgp;
grant update on hrdg_file to tiptopgp;
grant delete on hrdg_file to tiptopgp;
grant insert on hrdg_file to tiptopgp;
grant index on hrdg_file to public;
grant select on hrdg_file to ods;
