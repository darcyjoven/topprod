/*
================================================================================
檔案代號:fjd_file
檔案名稱:设备系列型号资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fjd_file
(
fjd01       varchar2(30) NOT NULL,   /*系列号                                 */
fjd02       varchar2(30) NOT NULL,   /*型号                                   */
fjd03       number(5) NOT NULL,      /*项次                                   */
fjd04       varchar2(70),            /*文件路径档名                           */
fjd05       varchar2(1),             /*No Use                                 */
fjd06       varchar2(1),             /*No Use                                 */
fjd07       varchar2(1),             /*No Use                                 */
fjd08       varchar2(1),             /*No Use                                 */
fjd09       varchar2(1)              /*No Use                                 */
);

alter table fjd_file add  constraint fjd_pk primary key  (fjd01,fjd02,fjd03) enable validate;
grant select on fjd_file to tiptopgp;
grant update on fjd_file to tiptopgp;
grant delete on fjd_file to tiptopgp;
grant insert on fjd_file to tiptopgp;
grant index on fjd_file to public;
grant select on fjd_file to ods;
