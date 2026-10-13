/*
================================================================================
檔案代號:fja_file
檔案名稱:设备保修规模档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fja_file
(
fja01       varchar2(2) NOT NULL,    /*保修规模编号                           */
fja02       varchar2(80),            /*说明                                   */
fjaacti     varchar2(1),             /*资料有效码                             */
fjauser     varchar2(10),            /*资料所有者                             */
fjagrup     varchar2(10),            /*资料所有部门                           */
fjamodu     varchar2(10),            /*最后更改人员                           */
fjadate     date,                    /*最后更改日期                           */
fjaorig     varchar2(10),            /*资料建立部门                           */
fjaoriu     varchar2(10)             /*资料建立者                             */
);

alter table fja_file add  constraint fja_pk primary key  (fja01) enable validate;
grant select on fja_file to tiptopgp;
grant update on fja_file to tiptopgp;
grant delete on fja_file to tiptopgp;
grant insert on fja_file to tiptopgp;
grant index on fja_file to public;
grant select on fja_file to ods;
