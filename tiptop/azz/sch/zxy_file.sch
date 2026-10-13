/*
================================================================================
檔案代號:zxy_file
檔案名稱:员工权限资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zxy_file
(
zxy01       varchar2(10) NOT NULL,   /*用户编号                               */
                                     /*使用者代號,(Login user name)           */
zxy02       varchar2(80),            /*用户名称                               */
                                     /*使用者名稱                             */
zxy03       varchar2(10) NOT NULL    /*使用营运中心编号                       */
                                     /*Using Plant No.                        */
);

alter table zxy_file add  constraint zxy_pk primary key  (zxy01,zxy03) enable validate;
grant select on zxy_file to tiptopgp;
grant update on zxy_file to tiptopgp;
grant delete on zxy_file to tiptopgp;
grant insert on zxy_file to tiptopgp;
grant index on zxy_file to public;
grant select on zxy_file to ods;
