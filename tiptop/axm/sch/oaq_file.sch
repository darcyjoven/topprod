/*
================================================================================
檔案代號:oaq_file
檔案名稱:销退单/仓退单抛转单别设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oaq_file
(
oaq01       varchar2(5) NOT NULL,    /*销退单别                               */
                                     /*銷退單別                               */
oaq02       varchar2(5),             /*仓退单别                               */
                                     /*倉退單別                               */
oaq03       varchar2(5),             /*AR 单别                                */
                                     /*AR 單別                                */
oaq04       varchar2(5),             /*AP 单别                                */
                                     /*AP 單別                                */
oaq05       varchar2(3)              /*No Use                                 */
);

alter table oaq_file add  constraint oaq_pk primary key  (oaq01) enable validate;
grant select on oaq_file to tiptopgp;
grant update on oaq_file to tiptopgp;
grant delete on oaq_file to tiptopgp;
grant insert on oaq_file to tiptopgp;
grant index on oaq_file to public;
grant select on oaq_file to ods;
