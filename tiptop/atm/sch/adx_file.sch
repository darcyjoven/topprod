/*
================================================================================
檔案代號:adx_file
檔案名稱:分销系统参数档-销退单
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table adx_file
(
adx01       varchar2(10) NOT NULL,   /*拨出营运中心                           */
adx02       varchar2(5),             /*单别                                   */
adx03       varchar2(1),             /*销退处理方式                           */
adx04       varchar2(1),             /*No                                     */
adx05       varchar2(1),             /*No                                     */
adx06       varchar2(1),             /*No                                     */
adx07       varchar2(1),             /*No                                     */
adxacti     varchar2(1),             /*资料有效码                             */
adxuser     varchar2(10),            /*资料所有者                             */
adxgrup     varchar2(10),            /*资料所有部门                           */
adxmodu     varchar2(10),            /*资料更改者                             */
adxdate     date,                    /*最近更改日                             */
adxorig     varchar2(10),            /*资料建立部门                           */
adxoriu     varchar2(10)             /*资料建立者                             */
);

alter table adx_file add  constraint adx_pk primary key  (adx01) enable validate;
grant select on adx_file to tiptopgp;
grant update on adx_file to tiptopgp;
grant delete on adx_file to tiptopgp;
grant insert on adx_file to tiptopgp;
grant index on adx_file to public;
grant select on adx_file to ods;
