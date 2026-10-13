/*
================================================================================
檔案代號:ecw_file
檔案名稱:工艺资料作业说明说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecw_file
(
ecw01       varchar2(40) NOT NULL,   /*料件编号                               */
ecw02       varchar2(10) NOT NULL,   /*工艺编号                               */
ecw03       number(5) NOT NULL,      /*作业序号                               */
ecw04       date,                    /*生效日期                               */
ecw05       number(5) NOT NULL,      /*行序号                                 */
ecw06       varchar2(80),            /*说明                                   */
ecw012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table ecw_file add  constraint ecw_pk primary key  (ecw01,ecw02,ecw03,ecw05,ecw012) enable validate;
grant select on ecw_file to tiptopgp;
grant update on ecw_file to tiptopgp;
grant delete on ecw_file to tiptopgp;
grant insert on ecw_file to tiptopgp;
grant index on ecw_file to public;
grant select on ecw_file to ods;
