/*
================================================================================
檔案代號:aaw_file
檔案名稱:合并报表参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table aaw_file
(
aaw00       varchar2(1) DEFAULT ' ' NOT NULL, /*隐藏字段*/
aaw01       varchar2(5),             /*合併会科帳別                           */
aaw02       varchar2(24),            /*兑换手艺科目                           */
aaw03       varchar2(24),            /*兑换损失科目                           */
aaw04       varchar2(24),            /*换算调整科目                           */
aaw05       varchar2(24),            /*本期损益（IS）                         */
aaw06       varchar2(24),            /*本期损益（BS）                         */
aaw07       varchar2(24),            /*合并销售收入科目(关系人交易            */
aaw08       varchar2(24),            /*合并资产交易损益科目(关系人            */
aaw09       varchar2(24),            /*为实现销售利益(关系人交易)             */
aaw10       varchar2(24),            /*为实现销售损失                         */
aaw11       varchar2(24),            /*递延贷项(关系人交易)                   */
aaw12       varchar2(24),            /*递延借项(关系人交易)                   */
aaw13       varchar2(24),            /*合并本期损益科目(长期投资认            */
aaw14       varchar2(24)             /*合并投资收益科目(长期投资认            */
);

alter table aaw_file add  constraint aaw_pk primary key  (aaw00) enable validate;
grant select on aaw_file to tiptopgp;
grant update on aaw_file to tiptopgp;
grant delete on aaw_file to tiptopgp;
grant insert on aaw_file to tiptopgp;
grant index on aaw_file to public;
grant select on aaw_file to ods;
