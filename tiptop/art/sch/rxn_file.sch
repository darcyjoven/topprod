/*
================================================================================
檔案代號:rxn_file
檔案名稱:赠品发放/退还交易单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxn_file
(
rxn00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
                                     /*Doc. Type1-Premiums Release 2-Premiums Return*/
rxn01       varchar2(20) DEFAULT ' ' NOT NULL, /*发放/退还单号*/
rxn02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rxn03       date,                    /*交易日期                               */
rxn04       varchar2(20),            /*销售/销退单号                          */
rxn05       varchar2(20),            /*销售订单人                             */
rxn06       varchar2(20),            /*收银小票号                             */
rxn07       number(20,6) DEFAULT '0' NOT NULL, /*交易金额*/
rxn08       varchar2(255),           /*備注                                   */
rxnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxnplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rxn09       varchar2(20)             /*发票号码                               */
);

alter table rxn_file add  constraint rxn_pk primary key  (rxn00,rxn01,rxn02,rxnplant) enable validate;
grant select on rxn_file to tiptopgp;
grant update on rxn_file to tiptopgp;
grant delete on rxn_file to tiptopgp;
grant insert on rxn_file to tiptopgp;
grant index on rxn_file to public;
grant select on rxn_file to ods;
