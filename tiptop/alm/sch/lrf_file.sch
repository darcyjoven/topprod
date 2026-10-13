/*
================================================================================
檔案代號:lrf_file
檔案名稱:换券单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrf_file
(
lrf01       varchar2(20) DEFAULT ' ' NOT NULL, /*换券单编号*/
lrf02       varchar2(20) DEFAULT ' ' NOT NULL, /*券号*/
lrf03       number(20,2) DEFAULT '0' NOT NULL, /*券金额*/
lrflegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrfplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lrf_file add  constraint lrf_pk primary key  (lrf01,lrf02) enable validate;
grant select on lrf_file to tiptopgp;
grant update on lrf_file to tiptopgp;
grant delete on lrf_file to tiptopgp;
grant insert on lrf_file to tiptopgp;
grant index on lrf_file to public;
grant select on lrf_file to ods;
