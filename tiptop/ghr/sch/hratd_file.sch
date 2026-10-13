/*
================================================================================
檔案代號:hratd_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hratd_file
(
hratd01     varchar2(50) NOT NULL,   /* 员工编号                              */
hratd02     varchar2(51) NOT NULL,   /* 家属姓名                              */
hratd03     varchar2(10) NOT NULL,   /* 与己关系                              */
hratd04     varchar2(100),           /* 所在单位                              */
hratd05     date,                    /* 出生日期                              */
hratd06     varchar2(100),           /* 担任职位                              */
hratd07     varchar2(20),            /* 联系电话                              */
hratd08     varchar2(20),            /* 手机号码                              */
hratd09     varchar2(255)            /* 备注                                  */
);

alter table hratd_file add  constraint tpc_hratd_pk primary key  (hratd01,hratd02,hratd03) enable validate;
grant select on hratd_file to tiptopgp;
grant update on hratd_file to tiptopgp;
grant delete on hratd_file to tiptopgp;
grant insert on hratd_file to tiptopgp;
grant index on hratd_file to public;
grant select on hratd_file to ods;
