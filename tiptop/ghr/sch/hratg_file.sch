/*
================================================================================
檔案代號:hratg_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hratg_file
(
hratg01     varchar2(50) NOT NULL,   /* 员工编号                              */
hratg02     varchar2(50) NOT NULL,   /* 职称信息                              */
hratg03     date NOT NULL,           /* 获得日期                              */
hratg04     varchar2(50),            /* 所在单位                              */
hratg05     varchar2(50),            /* 职称描述                              */
hratg06     varchar2(255)            /* 备注                                  */
);

alter table hratg_file add  constraint tpc_hratg_pk primary key  (hratg01,hratg02,hratg03) enable validate;
grant select on hratg_file to tiptopgp;
grant update on hratg_file to tiptopgp;
grant delete on hratg_file to tiptopgp;
grant insert on hratg_file to tiptopgp;
grant index on hratg_file to public;
grant select on hratg_file to ods;
