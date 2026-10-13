/*
================================================================================
檔案代號:fbo_file
檔案名稱:资产族群编号异动单单头
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbo_file
(
fbo01       varchar2(16) DEFAULT ' ' NOT NULL, /*异动单号*/
fbo02       date,                    /*异动日期                               */
fbo03       varchar2(10),            /*申请人员                               */
fbo04       varchar2(10),            /*申请部门                               */
fbo05       date,                    /*申请日期                               */
fbo06       varchar2(1) DEFAULT '0' NOT NULL, /*状况码*/
fboconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核否*/
fbodate     date,                    /*最近更改日                             */
fbogrup     varchar2(10),            /*资料所有群                             */
fbomksg     varchar2(1) DEFAULT 'N' NOT NULL, /*是否签核*/
fbomodu     varchar2(10),            /*资料更改者                             */
fbopost     varchar2(1) DEFAULT 'N' NOT NULL, /*过帐码*/
fboud01     varchar2(255),           /*自订字段-Textedit                      */
fboud02     varchar2(40),            /*自订字段-文字                          */
fboud03     varchar2(40),            /*自订字段-文字                          */
fboud04     varchar2(40),            /*自订字段-文字                          */
fboud05     varchar2(40),            /*自订字段-文字                          */
fboud06     varchar2(40),            /*自订字段-文字                          */
fboud07     number(15,3),            /*自订字段-数值                          */
fboud08     number(15,3),            /*自订字段-数值                          */
fboud09     number(15,3),            /*自订字段-数值                          */
fboud10     number(10),              /*自订字段-整数                          */
fboud11     number(10),              /*自订字段-整数                          */
fboud12     number(10),              /*自订字段-整数                          */
fboud13     date,                    /*自订字段-日期                          */
fboud14     date,                    /*自订字段-日期                          */
fboud15     date,                    /*自订字段-日期                          */
fbouser     varchar2(10),            /*资料所有者                             */
fbolegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
fboorig     varchar2(10),            /*资料建立部门                           */
fbooriu     varchar2(10)             /*资料建立者                             */
);

alter table fbo_file add  constraint fbo_pk primary key  (fbo01) enable validate;
grant select on fbo_file to tiptopgp;
grant update on fbo_file to tiptopgp;
grant delete on fbo_file to tiptopgp;
grant insert on fbo_file to tiptopgp;
grant index on fbo_file to public;
grant select on fbo_file to ods;
