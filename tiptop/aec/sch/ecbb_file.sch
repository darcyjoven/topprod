/*
================================================================================
檔案代號:ecbb_file
檔案名稱:工艺资料说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecbb_file
(
ecbb01      varchar2(40) NOT NULL,   /*料件编号                               */
ecbb02      varchar2(10) NOT NULL,   /*工艺编号                               */
ecbb03      number(5) NOT NULL,      /*工艺序号                               */
ecbb09      number(5) NOT NULL,      /*行序                                   */
ecbb10      varchar2(80),            /*说明                                   */
ecbb012     varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table ecbb_file add  constraint ecbb_pk primary key  (ecbb01,ecbb02,ecbb03,ecbb09,ecbb012) enable validate;
grant select on ecbb_file to tiptopgp;
grant update on ecbb_file to tiptopgp;
grant delete on ecbb_file to tiptopgp;
grant insert on ecbb_file to tiptopgp;
grant index on ecbb_file to public;
grant select on ecbb_file to ods;
