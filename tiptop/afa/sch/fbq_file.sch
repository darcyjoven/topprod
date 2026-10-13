/*
================================================================================
檔案代號:fbq_file
檔案名稱:资产停用异动单单头
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbq_file
(
fbq01       varchar2(16) NOT NULL,   /*异动单号                               */
fbq02       date,                    /*异动日期                               */
fbq03       varchar2(1) DEFAULT '1' NOT NULL, /*异动后状态*/
fbq04       varchar2(10),            /*申请人员                               */
fbq05       varchar2(10),            /*申请部门                               */
fbq06       date,                    /*申请日期                               */
fbq07       varchar2(1) DEFAULT '0' NOT NULL, /*状况码*/
fbqconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核否*/
fbqdate     date,                    /*最近更改日                             */
fbqgrup     varchar2(10),            /*资料所有群                             */
fbqmksg     varchar2(1) DEFAULT 'N' NOT NULL, /*是否签核*/
fbqmodu     varchar2(10),            /*资料更改者                             */
fbqpost     varchar2(1) DEFAULT 'N' NOT NULL, /*过帐码*/
fbqud01     varchar2(255),           /*自订字段                               */
fbqud02     varchar2(40),            /*自订字段-文字                          */
fbqud03     varchar2(40),            /*自订字段-文字                          */
fbqud04     varchar2(40),            /*自订字段-文字                          */
fbqud05     varchar2(40),            /*自订字段-文字                          */
fbqud06     varchar2(40),            /*自订字段-文字                          */
fbqud07     number(15,3),            /*自订字段-数值                          */
fbqud08     number(15,3),            /*自订字段-数值                          */
fbqud09     number(15,3),            /*自订字段-数值                          */
fbqud10     number(10),              /*自订字段-整数                          */
fbqud11     number(10),              /*自订字段-整数                          */
fbqud12     number(10),              /*自订字段-整数                          */
fbqud13     date,                    /*自订字段-日期                          */
fbqud14     date,                    /*自订字段-日期                          */
fbqud15     date,                    /*自订字段-日期                          */
fbquser     varchar2(10),            /*资料所有者                             */
fbqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
fbqorig     varchar2(10),            /*资料建立部门                           */
fbqoriu     varchar2(10)             /*资料建立者                             */
);

alter table fbq_file add  constraint fbq_pk primary key  (fbq01) enable validate;
grant select on fbq_file to tiptopgp;
grant update on fbq_file to tiptopgp;
grant delete on fbq_file to tiptopgp;
grant insert on fbq_file to tiptopgp;
grant index on fbq_file to public;
grant select on fbq_file to ods;
