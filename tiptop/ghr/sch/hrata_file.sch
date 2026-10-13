/*
================================================================================
檔案代號:hrata_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrata_file
(
hrata01     varchar2(50) NOT NULL,   /* 员工编号                              */
hrata02     date NOT NULL,           /* 开始日期                              */
hrata03     date NOT NULL,           /* 结束日期                              */
hrata04     varchar2(100),           /* 单位名称                              */
hrata05     varchar2(100),           /* 单位性质                              */
hrata06     varchar2(100),           /* 担任职务                              */
hrata07     varchar2(100),           /* 薪资情况                              */
hrata08     varchar2(255)            /* 离职原因                              */
);

alter table hrata_file add  constraint tpc_hrata_pk primary key  (hrata01,hrata02,hrata03) enable validate;
grant select on hrata_file to tiptopgp;
grant update on hrata_file to tiptopgp;
grant delete on hrata_file to tiptopgp;
grant insert on hrata_file to tiptopgp;
grant index on hrata_file to public;
grant select on hrata_file to ods;
