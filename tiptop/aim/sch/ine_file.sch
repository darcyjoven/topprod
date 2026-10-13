/*
================================================================================
檔案代號:ine_file
檔案名稱:料件批号特性变更单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ine_file
(
ine01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
ine02       date,                    /*变更日期                               */
ine03       varchar2(10),            /*变更理由                               */
ine04       varchar2(10),            /*变更人员                               */
ine05       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
ineconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
inedate     date,                    /*最近更改日                             */
inegrup     varchar2(10),            /*资料所有群                             */
inelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
inemksg     varchar2(1) DEFAULT ' ' NOT NULL, /*签核码*/
inemodu     varchar2(10),            /*资料更改者                             */
ineorig     varchar2(10),            /*资料建立部门                           */
ineoriu     varchar2(10),            /*资料建立者                             */
ineplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
ineud01     varchar2(255),           /*自订字段-Textedit                      */
ineud02     varchar2(40),            /*自订字段-文字                          */
ineud03     varchar2(40),            /*自订字段-文字                          */
ineud04     varchar2(40),            /*自订字段-文字                          */
ineud05     varchar2(40),            /*自订字段-文字                          */
ineud06     varchar2(40),            /*自订字段-文字                          */
ineud07     number(15,3),            /*自订字段-数值                          */
ineud08     number(15,3),            /*自订字段-数值                          */
ineud09     number(15,3),            /*自订字段-数值                          */
ineud10     number(10),              /*自订字段-整数                          */
ineud11     number(10),              /*自订字段-整数                          */
ineud12     number(10),              /*自订字段-整数                          */
ineud13     date,                    /*自订字段-日期                          */
ineud14     date,                    /*自订字段-日期                          */
ineud15     date,                    /*自订字段-日期                          */
ineuser     varchar2(10),            /*资料所有者                             */
inesendd    date,                    /*发出日期                               */
inesendt    varchar2(8),             /*发出时间                               */
inesendu    varchar2(10)             /*发出人员                               */
);

alter table ine_file add  constraint ine_pk primary key  (ine01) enable validate;
grant select on ine_file to tiptopgp;
grant update on ine_file to tiptopgp;
grant delete on ine_file to tiptopgp;
grant insert on ine_file to tiptopgp;
grant index on ine_file to public;
grant select on ine_file to ods;
