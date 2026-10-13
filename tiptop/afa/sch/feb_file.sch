/*
================================================================================
檔案代號:feb_file
檔案名稱:模具资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table feb_file
(
feb01       varchar2(20),            /*模具类型                               */
feb02       varchar2(12) NOT NULL,   /*模具编号                               */
feb03       date,                    /*开模日期                               */
feb04       varchar2(20),            /*财产编号                               */
feb05       varchar2(4),             /*附碼                                   */
feb06       number(15,3),            /*数量                                   */
feb07       number(10),              /*模具壽命(次)                           */
feb08       varchar2(10),            /*开模厂商                               */
feb09       number(10),              /*已使用次數                             */
feb10       number(20,6),            /*模具成本                               */
feb11       number(20,6),            /*冲模费用 NTD/次                        */
feb12       number(5),               /*在外數                                 */
feb13       number(5),               /*穴數                                   */
febud01     varchar2(255),           /*自订字段-Textedit                      */
febud02     varchar2(40),            /*自订字段-文字                          */
febud03     varchar2(40),            /*自订字段-文字                          */
febud04     varchar2(40),            /*自订字段-文字                          */
febud05     varchar2(40),            /*自订字段-文字                          */
febud06     varchar2(40),            /*自订字段-文字                          */
febud07     number(15,3),            /*自订字段-数值                          */
febud08     number(15,3),            /*自订字段-数值                          */
febud09     number(15,3),            /*自订字段-数值                          */
febud10     number(10),              /*自订字段-整数                          */
febud11     number(10),              /*自订字段-整数                          */
febud12     number(10),              /*自订字段-整数                          */
febud13     date,                    /*自订字段-日期                          */
febud14     date,                    /*自订字段-日期                          */
febud15     date                     /*自订字段-日期                          */
);

create        index feb_02 on feb_file (feb01);
alter table feb_file add  constraint feb_pk primary key  (feb02) enable validate;
grant select on feb_file to tiptopgp;
grant update on feb_file to tiptopgp;
grant delete on feb_file to tiptopgp;
grant insert on feb_file to tiptopgp;
grant index on feb_file to public;
grant select on feb_file to ods;
