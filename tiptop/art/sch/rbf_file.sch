/*
================================================================================
檔案代號:rbf_file
檔案名稱:组合促销变更单身档（一）
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbf_file
(
rbf01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbf02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbf03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbf04       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbf05       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
rbf06       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbf07       varchar2(1) DEFAULT ' ' NOT NULL, /*參與方式*/
rbf08       number(5),               /*数量                                   */
rbfacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
rbflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbfplant    varchar2(10) DEFAULT ' ' NOT NULL /*营运中心编号*/
);

alter table rbf_file add  constraint rbf_pk primary key  (rbf01,rbf02,rbf03,rbf04,rbf05,rbf06,rbfplant) enable validate;
grant select on rbf_file to tiptopgp;
grant update on rbf_file to tiptopgp;
grant delete on rbf_file to tiptopgp;
grant insert on rbf_file to tiptopgp;
grant index on rbf_file to public;
grant select on rbf_file to ods;
