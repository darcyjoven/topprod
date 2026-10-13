/*
================================================================================
檔案代號:skd_file
檔案名稱:制单主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skd_file
(
skd01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单编号*/
skd02       number(10),              /*接单参考件数                           */
skd03       varchar2(80),            /*制单说明                               */
skd04       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
skdacti     varchar2(1),             /*资料有效码                             */
skddate     date,                    /*最近更改日                             */
skdgrup     varchar2(10),            /*资料所属群组                           */
skdmodu     varchar2(10),            /*资料更改者                             */
skduser     varchar2(10),            /*资料所有者                             */
skdud01     varchar2(255),           /*自订字段-Textedit                      */
skdud02     varchar2(40),            /*自订字段-文字                          */
skdud03     varchar2(40),            /*自订字段-文字                          */
skdud04     varchar2(40),            /*自订字段-文字                          */
skdud05     varchar2(40),            /*自订字段-文字                          */
skdud06     varchar2(40),            /*自订字段-文字                          */
skdud07     number(15,3),            /*自订字段-数值                          */
skdud08     number(15,3),            /*自订字段-数值                          */
skdud09     number(15,3),            /*自订字段-数值                          */
skdud10     number(10),              /*自订字段-整数                          */
skdud11     number(10),              /*自订字段-整数                          */
skdud12     number(10),              /*自订字段-整数                          */
skdud13     date,                    /*自订字段-日期                          */
skdud14     date,                    /*自订字段-日期                          */
skdud15     date,                    /*自订字段-日期                          */
skdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
skdoriu     varchar2(10),            /*资料建立者                             */
skdorig     varchar2(10)             /*资料建立部门                           */
);

alter table skd_file add  constraint skd_pk primary key  (skd01) enable validate;
grant select on skd_file to tiptopgp;
grant update on skd_file to tiptopgp;
grant delete on skd_file to tiptopgp;
grant insert on skd_file to tiptopgp;
grant index on skd_file to public;
grant select on skd_file to ods;
