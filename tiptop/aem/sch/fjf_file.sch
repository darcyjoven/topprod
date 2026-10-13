/*
================================================================================
檔案代號:fjf_file
檔案名稱:设备位置单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fjf_file
(
fjf01       varchar2(20) NOT NULL,   /*上层位置                               */
fjf02       varchar2(20) NOT NULL,   /*设备存放营运中心                       */
fjf03       varchar2(1),             /*No Use                                 */
fjf04       varchar2(1),             /*No Use                                 */
fjf05       varchar2(1),             /*No Use                                 */
fjf06       varchar2(1),             /*No Use                                 */
fjf07       varchar2(1),             /*No Use                                 */
fjf08       varchar2(1),             /*No Use                                 */
fjf09       varchar2(1),             /*No Use                                 */
fjf10       varchar2(1),             /*No Use                                 */
fjfacti     varchar2(1),             /*资料有效码                             */
fjfuser     varchar2(10),            /*资料所有者                             */
fjfgrup     varchar2(10),            /*资料所有部门                           */
fjfmodu     varchar2(10),            /*最后更改人员                           */
fjfdate     date,                    /*最后更改日期                           */
fjforiu     varchar2(10),            /*资料建立者                             */
fjforig     varchar2(10)             /*资料建立部门                           */
);

alter table fjf_file add  constraint fjf_pk primary key  (fjf01,fjf02) enable validate;
grant select on fjf_file to tiptopgp;
grant update on fjf_file to tiptopgp;
grant delete on fjf_file to tiptopgp;
grant insert on fjf_file to tiptopgp;
grant index on fjf_file to public;
grant select on fjf_file to ods;
