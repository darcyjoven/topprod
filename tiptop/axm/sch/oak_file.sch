/*
================================================================================
檔案代號:oak_file
檔案名稱:留置/理由档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oak_file
(
oak01       varchar2(10) NOT NULL,   /*留置/理由码                            */
                                     /*留置/理由碼                            */
oak02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
oak03       varchar2(1)              /*1.留置码  2.理由码                     */
                                     /*1.留置碼  2.理由碼                     */
);

alter table oak_file add  constraint oak_pk primary key  (oak01) enable validate;
grant select on oak_file to tiptopgp;
grant update on oak_file to tiptopgp;
grant delete on oak_file to tiptopgp;
grant insert on oak_file to tiptopgp;
grant index on oak_file to public;
grant select on oak_file to ods;
