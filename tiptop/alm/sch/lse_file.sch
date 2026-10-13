/*
================================================================================
檔案代號:lse_file
檔案名稱:竞争对手资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lse_file
(
lse01       varchar2(10) DEFAULT ' ' NOT NULL, /*竞争对手编码*/
lse02       varchar2(30),            /*竞争对手名称                           */
lse03       varchar2(50),            /*备注                                   */
lse04       varchar2(1)              /*有效否                                 */
);

alter table lse_file add  constraint lse_pk primary key  (lse01) enable validate;
grant select on lse_file to tiptopgp;
grant update on lse_file to tiptopgp;
grant delete on lse_file to tiptopgp;
grant insert on lse_file to tiptopgp;
grant index on lse_file to public;
grant select on lse_file to ods;
