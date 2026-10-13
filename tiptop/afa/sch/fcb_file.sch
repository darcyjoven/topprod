/*
================================================================================
檔案代號:fcb_file
檔案名稱:固定资产投资抵减单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fcb_file
(
fcb01       varchar2(20) NOT NULL,   /*申请单号                               */
fcb02       date,                    /*申请日期                               */
fcb03       date,                    /*管理局核准日期                         */
fcb04       varchar2(30),            /*管理局核准文号                         */
fcb05       date,                    /*国税局核准日期                         */
fcb06       varchar2(30),            /*国税局核准文号                         */
fcbconf     varchar2(1),             /*审核否                                 */
fcbprsw     number(5),               /*打印次数                               */
fcbuser     varchar2(10),            /*资料所有者                             */
fcbgrup     varchar2(10),            /*资料所有部门                           */
fcbmodu     varchar2(10),            /*资料更改者                             */
fcbdate     date,                    /*最近更改日                             */
fcbud01     varchar2(255),           /*自订字段-Textedit                      */
fcbud02     varchar2(40),            /*自订字段-文字                          */
fcbud03     varchar2(40),            /*自订字段-文字                          */
fcbud04     varchar2(40),            /*自订字段-文字                          */
fcbud05     varchar2(40),            /*自订字段-文字                          */
fcbud06     varchar2(40),            /*自订字段-文字                          */
fcbud07     number(15,3),            /*自订字段-数值                          */
fcbud08     number(15,3),            /*自订字段-数值                          */
fcbud09     number(15,3),            /*自订字段-数值                          */
fcbud10     number(10),              /*自订字段-整数                          */
fcbud11     number(10),              /*自订字段-整数                          */
fcbud12     number(10),              /*自订字段-整数                          */
fcbud13     date,                    /*自订字段-日期                          */
fcbud14     date,                    /*自订字段-日期                          */
fcbud15     date,                    /*自订字段-日期                          */
fcblegal    varchar2(10) NOT NULL,   /*所属法人                               */
fcboriu     varchar2(10),            /*资料建立者                             */
fcborig     varchar2(10)             /*资料建立部门                           */
);

alter table fcb_file add  constraint fcb_pk primary key  (fcb01) enable validate;
grant select on fcb_file to tiptopgp;
grant update on fcb_file to tiptopgp;
grant delete on fcb_file to tiptopgp;
grant insert on fcb_file to tiptopgp;
grant index on fcb_file to public;
grant select on fcb_file to ods;
