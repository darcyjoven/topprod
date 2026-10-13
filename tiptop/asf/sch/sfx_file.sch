/*
================================================================================
檔案代號:sfx_file
檔案名稱:选取主件暂存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sfx_file
(
sfx01       varchar2(10),            /*版本编号                               */
                                     /*版本編號                               */
sfx02       varchar2(40),            /*成品编号                               */
                                     /*成品編號                               */
sfx03       number(15,3)             /*发料套数                               */
                                     /*發料套數                               */
);

grant select on sfx_file to tiptopgp;
grant update on sfx_file to tiptopgp;
grant delete on sfx_file to tiptopgp;
grant insert on sfx_file to tiptopgp;
grant index on sfx_file to public;
grant select on sfx_file to ods;
