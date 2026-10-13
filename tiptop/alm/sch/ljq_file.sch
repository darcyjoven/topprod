/*
================================================================================
檔案代號:ljq_file
檔案名稱:合同变更账单档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljq_file
(
ljq01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同变更单单号*/
ljq02       number(5),               /*合同版本号                             */
ljq03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljq04       varchar2(10),            /*费用编号                               */
ljq05       number(5),               /*帐期                                   */
ljq06       date,                    /*出帐日期                               */
ljq07       date,                    /*账单起日                               */
ljq08       date,                    /*账单止日                               */
ljq09       number(20,6),            /*标准费用                               */
ljq10       number(20,6),            /*优惠金额                               */
ljq11       number(20,6),            /*终止结算额                             */
ljq12       number(20,6),            /*抹零金额                               */
ljq13       number(20,6),            /*实际应收                               */
ljq14       number(20,6),            /*已收金额                               */
ljq15       number(20,6),            /*清算金额                               */
ljq16       varchar2(20),            /*费用单号                               */
ljq17       varchar2(1) DEFAULT ' ' NOT NULL, /*结案否*/
ljqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljqplant    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
ljq18       number(5)                /*费用单项次                             */
);

alter table ljq_file add  constraint ljq_pk primary key  (ljq01,ljq03) enable validate;
grant select on ljq_file to tiptopgp;
grant update on ljq_file to tiptopgp;
grant delete on ljq_file to tiptopgp;
grant insert on ljq_file to tiptopgp;
grant index on ljq_file to public;
grant select on ljq_file to ods;
