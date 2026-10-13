/*
================================================================================
檔案代號:zxx_file
檔案名稱:用户当前使用营运中心档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zxx_file
(
zxx01       varchar2(10) NOT NULL,   /*用户编号                               */
                                     /*使用者代號,(Login user name)           */
zxx02       varchar2(32) NOT NULL,   /*用户终端机编号                         */
                                     /*使用者終端機代號                       */
zxx03       varchar2(10)             /*当前使用营运中心编号                   */
                                     /*Current Using Plant No.                */
);

alter table zxx_file add  constraint zxx_pk primary key  (zxx01,zxx02) enable validate;
grant select on zxx_file to tiptopgp;
grant update on zxx_file to tiptopgp;
grant delete on zxx_file to tiptopgp;
grant insert on zxx_file to tiptopgp;
grant index on zxx_file to public;
grant select on zxx_file to ods;
