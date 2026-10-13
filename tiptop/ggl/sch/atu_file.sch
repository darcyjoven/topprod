/*
================================================================================
檔案代號:atu_file
檔案名稱:股东权益凭证明细群组归属档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table atu_file
(
atu01       varchar2(10) DEFAULT ' ' NOT NULL, /*公司代码*/
atu02       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
atu03       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
atu04       number(5) DEFAULT '0' NOT NULL, /*年度*/
atu05       number(5) DEFAULT '0' NOT NULL, /*期别*/
atu06       date DEFAULT sysdate NOT NULL, /*凭证日期*/
atu07       varchar2(20) DEFAULT ' ' NOT NULL, /*凭证编号*/
atu08       number(10) DEFAULT '0' NOT NULL, /*项次*/
atu09       varchar2(80),            /*摘要                                   */
atu10       varchar2(24),            /*会计科目                               */
atu11       varchar2(1),             /*借贷方                                 */
atu12       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
atu13       varchar2(10)             /*群组分类                               */
);

alter table atu_file add  constraint atu_pk primary key  (atu01,atu02,atu03,atu04,atu05,atu06,atu07,atu08) enable validate;
grant select on atu_file to tiptopgp;
grant update on atu_file to tiptopgp;
grant delete on atu_file to tiptopgp;
grant insert on atu_file to tiptopgp;
grant index on atu_file to public;
grant select on atu_file to ods;
