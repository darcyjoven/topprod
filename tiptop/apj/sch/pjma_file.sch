/*
================================================================================
檔案代號:pjma_file
檔案名稱:wbs本阶设备需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjma_file
(
pjma01      varchar2(30) NOT NULL,   /*本阶wbs编码                            */
pjma02      number(5) NOT NULL,      /*项次                                   */
pjma03      varchar2(10),            /*设备类型                               */
pjma04      number(10),              /*台数                                   */
pjma05      number(15,3),            /*需求量(使用时间)                       */
pjmaacti    varchar2(1),             /*资料有效码                             */
pjmadate    date,                    /*最近更改日                             */
pjmagrup    varchar2(10),            /*资料所有部门                           */
pjmamodu    varchar2(10),            /*资料更改者                             */
pjmauser    varchar2(10),            /*资料所有者                             */
pjmaorig    varchar2(10),            /*资料建立部门                           */
pjmaoriu    varchar2(10)             /*资料建立者                             */
);

alter table pjma_file add  constraint pjma_pk primary key  (pjma01,pjma02) enable validate;
grant select on pjma_file to tiptopgp;
grant update on pjma_file to tiptopgp;
grant delete on pjma_file to tiptopgp;
grant insert on pjma_file to tiptopgp;
grant index on pjma_file to public;
grant select on pjma_file to ods;
