/*
================================================================================
檔案代號:coi_file
檔案名稱:进口加签异动单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table coi_file
(
coi01       varchar2(20) NOT NULL,   /*申请编号                               */
coi02       date,                    /*加签日期                               */
coi03       varchar2(20),            /*手册编号                               */
coi04       number(20,6),            /*加签总值                               */
coi05       varchar2(10),            /*海关编号                               */
coi06       varchar2(1),             /*No Use                                 */
coi07       varchar2(1),             /*No Use                                 */
coi08       varchar2(1),             /*No Use                                 */
coi09       varchar2(1),             /*No Use                                 */
coi10       varchar2(1),             /*No Use                                 */
coiconf     varchar2(1),             /*确认码                                 */
coiacti     varchar2(1),             /*资料有效码                             */
coiuser     varchar2(10),            /*资料所有者                             */
coigrup     varchar2(10),            /*资料所有群                             */
coimodu     varchar2(10),            /*资料更改者                             */
coidate     date,                    /*最近更改日                             */
coiud01     varchar2(255),           /*自订字段-Textedit                      */
coiud02     varchar2(40),            /*自订字段-文字                          */
coiud03     varchar2(40),            /*自订字段-文字                          */
coiud04     varchar2(40),            /*自订字段-文字                          */
coiud05     varchar2(40),            /*自订字段-文字                          */
coiud06     varchar2(40),            /*自订字段-文字                          */
coiud07     number(15,3),            /*自订字段-数值                          */
coiud08     number(15,3),            /*自订字段-数值                          */
coiud09     number(15,3),            /*自订字段-数值                          */
coiud10     number(10),              /*自订字段-整数                          */
coiud11     number(10),              /*自订字段-整数                          */
coiud12     number(10),              /*自订字段-整数                          */
coiud13     date,                    /*自订字段-日期                          */
coiud14     date,                    /*自订字段-日期                          */
coiud15     date,                    /*自订字段-日期                          */
coiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coilegal    varchar2(10) NOT NULL,   /*所属法人                               */
coiorig     varchar2(10),            /*资料建立部门                           */
coioriu     varchar2(10)             /*资料建立者                             */
);

alter table coi_file add  constraint coi_pk primary key  (coi01) enable validate;
grant select on coi_file to tiptopgp;
grant update on coi_file to tiptopgp;
grant delete on coi_file to tiptopgp;
grant insert on coi_file to tiptopgp;
grant index on coi_file to public;
grant select on coi_file to ods;
