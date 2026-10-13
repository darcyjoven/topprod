/*
================================================================================
檔案代號:ppe_file
檔案名稱:成本交期质量评价分数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ppe_file
(
ppe01       varchar2(6) NOT NULL,    /*年月                                   */
ppe02       varchar2(10) NOT NULL,   /*厂商编号                               */
ppe03       varchar2(10) NOT NULL,   /*评核项目                               */
ppe04       number(8,4),             /*分数                                   */
ppe05       number(15,3),            /*加权                                   */
ppe06       number(15,3),            /*加权后分数                             */
ppe07       number(15,3),            /*修正后分数                             */
ppedate     date,                    /*最近更改日                             */
ppegrup     varchar2(10),            /*资料所有部门                           */
ppemodu     varchar2(10),            /*资料更改者                             */
ppeuser     varchar2(10),            /*资料所有者                             */
ppeorig     varchar2(10),            /*资料建立部门                           */
ppeoriu     varchar2(10)             /*资料建立者                             */
);

alter table ppe_file add  constraint ppe_pk primary key  (ppe01,ppe02,ppe03) enable validate;
grant select on ppe_file to tiptopgp;
grant update on ppe_file to tiptopgp;
grant delete on ppe_file to tiptopgp;
grant insert on ppe_file to tiptopgp;
grant index on ppe_file to public;
grant select on ppe_file to ods;
