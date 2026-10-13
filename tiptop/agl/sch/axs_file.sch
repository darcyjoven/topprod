/*
================================================================================
檔案代號:axs_file
檔案名稱:来源科目misc明细科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axs_file
(
axs00       varchar2(5) NOT NULL,    /*母公司账套                             */
axs01       varchar2(24) NOT NULL,   /*母(子)公司科目编号                     */
axs03       varchar2(24) NOT NULL,   /*来源：母(子)公司科目misc明细           */
axs09       varchar2(10) NOT NULL,   /*来源：母(子)公司编号                   */
axs10       varchar2(10) NOT NULL,   /*对冲：子公司编号                       */
axs12       varchar2(5) NOT NULL,    /*子公司账套                             */
axs13       varchar2(10) DEFAULT ' ' NOT NULL /*集团代号*/
);

alter table axs_file add  constraint axs_pk primary key  (axs00,axs01,axs03,axs09,axs10,axs12,axs13) enable validate;
grant select on axs_file to tiptopgp;
grant update on axs_file to tiptopgp;
grant delete on axs_file to tiptopgp;
grant insert on axs_file to tiptopgp;
grant index on axs_file to public;
grant select on axs_file to ods;
