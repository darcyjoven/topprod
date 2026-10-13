/*
================================================================================
檔案代號:nph_file
檔案名稱:银行假日设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nph_file
(
nph01       date NOT NULL,           /*假日日期                               */
nph02       varchar2(80)             /*假日名称                               */
                                     /*假日名稱                               */
);

alter table nph_file add  constraint nph_pk primary key  (nph01) enable validate;
grant select on nph_file to tiptopgp;
grant update on nph_file to tiptopgp;
grant delete on nph_file to tiptopgp;
grant insert on nph_file to tiptopgp;
grant index on nph_file to public;
grant select on nph_file to ods;
