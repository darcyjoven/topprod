/*
================================================================================
檔案代號:fjg_file
檔案名稱:设备位置单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fjg_file
(
fjg01       varchar2(20) NOT NULL,   /*上层位置                               */
fjg02       varchar2(20) NOT NULL,   /*项次                                   */
fjg03       number(5) NOT NULL,      /*下层位置                               */
fjg04       varchar2(20),            /*设备下层位置营运中心                   */
fjg05       varchar2(20),            /*营运中心编号                           */
fjg06       varchar2(1),             /*No Use                                 */
fjg07       varchar2(1),             /*No Use                                 */
fjg08       varchar2(1),             /*No Use                                 */
fjg09       varchar2(1),             /*No Use                                 */
fjg10       varchar2(1)              /*No Use                                 */
);

alter table fjg_file add  constraint fjg_pk primary key  (fjg01,fjg02,fjg03) enable validate;
grant select on fjg_file to tiptopgp;
grant update on fjg_file to tiptopgp;
grant delete on fjg_file to tiptopgp;
grant insert on fjg_file to tiptopgp;
grant index on fjg_file to public;
grant select on fjg_file to ods;
