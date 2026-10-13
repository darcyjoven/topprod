/*
================================================================================
檔案代號:ppd_file
檔案名稱:供应商自定义项目评分档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ppd_file
(
ppd01       varchar2(6) NOT NULL,    /*评核年月                               */
ppd02       varchar2(10) NOT NULL,   /*厂商代码                               */
ppd03       varchar2(10) NOT NULL,   /*评核项目代码                           */
ppd04       number(8,4)              /*分数                                   */
);

alter table ppd_file add  constraint ppd_pk primary key  (ppd01,ppd02,ppd03) enable validate;
grant select on ppd_file to tiptopgp;
grant update on ppd_file to tiptopgp;
grant delete on ppd_file to tiptopgp;
grant insert on ppd_file to tiptopgp;
grant index on ppd_file to public;
grant select on ppd_file to ods;
