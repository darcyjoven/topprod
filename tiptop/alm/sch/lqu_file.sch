/*
================================================================================
檔案代號:lqu_file
檔案名稱:会员卡资讯重计变更单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqu_file
(
lqu01       varchar2(20) DEFAULT ' ' NOT NULL, /*卡资讯变更单号*/
lqu02       date,                    /*变更日期                               */
lqu03       varchar2(10),            /*变更理由                               */
lqu04       varchar2(10),            /*变更人员                               */
lqu05       varchar2(1) DEFAULT '0' NOT NULL, /*状况*/
lquacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
lqucond     date,                    /*审核日期                               */
lquconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
lquconu     varchar2(10),            /*审核人员                               */
lqudate     date,                    /*最近更改日                             */
lqugrup     varchar2(10),            /*资料所有群                             */
lqulegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lqumodu     varchar2(10),            /*资料更改者                             */
lquorig     varchar2(10),            /*资料建立部门                           */
lquoriu     varchar2(10),            /*资料建立者                             */
lquplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lquud01     varchar2(255),           /*自订字段-Textedit                      */
lquud02     varchar2(40),            /*自订字段-文字                          */
lquud03     varchar2(40),            /*自订字段-文字                          */
lquud04     varchar2(40),            /*自订字段-文字                          */
lquud05     varchar2(40),            /*自订字段-文字                          */
lquud06     varchar2(40),            /*自订字段-文字                          */
lquud07     number(15,3),            /*自订字段-数值                          */
lquud08     number(15,3),            /*自订字段-数值                          */
lquud09     number(15,3),            /*自订字段-数值                          */
lquud10     number(10),              /*自订字段-整数                          */
lquud11     number(10),              /*自订字段-整数                          */
lquud12     number(10),              /*自订字段-整数                          */
lquud13     date,                    /*自订字段-日期                          */
lquud14     date,                    /*自订字段-日期                          */
lquud15     date,                    /*自订字段-日期                          */
lquuser     varchar2(10)             /*资料所有者                             */
);

alter table lqu_file add  constraint lqu_pk primary key  (lqu01) enable validate;
grant select on lqu_file to tiptopgp;
grant update on lqu_file to tiptopgp;
grant delete on lqu_file to tiptopgp;
grant insert on lqu_file to tiptopgp;
grant index on lqu_file to public;
grant select on lqu_file to ods;
