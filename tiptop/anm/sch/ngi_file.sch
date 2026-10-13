/*
================================================================================
檔案代號:ngi_file
檔案名稱:营运中心追索天数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ngi_file
(
ngi01       varchar2(3) NOT NULL,    /*类型                                   */
ngi02       varchar2(10) NOT NULL,   /*来源营运中心                           */
ngi03       number(5)                /*追索天数                               */
);

alter table ngi_file add  constraint ngi_pk primary key  (ngi01,ngi02) enable validate;
grant select on ngi_file to tiptopgp;
grant update on ngi_file to tiptopgp;
grant delete on ngi_file to tiptopgp;
grant insert on ngi_file to tiptopgp;
grant index on ngi_file to public;
grant select on ngi_file to ods;
