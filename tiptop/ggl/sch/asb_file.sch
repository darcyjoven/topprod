/*
================================================================================
檔案代號:asb_file
檔案名稱:关联企业层级维护作业(单身)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asb_file
(
asb01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asb02       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司代号*/
asb03       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
asb04       varchar2(10) DEFAULT ' ' NOT NULL, /*下层公司编号*/
asb05       varchar2(5) DEFAULT ' ' NOT NULL, /*下层帐套*/
asb06       varchar2(1) DEFAULT 'N' NOT NULL, /*纳入合并否*/
asb07       number(9,4) DEFAULT '0' NOT NULL, /*持股比率*/
asb08       date,                    /*异动日期                               */
asb09       varchar2(1),             /*NO USE                                 */
asb10       varchar2(1),             /*NO USE                                 */
asb11       number(10) DEFAULT '0' NOT NULL, /*投资股数*/
asb12       number(20,6) DEFAULT '0' NOT NULL, /*股本*/
asb13       varchar2(24)             /*长期投资科目                           */
);

alter table asb_file add  constraint asb_pk primary key  (asb01,asb02,asb03,asb04,asb05) enable validate;
grant select on asb_file to tiptopgp;
grant update on asb_file to tiptopgp;
grant delete on asb_file to tiptopgp;
grant insert on asb_file to tiptopgp;
grant index on asb_file to public;
grant select on asb_file to ods;
