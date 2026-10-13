/*
================================================================================
檔案代號:cox_file
檔案名稱:免税进口设备出口报关明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cox_file
(
cox01       varchar2(30) NOT NULL,   /*预报关单号                             */
cox02       number(5) NOT NULL,      /*项次                                   */
cox03       number(5),               /*备案序号                               */
cox04       varchar2(30),            /*货名及规格                             */
cox05       varchar2(10),            /*原产国                                 */
cox06       number(15,3),            /*数(重)量                               */
cox07       varchar2(4),             /*单位                                   */
cox08       number(20,6),            /*总价                                   */
cox09       varchar2(1),             /*No Use                                 */
cox10       varchar2(1),             /*No Use                                 */
coxud01     varchar2(255),           /*自订字段-Textedit                      */
coxud02     varchar2(40),            /*自订字段-文字                          */
coxud03     varchar2(40),            /*自订字段-文字                          */
coxud04     varchar2(40),            /*自订字段-文字                          */
coxud05     varchar2(40),            /*自订字段-文字                          */
coxud06     varchar2(40),            /*自订字段-文字                          */
coxud07     number(15,3),            /*自订字段-数值                          */
coxud08     number(15,3),            /*自订字段-数值                          */
coxud09     number(15,3),            /*自订字段-数值                          */
coxud10     number(10),              /*自订字段-整数                          */
coxud11     number(10),              /*自订字段-整数                          */
coxud12     number(10),              /*自订字段-整数                          */
coxud13     date,                    /*自订字段-日期                          */
coxud14     date,                    /*自订字段-日期                          */
coxud15     date,                    /*自订字段-日期                          */
coxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cox_file add  constraint cox_pk primary key  (cox01,cox02) enable validate;
grant select on cox_file to tiptopgp;
grant update on cox_file to tiptopgp;
grant delete on cox_file to tiptopgp;
grant insert on cox_file to tiptopgp;
grant index on cox_file to public;
grant select on cox_file to ods;
