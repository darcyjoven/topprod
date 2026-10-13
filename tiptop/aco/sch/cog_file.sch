/*
================================================================================
檔案代號:cog_file
檔案名稱:出口加签异动单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cog_file
(
cog01       varchar2(20) NOT NULL,   /*申请编号                               */
cog02       date,                    /*加签日期                               */
cog03       varchar2(20),            /*手册编号                               */
cog04       number(20,6),            /*加签总值                               */
cog05       varchar2(10),            /*海关编号                               */
cog06       varchar2(1),             /*No Use                                 */
cog07       varchar2(1),             /*No Use                                 */
cog08       varchar2(1),             /*No Use                                 */
cog09       varchar2(1),             /*No Use                                 */
cog10       varchar2(1),             /*No Use                                 */
cogconf     varchar2(1),             /*确认码                                 */
cogacti     varchar2(1),             /*资料有效码                             */
coguser     varchar2(10),            /*资料所有者                             */
coggrup     varchar2(10),            /*资料所有群                             */
cogmodu     varchar2(10),            /*资料更改者                             */
cogdate     date,                    /*最近更改日                             */
cogud01     varchar2(255),           /*自订字段-Textedit                      */
cogud02     varchar2(40),            /*自订字段-文字                          */
cogud03     varchar2(40),            /*自订字段-文字                          */
cogud04     varchar2(40),            /*自订字段-文字                          */
cogud05     varchar2(40),            /*自订字段-文字                          */
cogud06     varchar2(40),            /*自订字段-文字                          */
cogud07     number(15,3),            /*自订字段-数值                          */
cogud08     number(15,3),            /*自订字段-数值                          */
cogud09     number(15,3),            /*自订字段-数值                          */
cogud10     number(10),              /*自订字段-整数                          */
cogud11     number(10),              /*自订字段-整数                          */
cogud12     number(10),              /*自订字段-整数                          */
cogud13     date,                    /*自订字段-日期                          */
cogud14     date,                    /*自订字段-日期                          */
cogud15     date,                    /*自订字段-日期                          */
cogplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coglegal    varchar2(10) NOT NULL,   /*所属法人                               */
cogorig     varchar2(10),            /*资料建立部门                           */
cogoriu     varchar2(10)             /*资料建立者                             */
);

alter table cog_file add  constraint cog_pk primary key  (cog01) enable validate;
grant select on cog_file to tiptopgp;
grant update on cog_file to tiptopgp;
grant delete on cog_file to tiptopgp;
grant insert on cog_file to tiptopgp;
grant index on cog_file to public;
grant select on cog_file to ods;
