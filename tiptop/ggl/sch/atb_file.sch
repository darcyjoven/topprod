/*
================================================================================
檔案代號:atb_file
檔案名稱:凭证明细
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table atb_file
(
atb01       varchar2(10),            /*公司编号                               */
atb02       varchar2(5),             /*帐套                                   */
atb03       number(5),               /*年度                                   */
atb04       number(5),               /*期别                                   */
atb05       date,                    /*凭证日期                               */
atb06       varchar2(20),            /*凭证编号                               */
atb07       number(5),               /*项次                                   */
atb08       varchar2(255),           /*摘要                                   */
atb09       varchar2(24),            /*会计科目                               */
atb10       varchar2(1) DEFAULT ' ' NOT NULL, /*借/贷*/
atb11       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
atb12       varchar2(10),            /*群组分类                               */
atblegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

grant select on atb_file to tiptopgp;
grant update on atb_file to tiptopgp;
grant delete on atb_file to tiptopgp;
grant insert on atb_file to tiptopgp;
grant index on atb_file to public;
grant select on atb_file to ods;
