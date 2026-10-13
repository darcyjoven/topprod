/*
================================================================================
檔案代號:asz_file
檔案名稱:合并报表参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table asz_file
(
asz00       varchar2(1) DEFAULT ' ' NOT NULL, /*隐藏字段*/
asz01       varchar2(5),             /*合併会科帳別                           */
asz02       varchar2(24),            /*兑换手艺科目                           */
asz03       varchar2(24),            /*兑换损失科目                           */
asz04       varchar2(24),            /*换算调整科目                           */
asz05       varchar2(24),            /*本期损益（IS）                         */
asz06       varchar2(24),            /*本期损益（BS）                         */
asz07       varchar2(24),            /*合并销售收入科目(关系人交易            */
asz08       varchar2(24),            /*合并资产交易损益科目(关系人            */
asz09       varchar2(24),            /*为实现销售利益(关系人交易)             */
asz10       varchar2(24),            /*为实现销售损失                         */
asz11       varchar2(24),            /*递延贷项(关系人交易)                   */
asz12       varchar2(24),            /*递延借项(关系人交易)                   */
asz13       varchar2(24),            /*合并本期损益科目(长期投资认            */
asz14       varchar2(24)             /*合并投资收益科目(长期投资认            */
);

alter table asz_file add  constraint asz_pk primary key  (asz00) enable validate;
grant select on asz_file to tiptopgp;
grant update on asz_file to tiptopgp;
grant delete on asz_file to tiptopgp;
grant insert on asz_file to tiptopgp;
grant index on asz_file to public;
grant select on asz_file to ods;
