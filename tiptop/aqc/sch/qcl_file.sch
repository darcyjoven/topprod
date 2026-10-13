/*
================================================================================
檔案代號:qcl_file
檔案名稱:QC判定结果编码资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qcl_file
(
qcl01       varchar2(10) DEFAULT ' ' NOT NULL, /*判定结果编码*/
qcl02       varchar2(80),            /*结果说明                               */
qcl03       varchar2(1) DEFAULT ' ' NOT NULL, /*是否为可用仓位*/
qcl04       varchar2(1) DEFAULT ' ' NOT NULL, /*是否为MRP可用仓储*/
qcl05       varchar2(1) DEFAULT ' ' NOT NULL, /*性质*/
qcl06       varchar2(10),            /*缺省仓库                               */
qcl07       varchar2(10)             /*缺省库位                               */
);

alter table qcl_file add  constraint qcl_pk primary key  (qcl01) enable validate;
grant select on qcl_file to tiptopgp;
grant update on qcl_file to tiptopgp;
grant delete on qcl_file to tiptopgp;
grant insert on qcl_file to tiptopgp;
grant index on qcl_file to public;
grant select on qcl_file to ods;
