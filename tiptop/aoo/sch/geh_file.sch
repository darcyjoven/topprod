/*
================================================================================
檔案代號:geh_file
檔案名稱:编码性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table geh_file
(
geh01       varchar2(2) NOT NULL,    /*性质                                   */
geh02       varchar2(80),            /*说明                                   */
geh03       varchar2(15),            /*档案名称                               */
geh04       varchar2(1),             /*类型                                   */
geh05       varchar2(10),            /*索引值                                 */
gehacti     varchar2(1),             /*资料有效码                             */
gehuser     varchar2(10),            /*资料所有者                             */
gehgrup     varchar2(10),            /*资料所有部门                           */
gehmodu     varchar2(10),            /*资料更改者                             */
gehdate     date,                    /*最近更改日                             */
gehorig     varchar2(10),            /*资料建立部门                           */
gehoriu     varchar2(10)             /*资料建立者                             */
);

alter table geh_file add  constraint geh_pk primary key  (geh01) enable validate;
grant select on geh_file to tiptopgp;
grant update on geh_file to tiptopgp;
grant delete on geh_file to tiptopgp;
grant insert on geh_file to tiptopgp;
grant index on geh_file to public;
grant select on geh_file to ods;
