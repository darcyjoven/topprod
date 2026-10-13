/*
================================================================================
檔案代號:msf_file
檔案名稱:MRP 工单模拟资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table msf_file
(
msf01       varchar2(10) NOT NULL,   /*工单模拟编号                           */
                                     /*工單模擬編號                           */
msf02       varchar2(20) NOT NULL,   /*工单单号                               */
                                     /*工單單號                               */
msfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
msflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table msf_file add  constraint msf_pk primary key  (msf01,msf02) enable validate;
grant select on msf_file to tiptopgp;
grant update on msf_file to tiptopgp;
grant delete on msf_file to tiptopgp;
grant insert on msf_file to tiptopgp;
grant index on msf_file to public;
grant select on msf_file to ods;
