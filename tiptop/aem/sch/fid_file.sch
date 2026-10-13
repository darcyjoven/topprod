/*
================================================================================
檔案代號:fid_file
檔案名稱:作业资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fid_file
(
fid01       varchar2(10) NOT NULL,   /*作业编号                               */
fid02       varchar2(80),            /*说明                                   */
fid03       number(8,3),             /*预备工时,单位小时                      */
fid04       number(8,3),             /*标准工时,单位小时                      */
fid05       varchar2(1),             /*No                                     */
fid06       varchar2(1),             /*No                                     */
fid07       varchar2(1),             /*No                                     */
fid08       varchar2(1),             /*No                                     */
fid09       varchar2(1),             /*No                                     */
fid10       varchar2(1),             /*No                                     */
fidacti     varchar2(1),             /*资料有效码                             */
fiduser     varchar2(10),            /*资料所有者                             */
fidgrup     varchar2(10),            /*资料所有部门                           */
fidmodu     varchar2(10),            /*最后更改人员                           */
fiddate     date,                    /*最后更改日期                           */
fidoriu     varchar2(10),            /*资料建立者                             */
fidorig     varchar2(10)             /*资料建立部门                           */
);

alter table fid_file add  constraint fid_pk primary key  (fid01) enable validate;
grant select on fid_file to tiptopgp;
grant update on fid_file to tiptopgp;
grant delete on fid_file to tiptopgp;
grant insert on fid_file to tiptopgp;
grant index on fid_file to public;
grant select on fid_file to ods;
