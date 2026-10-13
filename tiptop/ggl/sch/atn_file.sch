/*
================================================================================
檔案代號:atn_file
檔案名稱:股东权益群组表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table atn_file
(
atn01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组编号*/
atn02       varchar2(80),            /*说明                                   */
atn03       varchar2(1),             /*no use                                 */
atn04       varchar2(1),             /*no use                                 */
atn05       varchar2(1),             /*no use                                 */
atn06       varchar2(1),             /*no use                                 */
atn07       varchar2(1),             /*no use                                 */
atn08       varchar2(1)              /*no use                                 */
);

alter table atn_file add  constraint atn_pk primary key  (atn01) enable validate;
grant select on atn_file to tiptopgp;
grant update on atn_file to tiptopgp;
grant delete on atn_file to tiptopgp;
grant insert on atn_file to tiptopgp;
grant index on atn_file to public;
grant select on atn_file to ods;
