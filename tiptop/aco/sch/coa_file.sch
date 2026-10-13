/*
================================================================================
檔案代號:coa_file
檔案名稱:料件与海关商品编号对应
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table coa_file
(
coa01       varchar2(40) NOT NULL,   /*料件编号                               */
coa02       number(5) NOT NULL,      /*行序                                   */
coa03       varchar2(40) NOT NULL,   /*商品编号                               */
coa04       number(20,8),            /*料号/商品编号转换率                    */
coa05       varchar2(10),            /*海关编号                               */
coa06       varchar2(1),             /*No Use                                 */
coa07       varchar2(1),             /*No Use                                 */
coaacti     varchar2(1),             /*资料有效码                             */
coauser     varchar2(10),            /*资料所有者                             */
coagrup     varchar2(10),            /*资料所有部门                           */
coamodu     varchar2(10),            /*资料更改者                             */
coadate     date,                    /*最近更改日                             */
coaud01     varchar2(255),           /*自订字段-Textedit                      */
coaud02     varchar2(40),            /*自订字段-文字                          */
coaud03     varchar2(40),            /*自订字段-文字                          */
coaud04     varchar2(40),            /*自订字段-文字                          */
coaud05     varchar2(40),            /*自订字段-文字                          */
coaud06     varchar2(40),            /*自订字段-文字                          */
coaud07     number(15,3),            /*自订字段-数值                          */
coaud08     number(15,3),            /*自订字段-数值                          */
coaud09     number(15,3),            /*自订字段-数值                          */
coaud10     number(10),              /*自订字段-整数                          */
coaud11     number(10),              /*自订字段-整数                          */
coaud12     number(10),              /*自订字段-整数                          */
coaud13     date,                    /*自订字段-日期                          */
coaud14     date,                    /*自订字段-日期                          */
coaud15     date,                    /*自订字段-日期                          */
coaorig     varchar2(10),            /*资料建立部门                           */
coaoriu     varchar2(10)             /*资料建立者                             */
);

create unique index coa_02 on coa_file (coa01,coa03,coa05);
alter table coa_file add  constraint coa_pk primary key  (coa01,coa02) enable validate;
grant select on coa_file to tiptopgp;
grant update on coa_file to tiptopgp;
grant delete on coa_file to tiptopgp;
grant insert on coa_file to tiptopgp;
grant index on coa_file to public;
grant select on coa_file to ods;
