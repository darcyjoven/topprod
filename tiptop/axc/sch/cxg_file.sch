/*
================================================================================
檔案代號:cxg_file
檔案名稱:单别成会分类设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cxg_file
(
cxg01       varchar2(5) NOT NULL,    /*单别                                   */
cxg02       varchar2(1) NOT NULL,    /*科目种类                               */
cxg03       varchar2(1) NOT NULL,    /*种类来源                               */
cxg04       varchar2(10) NOT NULL,   /*种类编号                               */
cxg05       varchar2(24),            /*科目编号                               */
cxg051      varchar2(24)             /*科目编号二                             */
);

alter table cxg_file add  constraint cxg_pk primary key  (cxg01,cxg02,cxg03,cxg04) enable validate;
grant select on cxg_file to tiptopgp;
grant update on cxg_file to tiptopgp;
grant delete on cxg_file to tiptopgp;
grant insert on cxg_file to tiptopgp;
grant index on cxg_file to public;
grant select on cxg_file to ods;
