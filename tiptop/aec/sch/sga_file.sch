/*
================================================================================
檔案代號:sga_file
檔案名稱:单元工时基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sga_file
(
sga01       varchar2(10) NOT NULL,   /*单元工时编号                           */
sga02       varchar2(80),            /*单元名称                               */
sga03       varchar2(120),           /*单元规格                               */
sga04       number(15,3),            /*单元工时                               */
sga05       varchar2(255),           /*备注                                   */
sga06       number(15,3),            /*单元机时                               */
sgaacti     varchar2(1),             /*资料有效码                             */
sgauser     varchar2(10),            /*资料所有者                             */
sgagrup     varchar2(10),            /*资料所有群                             */
sgamodu     varchar2(10),            /*资料更改者                             */
sgadate     date,                    /*最近更改日                             */
sga07       varchar2(1) DEFAULT ' ' NOT NULL, /*可委外否*/
sgaslk02    number(8,4),             /*现实工时                               */
sgaslk03    number(20,6),            /*标准工价                               */
sgaslk04    number(20,6),            /*现实工价                               */
sga08       varchar2(1),             /*可报工否                               */
sgaorig     varchar2(10),            /*资料建立部门                           */
sgaoriu     varchar2(10)             /*资料建立者                             */
);

alter table sga_file add  constraint sga_pk primary key  (sga01) enable validate;
grant select on sga_file to tiptopgp;
grant update on sga_file to tiptopgp;
grant delete on sga_file to tiptopgp;
grant insert on sga_file to tiptopgp;
grant index on sga_file to public;
grant select on sga_file to ods;
