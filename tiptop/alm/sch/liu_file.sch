/*
================================================================================
檔案代號:liu_file
檔案名稱:合同账期自定义维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table liu_file
(
liu01       varchar2(20) DEFAULT ' ' NOT NULL, /*合约编号*/
liu02       number(5),               /*合同版本号                             */
liu03       number(5) DEFAULT '0' NOT NULL, /*项次*/
liu04       varchar2(10),            /*费用编号                               */
liu05       varchar2(10),            /*付款方式编号                           */
liu06       number(5),               /*出账期                                 */
liu07       number(5),               /*出账日                                 */
liu08       varchar2(1) DEFAULT ' ' NOT NULL, /*核算制度*/
liulegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
liuplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table liu_file add  constraint liu_pk primary key  (liu01,liu03) enable validate;
grant select on liu_file to tiptopgp;
grant update on liu_file to tiptopgp;
grant delete on liu_file to tiptopgp;
grant insert on liu_file to tiptopgp;
grant index on liu_file to public;
grant select on liu_file to ods;
