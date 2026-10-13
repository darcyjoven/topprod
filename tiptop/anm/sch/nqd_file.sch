/*
================================================================================
檔案代號:nqd_file
檔案名稱:自定义类型设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nqd_file
(
nqd01       varchar2(3) NOT NULL,    /*类型编号                               */
nqd02       varchar2(80),            /*类型说明                               */
nqd03       varchar2(1),             /*所属变动分类(1/2/3)                    */
nqd04       varchar2(1),             /*1.固定类型 2.自定义类型                */
nqd05       varchar2(1),             /*No Use                                 */
nqdacti     varchar2(1),             /*资料有效码                             */
nqduser     varchar2(10),            /*资料所有者                             */
nqdgrup     varchar2(10),            /*资料所有群                             */
nqdmodu     varchar2(10),            /*资料更改者                             */
nqddate     date,                    /*最近更改日                             */
nqdorig     varchar2(10),            /*资料建立部门                           */
nqdoriu     varchar2(10)             /*资料建立者                             */
);

alter table nqd_file add  constraint nqd_pk primary key  (nqd01) enable validate;
grant select on nqd_file to tiptopgp;
grant update on nqd_file to tiptopgp;
grant delete on nqd_file to tiptopgp;
grant insert on nqd_file to tiptopgp;
grant index on nqd_file to public;
grant select on nqd_file to ods;
