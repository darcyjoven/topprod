/*
================================================================================
檔案代號:lnv_file
檔案名稱:合同标准费用单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lnv_file
(
lnv01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
lnv02       varchar2(20),            /*合同版本号                             */
lnv03       number(5) DEFAULT '0' NOT NULL, /*项次*/
lnv04       varchar2(10),            /*费用编号                               */
lnv05       varchar2(4),             /*年份                                   */
lnv06       varchar2(2),             /*月份                                   */
lnv07       number(20,6),            /*费用标准                               */
lnv08       number(10),              /*人数                                   */
lnv09       number(20,2),            /*费用合计                               */
lnv10       number(20,2),            /*原调整金额                             */
lnv11       number(20,2),            /*调整后金额                             */
lnv12       number(20,2),            /*保底金额                               */
lnv13       varchar2(1),             /*收取方式                               */
lnv14       varchar2(50),            /*备注                                   */
lnv15       varchar2(1),             /*费用归属                               */
lnv16       date,                    /*生效日期                               */
lnv17       date,                    /*失效日期                               */
lnvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnvplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lnv18       varchar2(20),            /*费用方案                               */
lnv181      number(5)                /*费用方案版本号                         */
);

alter table lnv_file add  constraint lnv_pk primary key  (lnv01,lnv03) enable validate;
grant select on lnv_file to tiptopgp;
grant update on lnv_file to tiptopgp;
grant delete on lnv_file to tiptopgp;
grant insert on lnv_file to tiptopgp;
grant index on lnv_file to public;
grant select on lnv_file to ods;
