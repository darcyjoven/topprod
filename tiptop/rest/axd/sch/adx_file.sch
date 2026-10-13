/*
================================================================================
檔案代號:adx_file
檔案名稱:流通配銷系統參數檔-銷退單
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adx_file
(
adx01       varchar2(10),            /*撥出營運中心                           */
adx02       varchar2(5),             /*單別                                   */
adx03       varchar2(1),             /*銷退處理方式                           */
adx04       varchar2(1),             /*No                                     */
adx05       varchar2(1),             /*No                                     */
adx06       varchar2(1),             /*No                                     */
adx07       varchar2(1),             /*No                                     */
adxacti     varchar2(1),             /*資料有效碼                             */
adxuser     varchar2(10),            /*資料所有者                             */
adxgrup     varchar2(6),             /*資料所有部門                           */
adxmodu     varchar2(10),            /*資料修改者                             */
adxdate     date                     /*最近修改日                             */
);

create unique index adx_01 on adx_file (adx01);
grant select on adx_file to public;
grant index on adx_file to public;
grant update on adx_file to public;
grant delete on adx_file to public;
grant insert on adx_file to public;
