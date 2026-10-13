/*
================================================================================
檔案代號:rvd_file
檔案名稱:对账机构单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvd_file
(
rvd00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
                                     /*Doc. Type                              */
rvd01       varchar2(20) DEFAULT ' ' NOT NULL, /*对账单号*/
rvd02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rvd03       varchar2(10),            /*对账营运中心                           */
rvdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvdplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rvd_file add  constraint rvd_pk primary key  (rvd00,rvd01,rvd02) enable validate;
grant select on rvd_file to tiptopgp;
grant update on rvd_file to tiptopgp;
grant delete on rvd_file to tiptopgp;
grant insert on rvd_file to tiptopgp;
grant index on rvd_file to public;
grant select on rvd_file to ods;
