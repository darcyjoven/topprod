/*
================================================================================
檔案代號:cez_file
檔案名稱:电子合同参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table cez_file
(
cez00       varchar2(1) DEFAULT ' ' NOT NULL, /*KEY VALUE*/
cez01       varchar2(1),             /*目前海关系统可开放给用户               */
cez02       varchar2(1),             /*预设海关代号否                         */
cez03       varchar2(10),            /*海关编号                               */
cez04       varchar2(20),            /*手册编号                               */
cezud01     varchar2(255),           /*自订字段                               */
cezud02     varchar2(40),            /*自订字段                               */
cezud03     varchar2(40),            /*自订字段                               */
cezud04     varchar2(40),            /*自订字段                               */
cezud05     varchar2(40),            /*自订字段                               */
cezud06     varchar2(255),           /*自订字段                               */
cezud07     number(15,3),            /*自订字段                               */
cezud08     number(15,3),            /*自订字段                               */
cezud09     number(15,3),            /*自订字段                               */
cezud10     number(10),              /*自订字段                               */
cezud11     number(10),              /*自订字段                               */
cezud12     number(10),              /*自订字段                               */
cezud13     date,                    /*自订字段                               */
cezud14     date,                    /*自订字段                               */
cezud15     date                     /*自订字段                               */
);

alter table cez_file add  constraint cez_pk primary key  (cez00) enable validate;
grant select on cez_file to tiptopgp;
grant update on cez_file to tiptopgp;
grant delete on cez_file to tiptopgp;
grant insert on cez_file to tiptopgp;
grant index on cez_file to public;
grant select on cez_file to ods;
