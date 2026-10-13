/*
================================================================================
檔案代號:ppb_file
檔案名稱:供应商给分标准明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ppb_file
(
ppb01       varchar2(10) NOT NULL,   /*评核项目代码                           */
ppb02       number(15,6) NOT NULL,   /*差异比率                               */
ppb03       number(8,4)              /*分数                                   */
);

alter table ppb_file add  constraint ppb_pk primary key  (ppb01,ppb02) enable validate;
grant select on ppb_file to tiptopgp;
grant update on ppb_file to tiptopgp;
grant delete on ppb_file to tiptopgp;
grant insert on ppb_file to tiptopgp;
grant index on ppb_file to public;
grant select on ppb_file to ods;
