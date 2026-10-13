/*
================================================================================
檔案代號:ljj_file
檔案名稱:合同变更费用标准单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljj_file
(
ljj01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同变更单号*/
ljj02       number(5),               /*合同版本                               */
ljj03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljj04       varchar2(10),            /*费用编号                               */
ljj05       varchar2(20),            /*方案编号                               */
ljj051      number(5),               /*方案版本号                             */
ljj06       date,                    /*开始日期                               */
ljj07       date,                    /*结束日期                               */
ljj08       number(20,6),            /*费用标准                               */
ljjlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljjplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljj_file add  constraint ljj_pk primary key  (ljj01,ljj03) enable validate;
grant select on ljj_file to tiptopgp;
grant update on ljj_file to tiptopgp;
grant delete on ljj_file to tiptopgp;
grant insert on ljj_file to tiptopgp;
grant index on ljj_file to public;
grant select on ljj_file to ods;
