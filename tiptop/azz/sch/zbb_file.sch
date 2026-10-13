/*
================================================================================
檔案代號:zbb_file
檔案名稱:客户人员档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zbb_file
(
zbb01       varchar2(3) NOT NULL,    /*客户编号                               */
                                     /*客戶編號 Ex:GVC,EMC,TYC,AOC...         */
zbb02       number(5),               /*显示顺序                               */
                                     /*顯示順序                               */
zbb03       varchar2(80) NOT NULL    /*人员名称                               */
                                     /*人員名稱                               */
);

alter table zbb_file add  constraint zbb_pk primary key  (zbb01,zbb03) enable validate;
grant select on zbb_file to tiptopgp;
grant update on zbb_file to tiptopgp;
grant delete on zbb_file to tiptopgp;
grant insert on zbb_file to tiptopgp;
grant index on zbb_file to public;
grant select on zbb_file to ods;
