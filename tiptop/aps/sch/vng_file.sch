/*
================================================================================
檔案代號:vng_file
檔案名稱:aps 制程外包维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vng_file
(
vng01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vng02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vng03       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vng04       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vng06       number(1),               /*外包类型                               */
vng07       date,                    /*开始时间(日期)                         */
vng08       date,                    /*结束时间(日期)                         */
vng10       number(1),               /*排程                                   */
vng11       number(9)                /*外包商序号                             */
);

alter table vng_file add  constraint vng_pk primary key  (vng01,vng02,vng03,vng04) enable validate;
grant select on vng_file to tiptopgp;
grant update on vng_file to tiptopgp;
grant delete on vng_file to tiptopgp;
grant insert on vng_file to tiptopgp;
grant index on vng_file to public;
grant select on vng_file to ods;
