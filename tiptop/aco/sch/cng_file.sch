/*
================================================================================
檔案代號:cng_file
檔案名稱:模拟合同出口成品单头档 (A046)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cng_file
(
cng01       varchar2(20) NOT NULL,   /*模拟编号                               */
cng02       varchar2(4),             /*币种                                   */
cng03       varchar2(20),            /*手册编号                               */
cng04       varchar2(20),            /*合同编号                               */
cng05       date,                    /*有效期限                               */
cng06       date,                    /*审批日期                               */
cng07       date,                    /*核销日期                               */
cng08       number(20,6),            /*进口总值                               */
cng09       number(20,6),            /*出口总值                               */
cng10       varchar2(20),            /*申请编号                               */
cng11       varchar2(1),             /*No Use                                 */
cng12       varchar2(10),            /*海关编号                               */
cngconf     varchar2(1),             /*确认码                                 */
cngacti     varchar2(1),             /*资料有效码                             */
cnguser     varchar2(10),            /*资料所有者                             */
cnggrup     varchar2(10),            /*资料所有群                             */
cngmodu     varchar2(10),            /*资料更改者                             */
cngdate     date,                    /*最近更改日                             */
cngud01     varchar2(255),           /*自订字段-Textedit                      */
cngud02     varchar2(40),            /*自订字段-文字                          */
cngud03     varchar2(40),            /*自订字段-文字                          */
cngud04     varchar2(40),            /*自订字段-文字                          */
cngud05     varchar2(40),            /*自订字段-文字                          */
cngud06     varchar2(40),            /*自订字段-文字                          */
cngud07     number(15,3),            /*自订字段-数值                          */
cngud08     number(15,3),            /*自订字段-数值                          */
cngud09     number(15,3),            /*自订字段-数值                          */
cngud10     number(10),              /*自订字段-整数                          */
cngud11     number(10),              /*自订字段-整数                          */
cngud12     number(10),              /*自订字段-整数                          */
cngud13     date,                    /*自订字段-日期                          */
cngud14     date,                    /*自订字段-日期                          */
cngud15     date,                    /*自订字段-日期                          */
cngplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnglegal    varchar2(10) NOT NULL,   /*所属法人                               */
cngorig     varchar2(10),            /*资料建立部门                           */
cngoriu     varchar2(10)             /*资料建立者                             */
);

create        index cng_02 on cng_file (cng03);
alter table cng_file add  constraint cng_pk primary key  (cng01) enable validate;
grant select on cng_file to tiptopgp;
grant update on cng_file to tiptopgp;
grant delete on cng_file to tiptopgp;
grant insert on cng_file to tiptopgp;
grant index on cng_file to public;
grant select on cng_file to ods;
