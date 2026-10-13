/*
================================================================================
檔案代號:cdn_file
檔案名稱:底稿单据来源明细
檔案目的:
上游檔案:
下游檔案:N
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cdn_file
(
cdn01       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdn02       number(5) DEFAULT '0' NOT NULL, /*期别*/
cdn03       varchar2(24),            /*科目                                   */
cdn031      varchar2(24),            /*对方科目                               */
cdn04       varchar2(80),            /*摘要                                   */
cdn05       varchar2(10),            /*部门                                   */
cdn06       varchar2(1) DEFAULT '1' NOT NULL, /*借贷别*/
cdn07       number(20,6) DEFAULT '0' NOT NULL, /*本币金额*/
cdn07f      number(20,6) DEFAULT '0' NOT NULL, /*原币金额*/
cdn08       varchar2(20)             /*单号                                   */
);

create        index cdn_01 on cdn_file (cdn01,cdn02);
grant select on cdn_file to tiptopgp;
grant update on cdn_file to tiptopgp;
grant delete on cdn_file to tiptopgp;
grant insert on cdn_file to tiptopgp;
grant index on cdn_file to public;
grant select on cdn_file to ods;
