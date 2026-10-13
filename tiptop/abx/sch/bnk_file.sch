/*
================================================================================
檔案代號:bnk_file
檔案名稱:委外加工核准函档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bnk_file
(
bnk01       varchar2(8) NOT NULL,    /*核准函号码                             */
bnk02       varchar2(10),            /*厂商编号                               */
bnk03       date,                    /*申请日期                               */
bnk04       date,                    /*截止日期                               */
bnk05       varchar2(1)              /*是否展延                               */
                                     /*(Y/N)                                  */
);

alter table bnk_file add  constraint bnk_pk primary key  (bnk01) enable validate;
grant select on bnk_file to tiptopgp;
grant update on bnk_file to tiptopgp;
grant delete on bnk_file to tiptopgp;
grant insert on bnk_file to tiptopgp;
grant index on bnk_file to public;
grant select on bnk_file to ods;
