/*
================================================================================
檔案代號:odd_file
檔案名稱:集团销售预测资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odd_file
(
odd01       varchar2(10) NOT NULL,   /*预测版本                               */
odd02       varchar2(10) NOT NULL,   /*组织编号                               */
odd03       number(5) NOT NULL,      /*序号                                   */
odd04       varchar2(40),            /*预测料号                               */
odd05       varchar2(8),             /*No Use                                 */
odd06       varchar2(6),             /*No Use                                 */
odd07       varchar2(120),           /*品名                                   */
odd08       varchar2(120),           /*规格                                   */
odd09       varchar2(4),             /*销售单位                               */
odd14       number(15,3),            /*No Use                                 */
odd15       number(15,3),            /*No Use                                 */
odd16       number(15,3),            /*No Use                                 */
odd17       number(15,3),            /*No Use                                 */
odd18       number(20,6),            /*No Use                                 */
odd19       number(20,6),            /*No Use                                 */
odd20       number(20,6),            /*No Use                                 */
odd21       number(20,6),            /*No Use                                 */
odd22       number(15,3),            /*No Use                                 */
odd23       number(20,6),            /*No Use                                 */
odd25       number(15,3),            /*No Use                                 */
odd26       number(20,6),            /*No Use                                 */
oddud01     varchar2(255),           /*自订字段-Textedit                      */
oddud02     varchar2(40),            /*自订字段-文字                          */
oddud03     varchar2(40),            /*自订字段-文字                          */
oddud04     varchar2(40),            /*自订字段-文字                          */
oddud05     varchar2(40),            /*自订字段-文字                          */
oddud06     varchar2(40),            /*自订字段-文字                          */
oddud07     number(15,3),            /*自订字段-数值                          */
oddud08     number(15,3),            /*自订字段-数值                          */
oddud09     number(15,3),            /*自订字段-数值                          */
oddud10     number(10),              /*自订字段-整数                          */
oddud11     number(10),              /*自订字段-整数                          */
oddud12     number(10),              /*自订字段-整数                          */
oddud13     date,                    /*自订字段-日期                          */
oddud14     date,                    /*自订字段-日期                          */
oddud15     date                     /*自订字段-日期                          */
);

alter table odd_file add  constraint odd_pk primary key  (odd01,odd02,odd03) enable validate;
grant select on odd_file to tiptopgp;
grant update on odd_file to tiptopgp;
grant delete on odd_file to tiptopgp;
grant insert on odd_file to tiptopgp;
grant index on odd_file to public;
grant select on odd_file to ods;
