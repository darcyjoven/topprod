/*
================================================================================
檔案代號:cov_file
檔案名稱:进口设备报关明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cov_file
(
cov01       varchar2(30) NOT NULL,   /*预报关单号                             */
cov02       number(5) NOT NULL,      /*项次                                   */
cov03       number(5),               /*备案序号                               */
cov04       varchar2(30),            /*货名及规格                             */
cov05       varchar2(10),            /*原产国                                 */
cov06       number(15,3),            /*数(重)量                               */
cov07       varchar2(4),             /*单位                                   */
cov08       number(20,6),            /*总价                                   */
cov09       varchar2(1),             /*No Use                                 */
cov10       varchar2(1),             /*No Use                                 */
covud01     varchar2(255),           /*自订字段-Textedit                      */
covud02     varchar2(40),            /*自订字段-文字                          */
covud03     varchar2(40),            /*自订字段-文字                          */
covud04     varchar2(40),            /*自订字段-文字                          */
covud05     varchar2(40),            /*自订字段-文字                          */
covud06     varchar2(40),            /*自订字段-文字                          */
covud07     number(15,3),            /*自订字段-数值                          */
covud08     number(15,3),            /*自订字段-数值                          */
covud09     number(15,3),            /*自订字段-数值                          */
covud10     number(10),              /*自订字段-整数                          */
covud11     number(10),              /*自订字段-整数                          */
covud12     number(10),              /*自订字段-整数                          */
covud13     date,                    /*自订字段-日期                          */
covud14     date,                    /*自订字段-日期                          */
covud15     date,                    /*自订字段-日期                          */
covplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
covlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cov_file add  constraint cov_pk primary key  (cov01,cov02) enable validate;
grant select on cov_file to tiptopgp;
grant update on cov_file to tiptopgp;
grant delete on cov_file to tiptopgp;
grant insert on cov_file to tiptopgp;
grant index on cov_file to public;
grant select on cov_file to ods;
