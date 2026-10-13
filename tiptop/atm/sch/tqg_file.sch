/*
================================================================================
檔案代號:tqg_file
檔案名稱:渠道关系单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqg_file
(
tqg01       varchar2(10) NOT NULL,   /*上级通路代码                           */
tqg02       number(5) NOT NULL,      /*项次                                   */
tqg03       varchar2(10),            /*下级通路代码                           */
tqg04       date,                    /*生效日期                               */
tqg05       date                     /*失效日期                               */
);

create        index tqg_02 on tqg_file (tqg01,tqg03);
alter table tqg_file add  constraint tqg_pk primary key  (tqg01,tqg02) enable validate;
grant select on tqg_file to tiptopgp;
grant update on tqg_file to tiptopgp;
grant delete on tqg_file to tiptopgp;
grant insert on tqg_file to tiptopgp;
grant index on tqg_file to public;
grant select on tqg_file to ods;
