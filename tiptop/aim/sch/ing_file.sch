/*
================================================================================
檔案代號:ing_file
檔案名稱:料件批序号开账单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ing_file
(
ing01       varchar2(20) DEFAULT ' ' NOT NULL, /*开账单号*/
ing02       date,                    /*开账日期                               */
ing03       varchar2(40),            /*料件编号                               */
ing04       varchar2(10),            /*仓库                                   */
ing05       varchar2(10),            /*库位                                   */
ing06       varchar2(24),            /*批号                                   */
ingconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
ingdate     date,                    /*最近更改日                             */
inggrup     varchar2(10),            /*资料所有群                             */
inglegal    varchar2(10) NOT NULL,   /*所属法人                               */
ingmodu     varchar2(10),            /*资料更改者                             */
ingorig     varchar2(10),            /*资料建立部门                           */
ingoriu     varchar2(10),            /*资料建立者                             */
ingplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
ingpost     varchar2(1) DEFAULT ' ' NOT NULL, /*过帐码*/
ingud01     varchar2(255),           /*自订字段-Textedit                      */
ingud02     varchar2(40),            /*自订字段-文字                          */
ingud03     varchar2(40),            /*自订字段-文字                          */
ingud04     varchar2(40),            /*自订字段-文字                          */
ingud05     varchar2(40),            /*自订字段-文字                          */
ingud06     varchar2(40),            /*自订字段-文字                          */
ingud07     number(15,3),            /*自订字段-数值                          */
ingud08     number(15,3),            /*自订字段-数值                          */
ingud09     number(15,3),            /*自订字段-数值                          */
ingud10     number(10),              /*自订字段-整数                          */
ingud11     number(10),              /*自订字段-整数                          */
ingud12     number(10),              /*自订字段-整数                          */
ingud13     date,                    /*自订字段-日期                          */
ingud14     date,                    /*自订字段-日期                          */
ingud15     date,                    /*自订字段-日期                          */
inguser     varchar2(10)             /*资料所有者                             */
);

alter table ing_file add  constraint ing_pk primary key  (ing01) enable validate;
grant select on ing_file to tiptopgp;
grant update on ing_file to tiptopgp;
grant delete on ing_file to tiptopgp;
grant insert on ing_file to tiptopgp;
grant index on ing_file to public;
grant select on ing_file to ods;
