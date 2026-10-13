/*
================================================================================
檔案代號:std_file
檔案名稱:成本系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table std_file
(
std00       varchar2(1),             /*KEY VALUE                              */
                                     /*KEY : '0'                              */
std01       number(5) NOT NULL,      /*成本系统关帐年度                       */
std02       number(5)                /*成本系统关帐月份                       */
);

alter table std_file add  constraint std_pk primary key  (std01) enable validate;
grant select on std_file to tiptopgp;
grant update on std_file to tiptopgp;
grant delete on std_file to tiptopgp;
grant insert on std_file to tiptopgp;
grant index on std_file to public;
grant select on std_file to ods;
