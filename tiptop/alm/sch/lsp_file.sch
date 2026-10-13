/*
================================================================================
檔案代號:lsp_file
檔案名稱:卡开帐单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsp_file
(
lsp01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lsp02       varchar2(20),            /*会员编号                               */
lsp03       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种*/
lsp04       varchar2(30) DEFAULT ' ' NOT NULL, /*卡号*/
lsp05       date,                    /*发行日期                               */
lsp06       date,                    /*结束日期                               */
lsp07       number(20,6) DEFAULT '0' NOT NULL, /*储值卡余额*/
lsp08       number(20) DEFAULT '0' NOT NULL, /*当前累计消费次数*/
lsp09       date,                    /*最后消费日                             */
lsp10       number(20) DEFAULT '0' NOT NULL, /*目前剩余积分*/
lsp11       number(20) DEFAULT '0' NOT NULL, /*已兑换积分*/
lsp12       number(20) DEFAULT '0' NOT NULL, /*当前累计消费积分*/
lsp13       number(20,6) DEFAULT '0' NOT NULL, /*当前累计消费金额*/
lsp14       varchar2(10) DEFAULT ' ' NOT NULL, /*帐款编号*/
lsp15       date,                    /*开卡日期                               */
lsp16       varchar2(10) DEFAULT ' ' NOT NULL, /*开卡营运中心*/
lsplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lspplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

create        index lsp_01 on lsp_file (lsp01,lsp04);
alter table lsp_file add  constraint lsp_pk primary key  (lsp01,lsp04) enable validate;
grant select on lsp_file to tiptopgp;
grant update on lsp_file to tiptopgp;
grant delete on lsp_file to tiptopgp;
grant insert on lsp_file to tiptopgp;
grant index on lsp_file to public;
grant select on lsp_file to ods;
