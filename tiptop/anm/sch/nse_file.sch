/*
================================================================================
檔案代號:nse_file
檔案名稱:销账明细资料定义单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nse_file
(
nse01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
nse02       varchar2(20) NOT NULL,   /*字段编号                               */
nse03       varchar2(10) NOT NULL,   /*原值                                   */
nse04       varchar2(10)             /*转换值                                 */
);

alter table nse_file add  constraint nse_pk primary key  (nse01,nse02,nse03) enable validate;
grant select on nse_file to tiptopgp;
grant update on nse_file to tiptopgp;
grant delete on nse_file to tiptopgp;
grant insert on nse_file to tiptopgp;
grant index on nse_file to public;
grant select on nse_file to ods;
