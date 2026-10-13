/*
================================================================================
檔案代號:nmr_file
檔案名稱:银行对账单下载历史记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table nmr_file
(
nmr01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
nmr02       date,                    /*第一次下载日期                         */
nmr03       date,                    /*最后一次下载日期                       */
nmrlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nmr_file add  constraint nmr_pk primary key  (nmr01) enable validate;
grant select on nmr_file to tiptopgp;
grant update on nmr_file to tiptopgp;
grant delete on nmr_file to tiptopgp;
grant insert on nmr_file to tiptopgp;
grant index on nmr_file to public;
grant select on nmr_file to ods;
