/*
================================================================================
檔案代號:slg_file
檔案名稱:尺码表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table slg_file
(
slg01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单号*/
slg02       varchar2(40) DEFAULT ' ' NOT NULL, /*款式编号*/
slg03       number(5) DEFAULT '0' NOT NULL, /*尺寸顺序*/
slg04       varchar2(10)             /*尺码                                   */
);

alter table slg_file add  constraint slg_pk primary key  (slg01,slg02,slg03) enable validate;
grant select on slg_file to tiptopgp;
grant update on slg_file to tiptopgp;
grant delete on slg_file to tiptopgp;
grant insert on slg_file to tiptopgp;
grant index on slg_file to public;
grant select on slg_file to ods;
