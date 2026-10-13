/*
================================================================================
檔案代號:lnf_file
檔案名稱:正式商戶品牌資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lnf_file
(
lnf00       varchar2(10),            /*来源门店编号                           */
lnf01       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
lnf02       varchar2(20),            /*版本号                                 */
lnf03       varchar2(20) DEFAULT ' ' NOT NULL, /*品牌编号*/
lnf04       varchar2(10)             /*产地编号                               */
);

alter table lnf_file add  constraint lnf_pk primary key  (lnf01,lnf03) enable validate;
grant select on lnf_file to tiptopgp;
grant update on lnf_file to tiptopgp;
grant delete on lnf_file to tiptopgp;
grant insert on lnf_file to tiptopgp;
grant index on lnf_file to public;
grant select on lnf_file to ods;
