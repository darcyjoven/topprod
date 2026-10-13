/*
================================================================================
檔案代號:cxi_file
檔案名稱:杂项进出理由码会计科目设置明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cxi_file
(
cxi01       varchar2(10) NOT NULL,   /*部门编号                               */
cxi02       varchar2(10) NOT NULL,   /*理由码                                 */
cxi03       varchar2(1) NOT NULL,    /*单据分类                               */
cxi04       varchar2(24),            /*科目编号                               */
cxi05       varchar2(10),            /*成本归属部门                           */
cxi041      varchar2(24)             /*科目编号二                             */
);

alter table cxi_file add  constraint cxi_pk primary key  (cxi01,cxi02,cxi03) enable validate;
grant select on cxi_file to tiptopgp;
grant update on cxi_file to tiptopgp;
grant delete on cxi_file to tiptopgp;
grant insert on cxi_file to tiptopgp;
grant index on cxi_file to public;
grant select on cxi_file to ods;
