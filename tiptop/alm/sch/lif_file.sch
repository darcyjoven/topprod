/*
================================================================================
檔案代號:lif_file
檔案名稱:商户预登记资料单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lif_file
(
lif01       varchar2(20) DEFAULT ' ' NOT NULL, /*预登记单号*/
lif02       varchar2(10) DEFAULT ' ' NOT NULL, /*意向品牌*/
lif03       varchar2(255),           /*备注                                   */
lifacti     varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

alter table lif_file add  constraint lif_pk primary key  (lif01,lif02) enable validate;
grant select on lif_file to tiptopgp;
grant update on lif_file to tiptopgp;
grant delete on lif_file to tiptopgp;
grant insert on lif_file to tiptopgp;
grant index on lif_file to public;
grant select on lif_file to ods;
