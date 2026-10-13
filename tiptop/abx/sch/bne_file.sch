/*
================================================================================
檔案代號:bne_file
檔案名稱:保税产品结构资料单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bne_file
(
bne01       varchar2(40) NOT NULL,   /*主件料号                               */
bne02       date NOT NULL,           /*生效日期                               */
bne03       number(5) NOT NULL,      /*项次                                   */
bne05       varchar2(40) NOT NULL,   /*料件编号                               */
bne06       date,                    /*生效日期                               */
bne07       date,                    /*失效日期                               */
bne08       number(16,8),            /*组成用量                               */
bne09       varchar2(1),             /*有效否                                 */
bne10       number(16,8),            /*实用数                                 */
bne11       number(16,8),            /*损耗数                                 */
bneud01     varchar2(255),           /*自订字段-Textedit                      */
bneud02     varchar2(40),            /*自订字段-文字                          */
bneud03     varchar2(40),            /*自订字段-文字                          */
bneud04     varchar2(40),            /*自订字段-文字                          */
bneud05     varchar2(40),            /*自订字段-文字                          */
bneud06     varchar2(40),            /*自订字段-文字                          */
bneud07     number(15,3),            /*自订字段-数值                          */
bneud08     number(15,3),            /*自订字段-数值                          */
bneud09     number(15,3),            /*自订字段-数值                          */
bneud10     number(10),              /*自订字段-整数                          */
bneud11     number(10),              /*自订字段-整数                          */
bneud12     number(10),              /*自订字段-整数                          */
bneud13     date,                    /*自订字段-日期                          */
bneud14     date,                    /*自订字段-日期                          */
bneud15     date                     /*自订字段-日期                          */
);

alter table bne_file add  constraint bne_pk primary key  (bne01,bne02,bne03,bne05) enable validate;
grant select on bne_file to tiptopgp;
grant update on bne_file to tiptopgp;
grant delete on bne_file to tiptopgp;
grant insert on bne_file to tiptopgp;
grant index on bne_file to public;
grant select on bne_file to ods;
