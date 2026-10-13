/*
================================================================================
檔案代號:fcd_file
檔案名稱:固定资产抵押单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fcd_file
(
fcd01       varchar2(20) NOT NULL,   /*申请单号                               */
fcd02       date,                    /*申请日期                               */
fcd03       number(20,6),            /*申请抵押金额                           */
fcd04       number(20,6),            /*鉴价                                   */
fcd05       varchar2(20),            /*抵押银行                               */
fcd06       varchar2(30),            /*抵押文号                               */
fcd07       number(20,6),            /*抵押金额                               */
fcd08       varchar2(20),            /*用途                                   */
fcd09       date,                    /*抵押日期                               */
fcd10       number(5),               /*设置期间                               */
fcd11       date,                    /*清偿日期                               */
fcd12       date,                    /*鉴价日期                               */
fcd13       number(15,2),            /*No Use                                 */
fcdconf     varchar2(1),             /*审核否                                 */
fcdprsw     number(5),               /*打印次数                               */
fcduser     varchar2(10),            /*资料所有者                             */
fcdgrup     varchar2(10),            /*资料所有部门                           */
fcdmodu     varchar2(10),            /*资料更改者                             */
fcddate     date,                    /*最近更改日                             */
fcdud01     varchar2(255),           /*自订字段-Textedit                      */
fcdud02     varchar2(40),            /*自订字段-文字                          */
fcdud03     varchar2(40),            /*自订字段-文字                          */
fcdud04     varchar2(40),            /*自订字段-文字                          */
fcdud05     varchar2(40),            /*自订字段-文字                          */
fcdud06     varchar2(40),            /*自订字段-文字                          */
fcdud07     number(15,3),            /*自订字段-数值                          */
fcdud08     number(15,3),            /*自订字段-数值                          */
fcdud09     number(15,3),            /*自订字段-数值                          */
fcdud10     number(10),              /*自订字段-整数                          */
fcdud11     number(10),              /*自订字段-整数                          */
fcdud12     number(10),              /*自订字段-整数                          */
fcdud13     date,                    /*自订字段-日期                          */
fcdud14     date,                    /*自订字段-日期                          */
fcdud15     date,                    /*自订字段-日期                          */
fcdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fcdorig     varchar2(10),            /*资料建立部门                           */
fcdoriu     varchar2(10)             /*资料建立者                             */
);

alter table fcd_file add  constraint fcd_pk primary key  (fcd01) enable validate;
grant select on fcd_file to tiptopgp;
grant update on fcd_file to tiptopgp;
grant delete on fcd_file to tiptopgp;
grant insert on fcd_file to tiptopgp;
grant index on fcd_file to public;
grant select on fcd_file to ods;
