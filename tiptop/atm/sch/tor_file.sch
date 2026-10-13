/*
================================================================================
檔案代號:tor_file
檔案名稱:节目编号资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tor_file
(
tor01       varchar2(4) NOT NULL,    /*节目编号                               */
tor02       varchar2(80),            /*节目名称                               */
toracti     varchar2(1)              /*资料有效码                             */
);

alter table tor_file add  constraint tor_pk primary key  (tor01) enable validate;
grant select on tor_file to tiptopgp;
grant update on tor_file to tiptopgp;
grant delete on tor_file to tiptopgp;
grant insert on tor_file to tiptopgp;
grant index on tor_file to public;
grant select on tor_file to ods;
