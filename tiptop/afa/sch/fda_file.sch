/*
================================================================================
檔案代號:fda_file
檔案名稱:保险单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fda_file
(
fda01       varchar2(20) NOT NULL,   /*保单编号                               */
fda02       varchar2(8),             /*保险公司                               */
fda03       date,                    /*保险期间-起                            */
fda04       date,                    /*保险期间-迄                            */
fda05       number(5),               /*No Use                                 */
fda06       number(5),               /*No Use                                 */
fda07       number(20,6),            /*总保险金额                             */
fda08       number(20,6),            /*总保险费                               */
fda09       number(5),               /*未折金额的年度                         */
fda091      number(5),               /*未折金额的期别                         */
fda10       number(9,4),             /*折扣率                                 */
fda11       number(5,2),             /*No Use                                 */
fda12       varchar2(1),             /*No Use                                 */
fdaconf     varchar2(1),             /*审核否                                 */
fdavoid     varchar2(1),             /*作废码                                 */
fdauser     varchar2(10),            /*资料所有者                             */
fdagrup     varchar2(10),            /*资料所有群                             */
fdamodu     varchar2(10),            /*资料更改者                             */
fdadate     date,                    /*资料更改者                             */
fdaud01     varchar2(255),           /*自订字段-Textedit                      */
fdaud02     varchar2(40),            /*自订字段-文字                          */
fdaud03     varchar2(40),            /*自订字段-文字                          */
fdaud04     varchar2(40),            /*自订字段-文字                          */
fdaud05     varchar2(40),            /*自订字段-文字                          */
fdaud06     varchar2(40),            /*自订字段-文字                          */
fdaud07     number(15,3),            /*自订字段-数值                          */
fdaud08     number(15,3),            /*自订字段-数值                          */
fdaud09     number(15,3),            /*自订字段-数值                          */
fdaud10     number(10),              /*自订字段-整数                          */
fdaud11     number(10),              /*自订字段-整数                          */
fdaud12     number(10),              /*自订字段-整数                          */
fdaud13     date,                    /*自订字段-日期                          */
fdaud14     date,                    /*自订字段-日期                          */
fdaud15     date,                    /*自订字段-日期                          */
fdalegal    varchar2(10) NOT NULL,   /*所属法人                               */
fdaoriu     varchar2(10),            /*资料建立者                             */
fdaorig     varchar2(10)             /*资料建立部门                           */
);

alter table fda_file add  constraint fda_pk primary key  (fda01) enable validate;
grant select on fda_file to tiptopgp;
grant update on fda_file to tiptopgp;
grant delete on fda_file to tiptopgp;
grant insert on fda_file to tiptopgp;
grant index on fda_file to public;
grant select on fda_file to ods;
