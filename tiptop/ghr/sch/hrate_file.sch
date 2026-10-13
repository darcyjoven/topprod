/*
================================================================================
檔案代號:hrate_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrate_file
(
hrate01     varchar2(50) NOT NULL,   /* 员工编号                              */
hrate02     varchar2(50) NOT NULL,   /* 语种                                  */
hrate03     varchar2(50),            /* 听力能力                              */
hrate04     varchar2(50),            /* 会话能力                              */
hrate05     varchar2(50),            /* 书写能力                              */
hrate06     varchar2(50),            /* 等级状况                              */
hrate07     varchar2(50),            /* 证书级别                              */
hrate08     varchar2(255)            /* 备注                                  */
);

alter table hrate_file add  constraint tpc_hrate_pk primary key  (hrate01,hrate02) enable validate;
grant select on hrate_file to tiptopgp;
grant update on hrate_file to tiptopgp;
grant delete on hrate_file to tiptopgp;
grant insert on hrate_file to tiptopgp;
grant index on hrate_file to public;
grant select on hrate_file to ods;
