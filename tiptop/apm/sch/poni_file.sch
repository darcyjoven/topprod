/*
================================================================================
檔案代號:poni_file
檔案名稱:无交期性采购单(行业别架构)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table poni_file
(
poni01      varchar2(20) DEFAULT ' ' NOT NULL, /*采购单号 pmm01*/
poni02      number(10) DEFAULT '0' NOT NULL, /*项次,采购单所含盖的项目编号*/
ponislk01   varchar2(20),            /*制单号                                 */
poniplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
ponilegal   varchar2(10) NOT NULL,   /*所属法人                               */
ponislk02   number(5),               /*料件项次                               */
ponislk03   varchar2(40)             /*料件编号                               */
);

alter table poni_file add  constraint poni_pk primary key  (poni01,poni02) enable validate;
grant select on poni_file to tiptopgp;
grant update on poni_file to tiptopgp;
grant delete on poni_file to tiptopgp;
grant insert on poni_file to tiptopgp;
grant index on poni_file to public;
grant select on poni_file to ods;
