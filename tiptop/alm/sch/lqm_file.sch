/*
================================================================================
檔案代號:lqm_file
檔案名稱:券发放单身交款信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqm_file
(
lqm00       varchar2(10),            /*no use 原门店编号                      */
lqm01       varchar2(20) DEFAULT ' ' NOT NULL, /*券发放单号*/
lqm02       varchar2(20) DEFAULT ' ' NOT NULL, /*交款单编号*/
lqm03       varchar2(20),            /*交款凭证号                             */
lqm04       varchar2(20),            /*销售单单号                             */
lqm05       varchar2(20),            /*销售合同号                             */
lqm06       number(20,2),            /*合同总金额                             */
lqm07       number(20,2),            /*交款金额                               */
lqm08       number(20,2),            /*可返券交款金额                         */
lqmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lqmplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lqm_file add  constraint lqm_pk primary key  (lqm01,lqm02) enable validate;
grant select on lqm_file to tiptopgp;
grant update on lqm_file to tiptopgp;
grant delete on lqm_file to tiptopgp;
grant insert on lqm_file to tiptopgp;
grant index on lqm_file to public;
grant select on lqm_file to ods;
