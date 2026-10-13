/*
================================================================================
檔案代號:hratb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hratb_file
(
hratb01     varchar2(50) NOT NULL,   /* 员工编号                              */
hratb02     date NOT NULL,           /* 开始日期                              */
hratb03     date NOT NULL,           /* 结束日期                              */
hratb04     varchar2(100) NOT NULL,  /* 培训机构                              */
hratb05     varchar2(100),           /* 培训主题                              */
hratb06     varchar2(100),           /* 证书名称                              */
hratb07     varchar2(100),           /* 证书有效期                            */
hratb08     varchar2(255)            /* 备注                                  */
);

alter table hratb_file add  constraint tpc_hratb_pk primary key  (hratb01,hratb02,hratb03,hratb04) enable validate;
grant select on hratb_file to tiptopgp;
grant update on hratb_file to tiptopgp;
grant delete on hratb_file to tiptopgp;
grant insert on hratb_file to tiptopgp;
grant index on hratb_file to public;
grant select on hratb_file to ods;
