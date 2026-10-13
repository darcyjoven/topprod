/*
================================================================================
檔案代號:oca_file
檔案名稱:客户分类档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oca_file
(
oca01       varchar2(10) NOT NULL,   /*客户分类码                             */
                                     /*客戶分類碼                             */
oca02       varchar2(80),            /*客户分类名称                           */
                                     /*客戶分類名稱                           */
oca03       varchar2(24),            /*应收帐款科目编号                       */
                                     /*應收帳款科目編號                       */
oca04       varchar2(24)             /*应收帐款科目二                         */
);

alter table oca_file add  constraint oca_pk primary key  (oca01) enable validate;
grant select on oca_file to tiptopgp;
grant update on oca_file to tiptopgp;
grant delete on oca_file to tiptopgp;
grant insert on oca_file to tiptopgp;
grant index on oca_file to public;
grant select on oca_file to ods;
