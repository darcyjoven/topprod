/*
================================================================================
檔案代號:pjy_file
檔案名稱:设备类型资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pjy_file
(
pjy01       varchar2(10) NOT NULL,   /*设备类型                               */
pjy02       varchar2(80),            /*设备名称                               */
pjy03       varchar2(4),             /*计价单位                               */
pjy04       number(20,6),            /*单位费用                               */
pjyacti     varchar2(1),             /*资料有效码                             */
pjydate     date,                    /*最近更改日                             */
pjygrup     varchar2(10),            /*资料所有部门                           */
pjymodu     varchar2(10),            /*资料更改者                             */
pjyuser     varchar2(10),            /*资料所有者                             */
pjy05       varchar2(10),            /*主类型                                 */
pjyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pjylegal    varchar2(10) NOT NULL,   /*所属法人                               */
pjyorig     varchar2(10),            /*资料建立部门                           */
pjyoriu     varchar2(10)             /*资料建立者                             */
);

alter table pjy_file add  constraint pjy_pk primary key  (pjy01) enable validate;
grant select on pjy_file to tiptopgp;
grant update on pjy_file to tiptopgp;
grant delete on pjy_file to tiptopgp;
grant insert on pjy_file to tiptopgp;
grant index on pjy_file to public;
grant select on pjy_file to ods;
