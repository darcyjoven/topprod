/*
================================================================================
檔案代號:lui_file
檔案名稱:交款单单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lui_file
(
lui01       varchar2(20) DEFAULT ' ' NOT NULL, /*交款单号*/
lui02       date,                    /*单据日期                               */
lui03       date,                    /*立帐日期                               */
lui04       varchar2(20),            /*费用单号                               */
lui05       varchar2(10),            /*商户编号                               */
lui06       varchar2(20),            /*摊位编号                               */
lui07       varchar2(20),            /*合同编号                               */
lui08       number(5),               /*合同版本号                             */
lui09       number(20,6),            /*交款金额                               */
lui10       number(20,6),            /*已交金额                               */
lui11       varchar2(10),            /*业务人员                               */
lui12       varchar2(10),            /*部门编号                               */
lui13       varchar2(255),           /*备注                                   */
lui14       varchar2(20),            /*财务单号                               */
luiacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
luicond     date,                    /*审核日期                               */
luiconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
luicont     varchar2(8),             /*审核时间                               */
luiconu     varchar2(10),            /*审核人员                               */
luicrat     date,                    /*资料创建日                             */
luidate     date,                    /*最近更改日                             */
luigrup     varchar2(10),            /*资料所有群                             */
luilegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
luimodu     varchar2(10),            /*资料更改者                             */
luiorig     varchar2(10),            /*资料建立部门                           */
luioriu     varchar2(10),            /*资料建立者                             */
luiplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
luiuser     varchar2(10),            /*资料所有者                             */
lui15       varchar2(1) DEFAULT ' ' NOT NULL /*直接收款*/
);

alter table lui_file add  constraint lui_pk primary key  (lui01) enable validate;
grant select on lui_file to tiptopgp;
grant update on lui_file to tiptopgp;
grant delete on lui_file to tiptopgp;
grant insert on lui_file to tiptopgp;
grant index on lui_file to public;
grant select on lui_file to ods;
