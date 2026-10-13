/*
================================================================================
檔案代號:hisf_file
檔案名稱:历史资料备份关联设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table hisf_file
(
hisf01      varchar2(80) DEFAULT ' ' NOT NULL, /*备份对象代号*/
hisf02      varchar2(255),           /*备份对象说明                           */
hisf03      varchar2(10) DEFAULT ' ' NOT NULL, /*关联TABLE*/
hisf04      varchar2(10),            /*被关联TABLE                            */
hisf05      varchar2(255)            /*关联关系                               */
);

grant select on hisf_file to tiptopgp;
grant update on hisf_file to tiptopgp;
grant delete on hisf_file to tiptopgp;
grant insert on hisf_file to tiptopgp;
grant index on hisf_file to public;
grant select on hisf_file to ods;
