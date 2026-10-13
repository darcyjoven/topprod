/*
================================================================================
檔案代號:ppc_file
檔案名稱:供应商类型设置评价权数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ppc_file
(
ppc01       varchar2(10) NOT NULL,   /*厂商类型                               */
ppc02       varchar2(10) NOT NULL,   /*评核项目代码                           */
ppc03       number(15,3)             /*权数                                   */
);

alter table ppc_file add  constraint ppc_pk primary key  (ppc01,ppc02) enable validate;
grant select on ppc_file to tiptopgp;
grant update on ppc_file to tiptopgp;
grant delete on ppc_file to tiptopgp;
grant insert on ppc_file to tiptopgp;
grant index on ppc_file to public;
grant select on ppc_file to ods;
