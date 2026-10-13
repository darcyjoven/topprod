/*
================================================================================
檔案代號:csd_file
檔案名稱:料件附加成本结构资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table csd_file
(
csd01       varchar2(40) NOT NULL,   /*料件编号                               */
csd02       varchar2(10) NOT NULL,   /*成本项目                               */
csd03       varchar2(1),             /*成本归类                               */
csd04       number(9,4),             /*比率                                   */
csd05       number(20,6)             /*金额                                   */
);

alter table csd_file add  constraint csd_pk primary key  (csd01,csd02) enable validate;
grant select on csd_file to tiptopgp;
grant update on csd_file to tiptopgp;
grant delete on csd_file to tiptopgp;
grant insert on csd_file to tiptopgp;
grant index on csd_file to public;
grant select on csd_file to ods;
