/*
================================================================================
檔案代號:gek_file
檔案名稱:独立段资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gek_file
(
gek01       varchar2(10) NOT NULL,   /*独立段编号                             */
gek02       number(5) NOT NULL,      /*项次                                   */
gek03       varchar2(30),            /*编码编号                               */
gek04       varchar2(80),            /*编码名称                               */
gek05       varchar2(1),             /*No Use                                 */
gek06       varchar2(1),             /*No Use                                 */
gek07       varchar2(1),             /*No Use                                 */
gek08       varchar2(1)              /*No Use                                 */
);

alter table gek_file add  constraint gek_pk primary key  (gek01,gek02) enable validate;
grant select on gek_file to tiptopgp;
grant update on gek_file to tiptopgp;
grant delete on gek_file to tiptopgp;
grant insert on gek_file to tiptopgp;
grant index on gek_file to public;
grant select on gek_file to ods;
