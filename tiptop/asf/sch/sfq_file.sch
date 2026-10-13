/*
================================================================================
檔案代號:sfq_file
檔案名稱:工单发料底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfq_file
(
sfq01       varchar2(20) NOT NULL,   /*发料单号                               */
                                     /*發料單號 sfp01                         */
sfq02       varchar2(40) NOT NULL,   /*工单单号                               */
                                     /*W/O No. sfb01                          */
                                     /* (ASR-This Field Is Item #(asri210,asri220) )*/
sfq03       number(15,3),            /*发料套数                               */
                                     /*發料套數 2005/03/28 modify type numfor(10)->number(15,3)*/
sfq04       varchar2(10) NOT NULL,   /*作业编号                               */
                                     /*作業編號                               */
sfq05       date NOT NULL,           /*计划日期                               */
sfq06       number(5),               /*No Use                                 */
sfqud01     varchar2(255),           /*自订字段-Textedit                      */
sfqud02     varchar2(40),            /*自订字段-文字                          */
sfqud03     varchar2(40),            /*自订字段-文字                          */
sfqud04     varchar2(40),            /*自订字段-文字                          */
sfqud05     varchar2(40),            /*自订字段-文字                          */
sfqud06     varchar2(40),            /*自订字段-文字                          */
sfqud07     number(15,3),            /*自订字段-数值                          */
sfqud08     number(15,3),            /*自订字段-数值                          */
sfqud09     number(15,3),            /*自订字段-数值                          */
sfqud10     number(10),              /*自订字段-整数                          */
sfqud11     number(10),              /*自订字段-整数                          */
sfqud12     number(10),              /*自订字段-整数                          */
sfqud13     date,                    /*自订字段-日期                          */
sfqud14     date,                    /*自订字段-日期                          */
sfqud15     date,                    /*自订字段-日期                          */
sfq07       varchar2(20),            /*特性代码                               */
sfq08       number(15,3),            /*计划发料套数                           */
sfqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfq012      varchar2(10) DEFAULT ' ' NOT NULL, /*制程段号*/
sfq014      varchar2(23) DEFAULT ' ' NOT NULL /*Run Card*/
);

create        index sfq_02 on sfq_file (sfq02);
alter table sfq_file add  constraint sfq_pk primary key  (sfq01,sfq02,sfq04,sfq05,sfq012,sfq014) enable validate;
grant select on sfq_file to tiptopgp;
grant update on sfq_file to tiptopgp;
grant delete on sfq_file to tiptopgp;
grant insert on sfq_file to tiptopgp;
grant index on sfq_file to public;
grant select on sfq_file to ods;
