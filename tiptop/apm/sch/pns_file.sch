/*
================================================================================
檔案代號:pns_file
檔案名稱:请采购预算单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pns_file
(
pns01       varchar2(10) NOT NULL,   /*预算编号                               */
                                     /*預算編號                               */
pns02       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
pns03       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
pns04       number(5) NOT NULL,      /*年度                                   */
pns05       number(5) NOT NULL,      /*月份                                   */
pns06       number(20,6),            /*原始预算金额                           */
                                     /*原始預算金額                           */
pns07       number(20,6),            /*追加金额                               */
                                     /*追加金額                               */
pns08       number(20,6),            /*挪用金额                               */
                                     /*挪用金額                               */
pns09       number(20,6)             /*月预算金额                             */
                                     /*月預算金額                             */
);

alter table pns_file add  constraint pns_pk primary key  (pns01,pns02,pns03,pns04,pns05) enable validate;
grant select on pns_file to tiptopgp;
grant update on pns_file to tiptopgp;
grant delete on pns_file to tiptopgp;
grant insert on pns_file to tiptopgp;
grant index on pns_file to public;
grant select on pns_file to ods;
