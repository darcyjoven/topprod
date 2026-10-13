/*
================================================================================
檔案代號:obt_file
檔案名稱:车辆型号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obt_file
(
obt01       varchar2(16) NOT NULL,   /*车辆厂牌                               */
obt02       varchar2(20) NOT NULL,   /*车辆型号                               */
obt03       varchar2(80)             /*说明                                   */
);

alter table obt_file add  constraint obt_pk primary key  (obt01,obt02) enable validate;
grant select on obt_file to tiptopgp;
grant update on obt_file to tiptopgp;
grant delete on obt_file to tiptopgp;
grant insert on obt_file to tiptopgp;
grant index on obt_file to public;
grant select on obt_file to ods;
