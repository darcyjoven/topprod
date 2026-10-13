/*
================================================================================
檔案代號:srl_file
檔案名稱:产品投入工时单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table srl_file
(
srl01       date NOT NULL,           /*日期                                   */
srl02       varchar2(10) NOT NULL,   /*成本中心                               */
srl03       number(5) NOT NULL,      /*序号                                   */
srl04       varchar2(40) NOT NULL,   /*产品编号                               */
srl05       number(15,3) NOT NULL,   /*投入工时                               */
srl06       number(15,3),            /*生产数量                               */
srl07       number(15,3),            /*No Use                                 */
srl08       varchar2(255),           /*备注                                   */
srlud01     varchar2(255),           /*自订字段-Textedit                      */
srlud02     varchar2(40),            /*自订字段-文字                          */
srlud03     varchar2(40),            /*自订字段-文字                          */
srlud04     varchar2(40),            /*自订字段-文字                          */
srlud05     varchar2(40),            /*自订字段-文字                          */
srlud06     varchar2(40),            /*自订字段-文字                          */
srlud07     number(15,3),            /*自订字段-数值                          */
srlud08     number(15,3),            /*自订字段-数值                          */
srlud09     number(15,3),            /*自订字段-数值                          */
srlud10     number(10),              /*自订字段-整数                          */
srlud11     number(10),              /*自订字段-整数                          */
srlud12     number(10),              /*自订字段-整数                          */
srlud13     date,                    /*自订字段-日期                          */
srlud14     date,                    /*自订字段-日期                          */
srlud15     date,                    /*自订字段-日期                          */
srl09       number(15,3)             /*投入机时                               */
);

create        index srl_02 on srl_file (srl04);
alter table srl_file add  constraint srl_pk primary key  (srl01,srl02,srl03) enable validate;
grant select on srl_file to tiptopgp;
grant update on srl_file to tiptopgp;
grant delete on srl_file to tiptopgp;
grant insert on srl_file to tiptopgp;
grant index on srl_file to public;
grant select on srl_file to ods;
