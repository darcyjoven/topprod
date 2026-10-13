/*
================================================================================
檔案代號:fbn_file
檔案名稱:折旧费用各期明细档(财签二)
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table fbn_file
(
fbn01       varchar2(10) DEFAULT ' ' NOT NULL, /*财产编号*/
fbn02       varchar2(4) DEFAULT ' ' NOT NULL, /*附号*/
fbn03       number(5) DEFAULT '0' NOT NULL, /*折旧年度*/
fbn04       number(5) DEFAULT '0' NOT NULL, /*折旧期别*/
fbn041      varchar2(1) DEFAULT '1' NOT NULL, /*来源*/
fbn05       varchar2(1) DEFAULT '1' NOT NULL, /*分摊方式*/
fbn06       varchar2(10) DEFAULT ' ' NOT NULL, /*保管部门*/
fbn07       number(20,6) DEFAULT '0' NOT NULL, /*折旧金额*/
fbn08       number(20,6) DEFAULT '0' NOT NULL, /*本期累折*/
fbn09       varchar2(10),            /*被分摊部门                             */
fbn10       varchar2(1) DEFAULT '1' NOT NULL, /*资产状态*/
fbn11       varchar2(24),            /*资产会计科目                           */
fbn12       varchar2(24),            /*折旧会计科目                           */
fbn13       varchar2(10),            /*分摊类型                               */
fbn14       number(20,6) DEFAULT '0' NOT NULL, /*成本*/
fbn15       number(20,6) DEFAULT '0' NOT NULL, /*累折*/
fbn16       number(20,10),           /*分摊比率                               */
fbn17       number(20,6) DEFAULT '0' NOT NULL, /*已计提减值准备*/
fbn19       varchar2(30),            /*分录底稿单号                           */
fbnlegal    varchar2(10),            /*所属法人                               */
fbn20       varchar2(24)             /*累折科目                               */
);

alter table fbn_file add  constraint fbn_pk primary key  (fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,fbn06) enable validate;
grant select on fbn_file to tiptopgp;
grant update on fbn_file to tiptopgp;
grant delete on fbn_file to tiptopgp;
grant insert on fbn_file to tiptopgp;
grant index on fbn_file to public;
grant select on fbn_file to ods;
