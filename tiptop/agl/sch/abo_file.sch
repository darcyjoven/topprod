/*
================================================================================
檔案代號:abo_file
檔案名稱:財務指標取數設置維護檔
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table abo_file
(
abo00       varchar2(5) DEFAULT ' ' NOT NULL, /*帳別*/
abo01       varchar2(5) DEFAULT ' ' NOT NULL, /*變量代碼*/
abo02       varchar2(255),           /*變量名稱                               */
abo03       varchar2(1) DEFAULT ' ' NOT NULL, /*正常餘額形態*/
abo04       varchar2(24),            /*起始科目編號                           */
abo05       varchar2(24),            /*截至科目編號                           */
abo06       varchar2(1) DEFAULT ' ' NOT NULL, /*金額來源*/
abo07       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
abo08       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
abo09       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
abo10       varchar2(1) DEFAULT ' ' NOT NULL /*No Use*/
);

alter table abo_file add  constraint abo_pk primary key  (abo00,abo01) enable validate;
grant select on abo_file to tiptopgp;
grant update on abo_file to tiptopgp;
grant delete on abo_file to tiptopgp;
grant insert on abo_file to tiptopgp;
grant index on abo_file to public;
grant select on abo_file to ods;
