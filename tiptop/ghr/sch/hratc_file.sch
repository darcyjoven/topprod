/*
================================================================================
檔案代號:hratc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hratc_file
(
hratc01     varchar2(50) NOT NULL,   /* 员工编号                              */
hratc02     date NOT NULL,           /* 开始日期                              */
hratc03     date NOT NULL,           /* 结束日期                              */
hratc04     varchar2(100),           /* 院校名称                              */
hratc05     varchar2(100),           /* 院校性质                              */
hratc06     varchar2(100),           /* 主修专业                              */
hratc07     varchar2(100),           /* 毕业类型                              */
hratc08     varchar2(10),            /* 学历情况                              */
hratc09     varchar2(10),            /* 学位情况                              */
hratc10     varchar2(10),            /* 学制                                  */
hratc11     varchar2(10),            /* 职务                                  */
hratc12     varchar2(10),            /* 证明人                                */
hratc13     varchar2(255)            /* 备注                                  */
);

alter table hratc_file add  constraint tpc_hratc_pk primary key  (hratc01,hratc02,hratc03) enable validate;
grant select on hratc_file to tiptopgp;
grant update on hratc_file to tiptopgp;
grant delete on hratc_file to tiptopgp;
grant insert on hratc_file to tiptopgp;
grant index on hratc_file to public;
grant select on hratc_file to ods;
