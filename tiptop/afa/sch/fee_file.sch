/*
================================================================================
檔案代號:fee_file
檔案名稱:模具归还单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fee_file
(
fee01       varchar2(20) NOT NULL,   /*归还单号                               */
fee02       date,                    /*归还日期                               */
fee03       varchar2(10),            /*部门编号/厂商编号                      */
fee04       varchar2(255),           /*备    注                               */
fee05       varchar2(1),             /*类型                                   */
feeacti     varchar2(1),             /*资料有效码                             */
feeuser     varchar2(10),            /*资料所有者                             */
feegrup     varchar2(10),            /*资料所有部门                           */
feemodu     varchar2(10),            /*资料更改者                             */
feedate     date,                    /*最近更改日                             */
feeud01     varchar2(255),           /*自订字段-Textedit                      */
feeud02     varchar2(40),            /*自订字段-文字                          */
feeud03     varchar2(40),            /*自订字段-文字                          */
feeud04     varchar2(40),            /*自订字段-文字                          */
feeud05     varchar2(40),            /*自订字段-文字                          */
feeud06     varchar2(40),            /*自订字段-文字                          */
feeud07     number(15,3),            /*自订字段-数值                          */
feeud08     number(15,3),            /*自订字段-数值                          */
feeud09     number(15,3),            /*自订字段-数值                          */
feeud10     number(10),              /*自订字段-整数                          */
feeud11     number(10),              /*自订字段-整数                          */
feeud12     number(10),              /*自订字段-整数                          */
feeud13     date,                    /*自订字段-日期                          */
feeud14     date,                    /*自订字段-日期                          */
feeud15     date,                    /*自订字段-日期                          */
feeconf     varchar2(1),             /*审核否                                 */
fee06       varchar2(1),             /*签核状况                               */
fee07       varchar2(10),            /*申请人                                 */
feemksg     varchar2(1),             /*是否签核                               */
feelegal    varchar2(10) NOT NULL,   /*所属法人                               */
feeoriu     varchar2(10),            /*资料建立者                             */
feeorig     varchar2(10)             /*资料建立部门                           */
);

alter table fee_file add  constraint fee_pk primary key  (fee01) enable validate;
grant select on fee_file to tiptopgp;
grant update on fee_file to tiptopgp;
grant delete on fee_file to tiptopgp;
grant insert on fee_file to tiptopgp;
grant index on fee_file to public;
grant select on fee_file to ods;
