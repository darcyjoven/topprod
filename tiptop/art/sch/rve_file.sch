/*
================================================================================
檔案代號:rve_file
檔案名稱:对账费用单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rve_file
(
rve00       varchar2(1) NOT NULL,    /*单据类型                               */
                                     /*Doc. Type                              */
rve01       varchar2(20) DEFAULT ' ' NOT NULL, /*对账单号*/
rve02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rve03       varchar2(10),            /*营运中心                               */
rve04       varchar2(20),            /*费用单号                               */
rve05       number(5),               /*费用项次                               */
rve06       varchar2(1),             /*对账否                                 */
rvelegal    varchar2(10) NOT NULL,   /*所属法人                               */
rveplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rve_file add  constraint rve_pk primary key  (rve00,rve01,rve02) enable validate;
grant select on rve_file to tiptopgp;
grant update on rve_file to tiptopgp;
grant delete on rve_file to tiptopgp;
grant insert on rve_file to tiptopgp;
grant index on rve_file to public;
grant select on rve_file to ods;
