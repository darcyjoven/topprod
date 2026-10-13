/*
================================================================================
檔案代號:hrath_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrath_file
(
hrath01     varchar2(50) NOT NULL,   /* 员工编号                              */
hrath02     varchar2(50) NOT NULL,   /* 联系人                                */
hrath03     varchar2(10) NOT NULL,   /* 与己关系                              */
hrath04     varchar2(50),            /* 联系电话                              */
hrath05     varchar2(50),            /* 手机号                                */
hrath06     varchar2(50),            /* 邮箱                                  */
hrath07     varchar2(50),            /* 邮政编码                              */
hrath08     varchar2(255),           /* 联系地址                              */
hrath09     varchar2(255)            /* 备注                                  */
);

alter table hrath_file add  constraint tpc_hrath_pk primary key  (hrath01,hrath02,hrath03) enable validate;
grant select on hrath_file to tiptopgp;
grant update on hrath_file to tiptopgp;
grant delete on hrath_file to tiptopgp;
grant insert on hrath_file to tiptopgp;
grant index on hrath_file to public;
grant select on hrath_file to ods;
