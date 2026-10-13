/*
================================================================================
檔案代號:pjg_file
檔案名稱:费用编号名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjg_file
(
pjg01       varchar2(10) NOT NULL,   /*费用编号                               */
pjg02       varchar2(80),            /*费用名称                               */
pjg03       varchar2(24),            /*缺省会计科目一                         */
pjg04       varchar2(24),            /*缺省会计科目二                         */
pjg05       varchar2(1),             /*费用性质                               */
pjgacti     varchar2(1),             /*资料有效码                             */
pjgdate     date,                    /*最近更改日                             */
pjggrup     varchar2(10),            /*资料所有部门                           */
pjgmodu     varchar2(10),            /*资料更改者                             */
pjguser     varchar2(10),            /*资料所有者                             */
pjgorig     varchar2(10),            /*资料建立部门                           */
pjgoriu     varchar2(10)             /*资料建立者                             */
);

alter table pjg_file add  constraint pjg_pk primary key  (pjg01) enable validate;
grant select on pjg_file to tiptopgp;
grant update on pjg_file to tiptopgp;
grant delete on pjg_file to tiptopgp;
grant insert on pjg_file to tiptopgp;
grant index on pjg_file to public;
grant select on pjg_file to ods;
