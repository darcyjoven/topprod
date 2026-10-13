/*
================================================================================
檔案代號:ato_file
檔案名稱:股东权益群组对应会计科目表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ato_file
(
ato01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组编号*/
ato02       varchar2(24) DEFAULT ' ' NOT NULL, /*会计科目*/
ato03       varchar2(1),             /*no use                                 */
ato04       varchar2(255)            /*no use                                 */
);

alter table ato_file add  constraint ato_pk primary key  (ato01,ato02) enable validate;
grant select on ato_file to tiptopgp;
grant update on ato_file to tiptopgp;
grant delete on ato_file to tiptopgp;
grant insert on ato_file to tiptopgp;
grant index on ato_file to public;
grant select on ato_file to ods;
