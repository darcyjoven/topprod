/*
================================================================================
檔案代號:sig_file
檔案名稱:备置库存资料明细表
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table sig_file
(
sig01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
sig02       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
sig03       varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
sig04       varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
sig05       number(15,3) DEFAULT '0' NOT NULL,
sig06       varchar2(4),             /*单位                                   */
sig07       date,                    /*最近异动日期                           */
siglegal    varchar2(10) NOT NULL,   /*所属法人                               */
sigplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table sig_file add  constraint sig_pk primary key  (sig01,sig02,sig03,sig04) enable validate;
grant select on sig_file to tiptopgp;
grant update on sig_file to tiptopgp;
grant delete on sig_file to tiptopgp;
grant insert on sig_file to tiptopgp;
grant index on sig_file to public;
grant select on sig_file to ods;
