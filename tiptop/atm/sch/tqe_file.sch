/*
================================================================================
檔案代號:tqe_file
檔案名稱:销售理由码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqe_file
(
tqe01       varchar2(10) NOT NULL,   /*原因代码                               */
tqe02       varchar2(80),            /*原因描述                               */
tqe03       varchar2(1),             /*用途                                   */
tqe04       varchar2(1),             /*是否是搭赠                             */
tqe05       varchar2(1),             /*是否计算业绩                           */
tqe06       varchar2(24),            /*财务科目编号                           */
tqe07       varchar2(24),            /*管理科目编号                           */
tqe08       varchar2(1),             /*是否是拒收                             */
tqe09       varchar2(80),            /*财务科目摘要                           */
tqe10       varchar2(80),            /*管理科目摘要                           */
tqe11       varchar2(1),             /*是否影响呆滞日期                       */
tqe12       varchar2(1),             /*帮助促进对象                           */
tqeacti     varchar2(1),             /*资料有效码                             */
tqeuser     varchar2(10),            /*资料所有者                             */
tqegrup     varchar2(10),            /*资料所有部门                           */
tqemodu     varchar2(10),            /*资料更改者                             */
tqedate     date,                    /*最近更改日                             */
tqeorig     varchar2(10),            /*资料建立部门                           */
tqeoriu     varchar2(10)             /*资料建立者                             */
);

alter table tqe_file add  constraint tqe_pk primary key  (tqe01) enable validate;
grant select on tqe_file to tiptopgp;
grant update on tqe_file to tiptopgp;
grant delete on tqe_file to tiptopgp;
grant insert on tqe_file to tiptopgp;
grant index on tqe_file to public;
grant select on tqe_file to ods;
