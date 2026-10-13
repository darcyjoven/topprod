/*
================================================================================
檔案代號:wgf_file
檔案名稱:gpm services 设定维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wgf_file
(
wgf01       varchar2(40) NOT NULL,   /*服务代码                               */
wgf02       varchar2(255) NOT NULL,  /*gpm soap网址                           */
wgf03       varchar2(255) NOT NULL   /*gpm http网址                           */
);

alter table wgf_file add  constraint wgf_pk primary key  (wgf01) enable validate;
grant select on wgf_file to tiptopgp;
grant update on wgf_file to tiptopgp;
grant delete on wgf_file to tiptopgp;
grant insert on wgf_file to tiptopgp;
grant index on wgf_file to public;
grant select on wgf_file to ods;
