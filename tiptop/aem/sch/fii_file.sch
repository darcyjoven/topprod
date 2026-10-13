/*
================================================================================
檔案代號:fii_file
檔案名稱:设备系列型号资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fii_file
(
fii01       varchar2(30) NOT NULL,   /*系列号                                 */
fii02       varchar2(30) NOT NULL,   /*型号                                   */
fii03       varchar2(300),           /*安全说明                               */
fii04       varchar2(1),             /*No Use                                 */
fii05       varchar2(1),             /*No Use                                 */
fii06       varchar2(1),             /*No Use                                 */
fii07       varchar2(1),             /*No Use                                 */
fii08       varchar2(1),             /*No Use                                 */
fii09       varchar2(1),             /*No Use                                 */
fii10       varchar2(1),             /*No Use                                 */
fiiacti     varchar2(1),             /*资料有效码                             */
fiiuser     varchar2(10),            /*资料所有者                             */
fiigrup     varchar2(10),            /*资料所有部门                           */
fiimodu     varchar2(10),            /*最后更改人员                           */
fiidate     date,                    /*最后更改日期                           */
fiioriu     varchar2(10),            /*资料建立者                             */
fiiorig     varchar2(10)             /*资料建立部门                           */
);

alter table fii_file add  constraint fii_pk primary key  (fii01,fii02) enable validate;
grant select on fii_file to tiptopgp;
grant update on fii_file to tiptopgp;
grant delete on fii_file to tiptopgp;
grant insert on fii_file to tiptopgp;
grant index on fii_file to public;
grant select on fii_file to ods;
