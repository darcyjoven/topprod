/*
================================================================================
檔案代號:oax_file
檔案名稱:多角贸易参数设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table oax_file
(
oax00       varchar2(1) NOT NULL,    /*key value                              */
oax01       varchar2(1),             /*多角贸易使用汇率 s/b/c/d               */
oax02       varchar2(1),             /*是否允许订单单价为0                    */
oax03       varchar2(1),             /*出货时单价是否重新计算                 */
oax04       varchar2(1),             /*是否抛转 invoice                       */
oax05       varchar2(1),             /*是否抛转 packing list                  */
oax06       varchar2(1),             /*一单到底                               */
oax07       varchar2(1),             /*是否於單據確認時 自動拋轉              */
oax08       varchar2(1),             /*订单取价方式                           */
oaxud01     varchar2(255),           /*自订字段                               */
oaxud02     varchar2(40),            /*自订字段                               */
oaxud03     varchar2(40),            /*自订字段                               */
oaxud04     varchar2(40),            /*自订字段                               */
oaxud05     varchar2(40),            /*自订字段                               */
oaxud06     varchar2(255),           /*自订字段                               */
oaxud07     number(15,3),            /*自订字段                               */
oaxud08     number(15,3),            /*自订字段                               */
oaxud09     number(15,3),            /*自订字段                               */
oaxud10     number(10),              /*自订字段                               */
oaxud11     number(10),              /*自订字段                               */
oaxud12     number(10),              /*自订字段                               */
oaxud13     date,                    /*自订字段                               */
oaxud14     date,                    /*自订字段                               */
oaxud15     date                     /*自订字段                               */
);

alter table oax_file add  constraint oax_pk primary key  (oax00) enable validate;
grant select on oax_file to tiptopgp;
grant update on oax_file to tiptopgp;
grant delete on oax_file to tiptopgp;
grant insert on oax_file to tiptopgp;
grant index on oax_file to public;
grant select on oax_file to ods;
