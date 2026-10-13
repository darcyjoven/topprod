/*
================================================================================
檔案代號:pjw_file
檔案名稱:poc取得方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pjw_file
(
pjw01       varchar2(10) NOT NULL,   /*方式编号                               */
pjw02       varchar2(80),            /*说明                                   */
pjw03       varchar2(1),             /*类型                                   */
pjw04       number(10),              /*起始值                                 */
pjw05       number(10),              /*上限值                                 */
pjwacti     varchar2(1),             /*资料有效码                             */
pjwdate     date,                    /*最近更改日                             */
pjwgrup     varchar2(10),            /*资料所有部门                           */
pjwmodu     varchar2(10),            /*资料更改者                             */
pjwuser     varchar2(10),            /*资料所有者                             */
pjwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pjwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pjworig     varchar2(10),            /*资料建立部门                           */
pjworiu     varchar2(10)             /*资料建立者                             */
);

alter table pjw_file add  constraint pjw_pk primary key  (pjw01) enable validate;
grant select on pjw_file to tiptopgp;
grant update on pjw_file to tiptopgp;
grant delete on pjw_file to tiptopgp;
grant insert on pjw_file to tiptopgp;
grant index on pjw_file to public;
grant select on pjw_file to ods;
