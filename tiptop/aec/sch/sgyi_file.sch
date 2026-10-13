/*
================================================================================
檔案代號:sgyi_file
檔案名稱:工单工艺单元变更档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgyi_file
(
sgyi01      varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
sgyi02      number(5) DEFAULT '0' NOT NULL, /*工艺序*/
sgyi03      number(5) DEFAULT '0' NOT NULL, /*变更序号*/
sgyi05      varchar2(10) DEFAULT ' ' NOT NULL, /*单元编号*/
sgyislk01   number(10),              /*原单元顺序                             */
sgyislk03   number(8,4),             /*原现实工时                             */
sgyislk04   number(20,6),            /*原标准工价                             */
sgyislk05   number(20,6),            /*原现实工价                             */
sgyislk06   number(10),              /*新单元顺序                             */
sgyislk08   number(8,4),             /*新现实工时                             */
sgyislk09   number(20,6),            /*新标准工价                             */
sgyislk10   number(20,6),            /*新现实工价                             */
sgyiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
sgyilegal   varchar2(10) NOT NULL,   /*所属法人                               */
sgyi012     varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sgyi_file add  constraint sgyi_pk primary key  (sgyi01,sgyi02,sgyi03,sgyi05,sgyi012) enable validate;
grant select on sgyi_file to tiptopgp;
grant update on sgyi_file to tiptopgp;
grant delete on sgyi_file to tiptopgp;
grant insert on sgyi_file to tiptopgp;
grant index on sgyi_file to public;
grant select on sgyi_file to ods;
