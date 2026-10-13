/*
================================================================================
檔案代號:pjx_file
檔案名稱:技能单位费用档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pjx_file
(
pjx01       varchar2(10) NOT NULL,   /*技能代码                               */
pjx02       varchar2(4),             /*单位                                   */
pjx03       number(20,6),            /*单位费用                               */
pjxacti     varchar2(1),             /*资料有效码                             */
pjxdate     date,                    /*最近更改日                             */
pjxgrup     varchar2(10),            /*资料所有部门                           */
pjxmodu     varchar2(10),            /*资料更改者                             */
pjxuser     varchar2(10),            /*资料所有者                             */
pjx04       varchar2(1),             /*直间接                                 */
pjxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pjxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pjxorig     varchar2(10),            /*资料建立部门                           */
pjxoriu     varchar2(10)             /*资料建立者                             */
);

alter table pjx_file add  constraint pjx_pk primary key  (pjx01) enable validate;
grant select on pjx_file to tiptopgp;
grant update on pjx_file to tiptopgp;
grant delete on pjx_file to tiptopgp;
grant insert on pjx_file to tiptopgp;
grant index on pjx_file to public;
grant select on pjx_file to ods;
