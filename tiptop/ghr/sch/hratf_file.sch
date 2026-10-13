/*
================================================================================
檔案代號:hratf_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hratf_file
(
hratf01     varchar2(50) NOT NULL,   /* 员工编号                              */
hratf02     varchar2(50) NOT NULL,   /* 档案编号                              */
hratf03     varchar2(1),             /* 转入转出                              */
hratf04     varchar2(50),            /* 档案单位                              */
hratf05     varchar2(50),            /* 承办人                                */
hratf06     varchar2(50),            /* 承办日期                              */
hratf07     varchar2(255)            /* 备注                                  */
);

alter table hratf_file add  constraint tpc_hratf_pk primary key  (hratf01,hratf02) enable validate;
grant select on hratf_file to tiptopgp;
grant update on hratf_file to tiptopgp;
grant delete on hratf_file to tiptopgp;
grant insert on hratf_file to tiptopgp;
grant index on hratf_file to public;
grant select on hratf_file to ods;
