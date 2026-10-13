/*
================================================================================
檔案代號:lnw_file
檔案名稱:合同其他费用单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lnw_file
(
lnw01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
lnw02       varchar2(20),            /*合同版本号                             */
lnw03       varchar2(10) DEFAULT ' ' NOT NULL, /*费用编号*/
lnw04       varchar2(24),            /*会计科目                               */
lnw041      varchar2(24),            /*会计科目二                             */
lnw05       varchar2(1) DEFAULT ' ', /*No Use                                 */
lnw06       number(20,6),            /*费用金额                               */
lnw07       varchar2(1) DEFAULT ' ' NOT NULL, /*收取方式*/
lnw08       date,                    /*生效日期                               */
lnw09       date,                    /*失效日期                               */
lnw10       varchar2(1),             /*费用归属                               */
lnwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnwplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lnw11       number(5) DEFAULT '0' NOT NULL /*项次*/
);

alter table lnw_file add  constraint lnw_pk primary key  (lnw01,lnw11) enable validate;
grant select on lnw_file to tiptopgp;
grant update on lnw_file to tiptopgp;
grant delete on lnw_file to tiptopgp;
grant insert on lnw_file to tiptopgp;
grant index on lnw_file to public;
grant select on lnw_file to ods;
