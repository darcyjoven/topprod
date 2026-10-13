/*
================================================================================
檔案代號:tc_imc_file
檔案名稱:在制LOT清单交接第二页签表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imc_file
(
tc_imc01    varchar2(40) NOT NULL,   /*交接单号                               */
tc_imc02    number(10) NOT NULL,     /*项次                                   */
tc_imc03    varchar2(20),            /*作业编号                               */
tc_imc04    varchar2(40),            /*LOT单号                                */
tc_imc05    varchar2(40),            /*工单单号                               */
tc_imc06    varchar2(40),            /*生产料号                               */
tc_imc07    varchar2(40),            /*发料主件编码                           */
tc_imc08    number(15,3),            /*应发数量                               */
tc_imc09    number(15,3),            /*已发数量                               */
tc_imc10    number(15,3),            /*已扫出量                               */
tc_imc11    number(15,3),            /*已完工量                               */
tc_imc12    number(15,3),            /*已报废量                               */
tc_imc13    number(15,3)             /*剩余库存量                             */
);

alter table tc_imc_file add  constraint tpc_imc_pk primary key  (tc_imc01,tc_imc02) enable validate;
grant select on tc_imc_file to tiptopgp;
grant update on tc_imc_file to tiptopgp;
grant delete on tc_imc_file to tiptopgp;
grant insert on tc_imc_file to tiptopgp;
grant index on tc_imc_file to public;
grant select on tc_imc_file to ods;
