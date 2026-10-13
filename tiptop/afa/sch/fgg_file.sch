/*
================================================================================
檔案代號:fgg_file
檔案名稱:量测仪器校验异动维护单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fgg_file
(
fgg01       varchar2(10) NOT NULL,   /*校验编号                               */
fgg02       number(5) NOT NULL,      /*项次                                   */
fgg03       varchar2(15),            /*仪器编号                               */
fgg04       date,                    /*校验日期                               */
fgg05       varchar2(10),            /*校验人员                               */
fgg06       varchar2(10),            /*不良原因                               */
fgg07       varchar2(1),             /*校验结果                               */
fgg08       date,                    /*下次校验日期                           */
fggacti     varchar2(1),             /*资料有效码                             */
fgguser     varchar2(10),            /*资料所有者                             */
fgggrup     varchar2(10),            /*资料所有群                             */
fggmodu     varchar2(10),            /*资料更改者                             */
fggdate     date,                    /*最近更改日                             */
fggud01     varchar2(255),           /*自订字段-Textedit                      */
fggud02     varchar2(40),            /*自订字段-文字                          */
fggud03     varchar2(40),            /*自订字段-文字                          */
fggud04     varchar2(40),            /*自订字段-文字                          */
fggud05     varchar2(40),            /*自订字段-文字                          */
fggud06     varchar2(40),            /*自订字段-文字                          */
fggud07     number(15,3),            /*自订字段-数值                          */
fggud08     number(15,3),            /*自订字段-数值                          */
fggud09     number(15,3),            /*自订字段-数值                          */
fggud10     number(10),              /*自订字段-整数                          */
fggud11     number(10),              /*自订字段-整数                          */
fggud12     number(10),              /*自订字段-整数                          */
fggud13     date,                    /*自订字段-日期                          */
fggud14     date,                    /*自订字段-日期                          */
fggud15     date,                    /*自订字段-日期                          */
fgglegal    varchar2(10) NOT NULL,   /*所属法人                               */
fggorig     varchar2(10),            /*资料建立部门                           */
fggoriu     varchar2(10)             /*资料建立者                             */
);

alter table fgg_file add  constraint fgg_pk primary key  (fgg01,fgg02) enable validate;
grant select on fgg_file to tiptopgp;
grant update on fgg_file to tiptopgp;
grant delete on fgg_file to tiptopgp;
grant insert on fgg_file to tiptopgp;
grant index on fgg_file to public;
grant select on fgg_file to ods;
