/*
================================================================================
檔案代號:sts_file
檔案名稱:费用分摊基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sts_file
(
sts01       varchar2(24) NOT NULL,   /*会计科目                               */
                                     /*會計科目                               */
sts02       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門代號                               */
sts03       varchar2(1),             /*费用区分                               */
                                     /*費用區分 1:直接人工 2:間接製造費用     */
sts04       varchar2(1),             /*成本动因                               */
                                     /*成本動因                               */
sts05       varchar2(24),            /*转出会计科目                           */
                                     /*轉出會計科目                           */
sts06       varchar2(1)              /*转出成本动因                           */
                                     /*轉出成本動因                           */
);

alter table sts_file add  constraint sts_pk primary key  (sts01,sts02) enable validate;
grant select on sts_file to tiptopgp;
grant update on sts_file to tiptopgp;
grant delete on sts_file to tiptopgp;
grant insert on sts_file to tiptopgp;
grant index on sts_file to public;
grant select on sts_file to ods;
