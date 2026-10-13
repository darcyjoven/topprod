/*
================================================================================
檔案代號:liw_file
檔案名稱:合同账单档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table liw_file
(
liw01       varchar2(20) DEFAULT ' ' NOT NULL, /*合约编号*/
liw02       number(5),               /*合同版本号                             */
liw03       number(5) DEFAULT '0' NOT NULL, /*项次*/
liw04       varchar2(10),            /*费用编号                               */
liw05       number(5),               /*账期                                   */
liw06       date,                    /*出账日期                               */
liw07       date,                    /*账单起日                               */
liw08       date,                    /*账单止日                               */
liw09       number(20,6),            /*费用标准                               */
liw10       number(20,6),            /*优惠金额                               */
liw11       number(20,6),            /*终止结算额                             */
liw12       number(20,6),            /*抹零金额                               */
liw13       number(20,6),            /*实际应收                               */
liw14       number(20,6),            /*已收金额                               */
liw15       number(20,6),            /*清算金额                               */
liw16       varchar2(20),            /*费用单号                               */
liw17       varchar2(1) DEFAULT ' ' NOT NULL, /*结案否*/
liwlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
liwplant    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
liw18       number(5)                /*费用单项次                             */
);

alter table liw_file add  constraint liw_pk primary key  (liw01,liw03) enable validate;
grant select on liw_file to tiptopgp;
grant update on liw_file to tiptopgp;
grant delete on liw_file to tiptopgp;
grant insert on liw_file to tiptopgp;
grant index on liw_file to public;
grant select on liw_file to ods;
