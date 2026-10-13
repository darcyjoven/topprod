/*
================================================================================
檔案代號:fau_file
檔案名稱:资产外送单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fau_file
(
fau01       varchar2(20) NOT NULL,   /*外送单号                               */
fau02       date,                    /*外送日期                               */
fau03       varchar2(10),            /*申请人员                               */
fau04       varchar2(10),            /*申请部门                               */
fau05       date,                    /*申请日期                               */
fauconf     varchar2(1),             /*确认码                                 */
faupost     varchar2(1),             /*过帐码                                 */
fauprsw     number(5),               /*打印次数                               */
fauuser     varchar2(10),            /*资料所有者                             */
faugrup     varchar2(10),            /*资料所有群                             */
faumodu     varchar2(10),            /*资料更改者                             */
faudate     date,                    /*最近更改日                             */
fau06       varchar2(1),             /*签核状况码                             */
faumksg     varchar2(1),             /*签核否？                               */
fauud01     varchar2(255),           /*自订字段-Textedit                      */
fauud02     varchar2(40),            /*自订字段-文字                          */
fauud03     varchar2(40),            /*自订字段-文字                          */
fauud04     varchar2(40),            /*自订字段-文字                          */
fauud05     varchar2(40),            /*自订字段-文字                          */
fauud06     varchar2(40),            /*自订字段-文字                          */
fauud07     number(15,3),            /*自订字段-数值                          */
fauud08     number(15,3),            /*自订字段-数值                          */
fauud09     number(15,3),            /*自订字段-数值                          */
fauud10     number(10),              /*自订字段-整数                          */
fauud11     number(10),              /*自订字段-整数                          */
fauud12     number(10),              /*自订字段-整数                          */
fauud13     date,                    /*自订字段-日期                          */
fauud14     date,                    /*自订字段-日期                          */
fauud15     date,                    /*自订字段-日期                          */
faulegal    varchar2(10) NOT NULL,   /*所属法人                               */
fauoriu     varchar2(10),            /*资料建立者                             */
fauorig     varchar2(10)             /*资料建立部门                           */
);

alter table fau_file add  constraint fau_pk primary key  (fau01) enable validate;
grant select on fau_file to tiptopgp;
grant update on fau_file to tiptopgp;
grant delete on fau_file to tiptopgp;
grant insert on fau_file to tiptopgp;
grant index on fau_file to public;
grant select on fau_file to ods;
