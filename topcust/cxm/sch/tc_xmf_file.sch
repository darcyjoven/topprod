/*
================================================================================
檔案代號:tc_xmf_file
檔案名稱:产品检查单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_xmf_file
(
tc_xmf00    varchar2(40) NOT NULL,   /*核价单号                               */
tc_xmf01    number(5) NOT NULL,      /*核价单号项次                           */
tc_xmf02    varchar2(6),             /*价格条件编号                           */
tc_xmf03    varchar2(40),            /*料件编号                               */
tc_xmf04    varchar2(4),             /*单位                                   */
tc_xmf05    number(20,6),            /*税前单价                               */
tc_xmf06    number(20,6),            /*含税单价                               */
tc_xmf07    number(20,6),            /*SMT材料单价(未税)                      */
tc_xmf08    number(20,6),            /*SMT组装单价(未税)                      */
tc_xmf09    number(20,6),            /*报价良率                               */
tc_xmf10    number(20,6),            /*光板未税单价                           */
tc_xmf11    number(20,6),
tc_xmf12    date
);

alter table tc_xmf_file add  constraint tpc_xmf_pk primary key  (tc_xmf00,tc_xmf01) enable validate;
grant select on tc_xmf_file to tiptopgp;
grant update on tc_xmf_file to tiptopgp;
grant delete on tc_xmf_file to tiptopgp;
grant insert on tc_xmf_file to tiptopgp;
grant index on tc_xmf_file to public;
grant select on tc_xmf_file to ods;
