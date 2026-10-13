/*
================================================================================
檔案代號:fea_file
檔案名稱:模具资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fea_file
(
fea01       varchar2(20) NOT NULL,   /*模具类型                               */
fea02       varchar2(80),            /*模具名称                               */
fea031      varchar2(80),            /*模具规格-1                             */
fea032      varchar2(80),            /*模具规格-2                             */
feaconf     varchar2(1),             /*审核否                                 */
feaacti     varchar2(1),             /*资料有效码                             */
feauser     varchar2(10),            /*资料所有者                             */
feagrup     varchar2(10),            /*资料所有部门                           */
feamodu     varchar2(10),            /*资料更改者                             */
feadate     date,                    /*最近更改日                             */
feaud01     varchar2(255),           /*自订字段-Textedit                      */
feaud02     varchar2(40),            /*自订字段-文字                          */
feaud03     varchar2(40),            /*自订字段-文字                          */
feaud04     varchar2(40),            /*自订字段-文字                          */
feaud05     varchar2(40),            /*自订字段-文字                          */
feaud06     varchar2(40),            /*自订字段-文字                          */
feaud07     number(15,3),            /*自订字段-数值                          */
feaud08     number(15,3),            /*自订字段-数值                          */
feaud09     number(15,3),            /*自订字段-数值                          */
feaud10     number(10),              /*自订字段-整数                          */
feaud11     number(10),              /*自订字段-整数                          */
feaud12     number(10),              /*自订字段-整数                          */
feaud13     date,                    /*自订字段-日期                          */
feaud14     date,                    /*自订字段-日期                          */
feaud15     date,                    /*自订字段-日期                          */
feaoriu     varchar2(10),            /*资料建立者                             */
feaorig     varchar2(10)             /*资料建立部门                           */
);

alter table fea_file add  constraint fea_pk primary key  (fea01) enable validate;
grant select on fea_file to tiptopgp;
grant update on fea_file to tiptopgp;
grant delete on fea_file to tiptopgp;
grant insert on fea_file to tiptopgp;
grant index on fea_file to public;
grant select on fea_file to ods;
