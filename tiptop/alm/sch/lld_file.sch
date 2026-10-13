/*
================================================================================
檔案代號:lld_file
檔案名稱:顾客忠诚计划参数档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lld_file
(
lld01       varchar2(10) DEFAULT ' ' NOT NULL /*价值取价来源顺序*/
                                     /*1.市价,2.平均销售单价,3. 平均采购单价,4.月加权平均成本*/
);

alter table lld_file add  constraint lld_pk primary key  (lld01) enable validate;
grant select on lld_file to tiptopgp;
grant update on lld_file to tiptopgp;
grant delete on lld_file to tiptopgp;
grant insert on lld_file to tiptopgp;
grant index on lld_file to public;
grant select on lld_file to ods;
