/*
================================================================================
檔案代號:obf_file
檔案名稱:产品价格单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obf_file
(
obf01       varchar2(10) NOT NULL,   /*产品分类                               */
                                     /*產品分類     (必須輸入分類編號或'*')   */
obf02       varchar2(40) NOT NULL    /*产品编号                               */
                                     /*產品編號     (必須輸入產品編號或'*')   */
);

alter table obf_file add  constraint obf_pk primary key  (obf01,obf02) enable validate;
grant select on obf_file to tiptopgp;
grant update on obf_file to tiptopgp;
grant delete on obf_file to tiptopgp;
grant insert on obf_file to tiptopgp;
grant index on obf_file to public;
grant select on obf_file to ods;
