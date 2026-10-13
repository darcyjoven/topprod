/*
================================================================================
檔案代號:hrasa_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrasa_file
(
hrasa01     varchar2(50) NOT NULL,   /*职位编码                               */
hrasa02     number(5) NOT NULL,      /*项次                                   */
hrasa03     varchar2(255),           /*职责名称                               */
hrasa04     varchar2(200),           /*职责描述                               */
hrasa05     number(5,2)              /*责任程度                               */
);

alter table hrasa_file add  constraint tpc_hrasa_pk primary key  (hrasa01,hrasa02) enable validate;
grant select on hrasa_file to tiptopgp;
grant update on hrasa_file to tiptopgp;
grant delete on hrasa_file to tiptopgp;
grant insert on hrasa_file to tiptopgp;
grant index on hrasa_file to public;
grant select on hrasa_file to ods;
