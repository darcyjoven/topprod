/*
================================================================================
檔案代號:gdg_file
檔案名稱:报表服务器参数设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdg_file
(
gdg01       varchar2(20) DEFAULT ' ' NOT NULL,
gdg02       number(5) DEFAULT '0' NOT NULL,
gdg03       varchar2(255),           /*VpWebService URL                       */
gdg04       varchar2(20),
gdg05       varchar2(20),
gdg06       varchar2(20),
gdg07       varchar2(20) DEFAULT ' ' NOT NULL, /*目录*/
gdg08       varchar2(20) DEFAULT ' ' NOT NULL,
gdg09       number(5) DEFAULT '0' NOT NULL,
gdg10       varchar2(255)            /*VpWebService URL                       */
);

alter table gdg_file add  constraint gdg_pk primary key  (gdg01,gdg02,gdg08,gdg09) enable validate;
grant select on gdg_file to tiptopgp;
grant update on gdg_file to tiptopgp;
grant delete on gdg_file to tiptopgp;
grant insert on gdg_file to tiptopgp;
grant index on gdg_file to public;
grant select on gdg_file to ods;
