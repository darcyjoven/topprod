/*
================================================================================
檔案代號:ogaa_file
檔案名稱:出货单INVOICE档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogaa_file
(
ogaa00      varchar2(1),             /*No Use                                 */
ogaa01      varchar2(10) NOT NULL,   /*No Use                                 */
ogaa011     varchar2(10),            /*No Use                                 */
ogaa49      varchar2(16),            /*No Use                                 */
ogaaplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
ogaalegal   varchar2(10) NOT NULL    /*所属法人                               */
);

create unique index ogaa_02 on ogaa_file (ogaa49);
alter table ogaa_file add  constraint ogaa_pk primary key  (ogaa01) enable validate;
grant select on ogaa_file to tiptopgp;
grant update on ogaa_file to tiptopgp;
grant delete on ogaa_file to tiptopgp;
grant insert on ogaa_file to tiptopgp;
grant index on ogaa_file to public;
grant select on ogaa_file to ods;
