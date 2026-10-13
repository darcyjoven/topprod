/*
================================================================================
檔案代號:ska_file
檔案名稱:预包装档
檔案目的:预包装单头档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ska_file
(
ska01       varchar2(20) DEFAULT ' ' NOT NULL, /*预包装单号*/
ska02       date DEFAULT sysdate NOT NULL, /*单据日期*/
ska03       varchar2(20) DEFAULT ' ' NOT NULL, /*订单编号*/
ska04       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
ska05       varchar2(80) DEFAULT ' ' NOT NULL, /*备注*/
skaacti     varchar2(1),             /*资料有效码                             */
skadate     date,                    /*最近更改日                             */
skagrup     varchar2(10),            /*资料所属群组                           */
skamodu     varchar2(10),            /*资料更改者                             */
skauser     varchar2(10),            /*资料所有者                             */
skaud01     varchar2(255),           /*自订字段-Textedit                      */
skaud02     varchar2(40),            /*自订字段-文字                          */
skaud03     varchar2(40),            /*自订字段-文字                          */
skaud04     varchar2(40),            /*自订字段-文字                          */
skaud05     varchar2(40),            /*自订字段-文字                          */
skaud06     varchar2(40),            /*自订字段-文字                          */
skaud07     number(15,3),            /*自订字段-数值                          */
skaud08     number(15,3),            /*自订字段-数值                          */
skaud09     number(15,3),            /*自订字段-数值                          */
skaud10     number(10),              /*自订字段-整数                          */
skaud11     number(10),              /*自订字段-整数                          */
skaud12     number(10),              /*自订字段-整数                          */
skaud13     date,                    /*自订字段-日期                          */
skaud14     date,                    /*自订字段-日期                          */
skaud15     date,                    /*自订字段-日期                          */
skaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skalegal    varchar2(10) NOT NULL,   /*所属法人                               */
skaorig     varchar2(10),            /*资料建立部门                           */
skaoriu     varchar2(10)             /*资料建立者                             */
);

alter table ska_file add  constraint ska_pk primary key  (ska01) enable validate;
grant select on ska_file to tiptopgp;
grant update on ska_file to tiptopgp;
grant delete on ska_file to tiptopgp;
grant insert on ska_file to tiptopgp;
grant index on ska_file to public;
grant select on ska_file to ods;
