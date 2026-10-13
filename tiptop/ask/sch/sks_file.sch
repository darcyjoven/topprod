/*
================================================================================
檔案代號:sks_file
檔案名稱:裁片移转单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sks_file
(
sks01       varchar2(20) DEFAULT ' ' NOT NULL, /*移转单号*/
sks02       date DEFAULT sysdate NOT NULL, /*移转日期*/
sks03       varchar2(10),            /*移出部门                               */
sks04       varchar2(10),            /*移入部门                               */
sks05       varchar2(255),           /*备注                                   */
sks06       varchar2(1),             /*审核码                                 */
sksacti     varchar2(1),             /*资料有效码                             */
sksdate     date,                    /*最近更改日                             */
sksgrup     varchar2(10),            /*资料所属群组                           */
sksmodu     varchar2(10),            /*资料更改者                             */
sksuser     varchar2(10),            /*资料所有者                             */
sksud01     varchar2(255),           /*自订字段-Textedit                      */
sksud02     varchar2(40),            /*自订字段-文字                          */
sksud03     varchar2(40),            /*自订字段-文字                          */
sksud04     varchar2(40),            /*自订字段-文字                          */
sksud05     varchar2(40),            /*自订字段-文字                          */
sksud06     varchar2(40),            /*自订字段-文字                          */
sksud07     number(15,3),            /*自订字段-数值                          */
sksud08     number(15,3),            /*自订字段-数值                          */
sksud09     number(15,3),            /*自订字段-数值                          */
sksud10     number(10),              /*自订字段-整数                          */
sksud11     number(10),              /*自订字段-整数                          */
sksud12     number(10),              /*自订字段-整数                          */
sksud13     date,                    /*自订字段-日期                          */
sksud14     date,                    /*自订字段-日期                          */
sksud15     date,                    /*自订字段-日期                          */
sksplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skslegal    varchar2(10) NOT NULL,   /*所属法人                               */
sksoriu     varchar2(10),            /*资料建立者                             */
sksorig     varchar2(10)             /*资料建立部门                           */
);

alter table sks_file add  constraint sks_pk primary key  (sks01) enable validate;
grant select on sks_file to tiptopgp;
grant update on sks_file to tiptopgp;
grant delete on sks_file to tiptopgp;
grant insert on sks_file to tiptopgp;
grant index on sks_file to public;
grant select on sks_file to ods;
