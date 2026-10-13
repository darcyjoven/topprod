/*
================================================================================
檔案代號:ljm_file
檔案名稱:合同变更定义付款单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljm_file
(
ljm01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同变更单号*/
ljm02       number(5),               /*合同版本                               */
ljm03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljm04       varchar2(10),            /*费用编号                               */
ljm05       varchar2(10),            /*付款方式编号                           */
ljm06       number(5),               /*出账期                                 */
ljm07       number(5),               /*出账日                                 */
ljm08       varchar2(1) DEFAULT ' ' NOT NULL, /*核算制度*/
ljmlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljmplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljm_file add  constraint ljm_pk primary key  (ljm01,ljm03) enable validate;
grant select on ljm_file to tiptopgp;
grant update on ljm_file to tiptopgp;
grant delete on ljm_file to tiptopgp;
grant insert on ljm_file to tiptopgp;
grant index on ljm_file to public;
grant select on ljm_file to ods;
