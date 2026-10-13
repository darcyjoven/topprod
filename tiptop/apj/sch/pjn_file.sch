/*
================================================================================
檔案代號:pjn_file
檔案名稱:项目里程碑活动设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjn_file
(
pjn01       varchar2(10) NOT NULL,   /*项目编号                               */
pjn02       varchar2(4) NOT NULL,    /*里程碑编号                             */
pjn03       varchar2(80),            /*里程碑名称                             */
pjn04       varchar2(1),             /*WBS/活动                               */
pjn05       varchar2(30),            /*WBS/活动                               */
pjn06       number(15,6),            /*目标完工率                             */
pjn07       number(15,6),            /*目标收款率                             */
pjn08       number(15,3),            /*预计完工偏置期（天）                   */
pjn09       varchar2(1),             /*有无触发事件                           */
pjnacti     varchar2(1),             /*资料有效码                             */
pjndate     date,                    /*最近更改日                             */
pjngrup     varchar2(10),            /*资料所有部门                           */
pjnmodu     varchar2(10),            /*资料更改者                             */
pjnuser     varchar2(10),            /*资料所有者                             */
pjnorig     varchar2(10),            /*资料建立部门                           */
pjnoriu     varchar2(10)             /*资料建立者                             */
);

alter table pjn_file add  constraint pjn_pk primary key  (pjn01,pjn02) enable validate;
grant select on pjn_file to tiptopgp;
grant update on pjn_file to tiptopgp;
grant delete on pjn_file to tiptopgp;
grant insert on pjn_file to tiptopgp;
grant index on pjn_file to public;
grant select on pjn_file to ods;
