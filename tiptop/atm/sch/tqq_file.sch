/*
================================================================================
檔案代號:tqq_file
檔案名稱:合同单身客户门店资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqq_file
(
tqq01       varchar2(20) NOT NULL,   /*合约单号                               */
tqq02       number(5),               /*项次                                   */
tqq03       varchar2(10) NOT NULL,   /*门店代码                               */
tqq04       varchar2(10),            /*省别代码                               */
tqq05       varchar2(10),            /*地级市代码                             */
tqq06       varchar2(10),            /*营运中心                               */
tqqud01     varchar2(255),           /*自订字段-Textedit                      */
tqqud02     varchar2(40),            /*自订字段-文字                          */
tqqud03     varchar2(40),            /*自订字段-文字                          */
tqqud04     varchar2(40),            /*自订字段-文字                          */
tqqud05     varchar2(40),            /*自订字段-文字                          */
tqqud06     varchar2(40),            /*自订字段-文字                          */
tqqud07     number(15,3),            /*自订字段-数值                          */
tqqud08     number(15,3),            /*自订字段-数值                          */
tqqud09     number(15,3),            /*自订字段-数值                          */
tqqud10     number(10),              /*自订字段-整数                          */
tqqud11     number(10),              /*自订字段-整数                          */
tqqud12     number(10),              /*自订字段-整数                          */
tqqud13     date,                    /*自订字段-日期                          */
tqqud14     date,                    /*自订字段-日期                          */
tqqud15     date,                    /*自订字段-日期                          */
tqqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index tqq02 on tqq_file (tqq01,tqq02);
alter table tqq_file add  constraint tqq_pk primary key  (tqq01,tqq03) enable validate;
grant select on tqq_file to tiptopgp;
grant update on tqq_file to tiptopgp;
grant delete on tqq_file to tiptopgp;
grant insert on tqq_file to tiptopgp;
grant index on tqq_file to public;
grant select on tqq_file to ods;
