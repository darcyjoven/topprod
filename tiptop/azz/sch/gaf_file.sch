/*
================================================================================
檔案代號:gaf_file
檔案名稱:流程定义单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gaf_file
(
gaf01       varchar2(10) NOT NULL,   /*流程编号                               */
gaf02       varchar2(40),            /*流程简称                               */
gaf03       varchar2(255),           /*说明                                   */
gaf04       varchar2(1),             /*是否为自动作业生成的资料               */
gaf05       varchar2(1),             /*No Use                                 */
gaf06       varchar2(1),             /*No Use                                 */
gafacti     varchar2(1),             /*资料有效码                             */
gafuser     varchar2(10),            /*资料所有者                             */
gafgrup     varchar2(10),            /*资料所有部门                           */
gafmodu     varchar2(10),            /*资料更改者                             */
gafdate     date,                    /*最近更改日                             */
gaforiu     varchar2(10),            /*资料建立者                             */
gaforig     varchar2(10)             /*资料建立部门                           */
);

alter table gaf_file add  constraint gaf_pk primary key  (gaf01) enable validate;
grant select on gaf_file to tiptopgp;
grant update on gaf_file to tiptopgp;
grant delete on gaf_file to tiptopgp;
grant insert on gaf_file to tiptopgp;
grant index on gaf_file to public;
grant select on gaf_file to ods;
