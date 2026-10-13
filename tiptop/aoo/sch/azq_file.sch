/*
================================================================================
檔案代號:azq_file
檔案名稱:营运中心使用系统档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azq_file
(
azq01       varchar2(10) NOT NULL,   /*营运中心编号                           */
                                     /*工廠編號                               */
azq03       varchar2(20) NOT NULL    /*营运中心使用系统                       */
                                     /*工廠使用系統                           */
                                     /*例: 'MFG' 'AOM' 'AAP' 'AAR' 'AGL' 'ANM'*/
);

alter table azq_file add  constraint azq_pk primary key  (azq01,azq03) enable validate;
grant select on azq_file to tiptopgp;
grant update on azq_file to tiptopgp;
grant delete on azq_file to tiptopgp;
grant insert on azq_file to tiptopgp;
grant index on azq_file to public;
grant select on azq_file to ods;
