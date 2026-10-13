/*
================================================================================
檔案代號:tsb_file
檔案名稱:提案费用明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsb_file
(
tsb01       varchar2(20) NOT NULL,   /*提案单号                               */
tsb02       number(5) NOT NULL,      /*项次                                   */
tsb03       number(5) NOT NULL,      /*客户项次                               */
tsb04       varchar2(10) NOT NULL,   /*品类代码                               */
tsb05       varchar2(10),            /*费用代码                               */
tsb06       number(20,6),            /*费用金额                               */
tsb07       number(20,6),            /*实际费用金额                           */
tsb08       varchar2(10),            /*费用支付对象                           */
tsb09       varchar2(10),            /*费用支付方式                           */
tsb10       varchar2(10),            /*陈列方式                               */
tsb11       date,                    /*陈列起始日                             */
tsb12       date,                    /*陈列终止日                             */
tsb13       varchar2(255),           /*备注                                   */
tsbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tsblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tsb_file add  constraint tsb_pk primary key  (tsb01,tsb02,tsb03) enable validate;
grant select on tsb_file to tiptopgp;
grant update on tsb_file to tiptopgp;
grant delete on tsb_file to tiptopgp;
grant insert on tsb_file to tiptopgp;
grant index on tsb_file to public;
grant select on tsb_file to ods;
