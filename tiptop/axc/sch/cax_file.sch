/*
================================================================================
檔案代號:cax_file
檔案名稱:成本分摊权数及金额档-直接部门
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cax_file
(
cax00       varchar2(1) NOT NULL,    /*分摊类别 (1:人工 2:制费一 3:制         */
cax01       number(5) NOT NULL,      /*年度                                   */
cax02       number(5) NOT NULL,      /*月份                                   */
cax03       varchar2(10) NOT NULL,   /*直接部门                               */
cax04       varchar2(24) NOT NULL,   /*会计科目                               */
cax05       number(20,6),            /*当期余额                               */
cax06       varchar2(10) NOT NULL,   /*间接部门                               */
cax07       number(15,3),            /*分摊权数                               */
cax10       number(20,6),            /*分摊金额                               */
caxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cax_file add  constraint cax_pk primary key  (cax00,cax01,cax02,cax03,cax04,cax06) enable validate;
grant select on cax_file to tiptopgp;
grant update on cax_file to tiptopgp;
grant delete on cax_file to tiptopgp;
grant insert on cax_file to tiptopgp;
grant index on cax_file to public;
grant select on cax_file to ods;
