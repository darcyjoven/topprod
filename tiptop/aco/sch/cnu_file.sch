/*
================================================================================
檔案代號:cnu_file
檔案名稱:内销申请单头档(A087)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cnu_file
(
cnu01       varchar2(20) NOT NULL,   /*申请编号                               */
cnu02       date,                    /*单据日期                               */
cnu03       varchar2(12),            /*申请表编号                             */
cnu04       varchar2(1),             /*内销类型                               */
cnu05       varchar2(20),            /*手册编号                               */
cnu06       varchar2(4),             /*币种                                   */
cnu07       varchar2(10),            /*海关编号                               */
cnu08       varchar2(1),             /*No Use                                 */
cnu09       varchar2(1),             /*No Use                                 */
cnuconf     varchar2(1),             /*确认码                                 */
cnuacti     varchar2(1),             /*资料有效码                             */
cnuuser     varchar2(10),            /*资料所有者                             */
cnugrup     varchar2(10),            /*资料所有部门                           */
cnumodu     varchar2(10),            /*资料更改者                             */
cnudate     date,                    /*最近更改日                             */
cnuud01     varchar2(255),           /*自订字段-Textedit                      */
cnuud02     varchar2(40),            /*自订字段-文字                          */
cnuud03     varchar2(40),            /*自订字段-文字                          */
cnuud04     varchar2(40),            /*自订字段-文字                          */
cnuud05     varchar2(40),            /*自订字段-文字                          */
cnuud06     varchar2(40),            /*自订字段-文字                          */
cnuud07     number(15,3),            /*自订字段-数值                          */
cnuud08     number(15,3),            /*自订字段-数值                          */
cnuud09     number(15,3),            /*自订字段-数值                          */
cnuud10     number(10),              /*自订字段-整数                          */
cnuud11     number(10),              /*自订字段-整数                          */
cnuud12     number(10),              /*自订字段-整数                          */
cnuud13     date,                    /*自订字段-日期                          */
cnuud14     date,                    /*自订字段-日期                          */
cnuud15     date,                    /*自订字段-日期                          */
cnuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnulegal    varchar2(10) NOT NULL,   /*所属法人                               */
cnuorig     varchar2(10),            /*资料建立部门                           */
cnuoriu     varchar2(10)             /*资料建立者                             */
);

alter table cnu_file add  constraint cnu_pk primary key  (cnu01) enable validate;
grant select on cnu_file to tiptopgp;
grant update on cnu_file to tiptopgp;
grant delete on cnu_file to tiptopgp;
grant insert on cnu_file to tiptopgp;
grant index on cnu_file to public;
grant select on cnu_file to ods;
