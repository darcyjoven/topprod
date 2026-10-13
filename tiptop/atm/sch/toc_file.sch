/*
================================================================================
檔案代號:toc_file
檔案名稱:广告素材维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table toc_file
(
toc01       varchar2(7) NOT NULL,    /*广告素材编号                           */
toc02       varchar2(40),            /*简称                                   */
toc03       varchar2(4),             /*素材类型                               */
toc04       varchar2(80),            /*素材名称                               */
toc05       varchar2(4),             /*素材单位                               */
toc06       varchar2(40),            /*品牌                                   */
toc07       varchar2(40),            /*品项                                   */
toc08       varchar2(255),           /*备注                                   */
toc09       varchar2(20),            /*预留字段                               */
toc10       varchar2(20),            /*预留字段                               */
toc11       varchar2(20),            /*预留字段                               */
tocacti     varchar2(1),             /*有效否                                 */
tocuser     varchar2(10),            /*建档人员                               */
tocgrup     varchar2(10),            /*建档部门                               */
tocmodu     varchar2(10),            /*最后更改人员                           */
tocdate     date,                    /*最近更改日期                           */
tocoriu     varchar2(10),            /*资料建立者                             */
tocorig     varchar2(10)             /*资料建立部门                           */
);

alter table toc_file add  constraint toc_pk primary key  (toc01) enable validate;
grant select on toc_file to tiptopgp;
grant update on toc_file to tiptopgp;
grant delete on toc_file to tiptopgp;
grant insert on toc_file to tiptopgp;
grant index on toc_file to public;
grant select on toc_file to ods;
