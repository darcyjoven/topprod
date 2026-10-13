/*
================================================================================
檔案代號:gdh_file
檔案名稱:报表资讯档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdh_file
(
gdh01       varchar2(3) DEFAULT ' ' NOT NULL, /*报表类型*/
gdh02       varchar2(20) DEFAULT ' ' NOT NULL, /*报表程序代号*/
gdh03       varchar2(40) NOT NULL,   /*报表Cuid                               */
gdh04       varchar2(1000),          /*BOE平台报表存放路径                    */
gdh05       varchar2(1) DEFAULT 'N' NOT NULL, /*客制否*/
gdh06       varchar2(10) DEFAULT 'std' NOT NULL, /*行业别*/
gdh07       varchar2(1) DEFAULT '0' NOT NULL /*语言别*/
);

create unique index gdh_01 on gdh_file (gdh02,gdh05,gdh06,gdh07);
alter table gdh_file add  constraint gdh_pk primary key  (gdh03) enable validate;
grant select on gdh_file to tiptopgp;
grant update on gdh_file to tiptopgp;
grant delete on gdh_file to tiptopgp;
grant insert on gdh_file to tiptopgp;
grant index on gdh_file to public;
grant select on gdh_file to ods;
