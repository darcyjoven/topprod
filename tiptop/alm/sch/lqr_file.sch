/*
================================================================================
檔案代號:lqr_file
檔案名稱:会员等级变更单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqr_file
(
lqr01       varchar2(20) DEFAULT ' ' NOT NULL, /*升等变更单号*/
lqr02       date,                    /*变更日期                               */
lqr03       varchar2(10),            /*变更理由                               */
lqr04       varchar2(10),            /*变更人员                               */
lqr05       varchar2(1) DEFAULT '0' NOT NULL, /*状况*/
lqracti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
lqrconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核*/
lqrdate     date,                    /*最近更改日                             */
lqrgrup     varchar2(10),            /*资料所有群                             */
lqrlegal    varchar2(10),            /*所属法人                               */
lqrmodu     varchar2(10),            /*资料更改者                             */
lqrorig     varchar2(10),            /*资料建立部门                           */
lqroriu     varchar2(10),            /*资料建立者                             */
lqrplant    varchar2(10),            /*所属营运中心                           */
lqrud01     varchar2(255),           /*自订字段-Textedit                      */
lqrud02     varchar2(40),            /*自订字段-文字                          */
lqrud03     varchar2(40),            /*自订字段-文字                          */
lqrud04     varchar2(40),            /*自订字段-文字                          */
lqrud05     varchar2(40),            /*自订字段-文字                          */
lqrud06     varchar2(40),            /*自订字段-文字                          */
lqrud07     number(15,3),            /*自订字段-数值                          */
lqrud08     number(15,3),            /*自订字段-数值                          */
lqrud09     number(15,3),            /*自订字段-数值                          */
lqrud10     number(10),              /*自订字段-整数                          */
lqrud11     number(10),              /*自订字段-整数                          */
lqrud12     number(10),              /*自订字段-整数                          */
lqrud13     date,                    /*自订字段-日期                          */
lqrud14     date,                    /*自订字段-日期                          */
lqrud15     date,                    /*自订字段-日期                          */
lqruser     varchar2(10),            /*资料所有者                             */
lqrcond     date,                    /*审核日期                               */
lqrconu     varchar2(10)             /*审核人员                               */
);

alter table lqr_file add  constraint lqr_pk primary key  (lqr01) enable validate;
grant select on lqr_file to tiptopgp;
grant update on lqr_file to tiptopgp;
grant delete on lqr_file to tiptopgp;
grant insert on lqr_file to tiptopgp;
grant index on lqr_file to public;
grant select on lqr_file to ods;
