/*
================================================================================
檔案代號:och_file
檔案名稱:多营运中心信用评等设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table och_file
(
och01       varchar2(10) NOT NULL,   /*信用评等                               */
och02       number(5) NOT NULL,      /*类型                                   */
och03       varchar2(10) NOT NULL    /*来源营运中心                           */
);

alter table och_file add  constraint och_pk primary key  (och01,och02,och03) enable validate;
grant select on och_file to tiptopgp;
grant update on och_file to tiptopgp;
grant delete on och_file to tiptopgp;
grant insert on och_file to tiptopgp;
grant index on och_file to public;
grant select on och_file to ods;
