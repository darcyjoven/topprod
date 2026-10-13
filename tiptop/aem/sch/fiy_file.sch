/*
================================================================================
檔案代號:fiy_file
檔案名稱:保修项目备件资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fiy_file
(
fiy01       varchar2(10) NOT NULL,   /*项目编号                               */
fiy02       number(5) NOT NULL,      /*项次                                   */
fiy03       varchar2(40),            /*备件编号                               */
fiy04       varchar2(4),             /*单位                                   */
fiy05       number(15,3),            /*人数                                   */
fiy06       varchar2(1),             /*必需否                                 */
fiy07       varchar2(1),             /*No Use                                 */
fiy08       varchar2(1),             /*No Use                                 */
fiy09       varchar2(1),             /*No Use                                 */
fiy10       varchar2(1)              /*No Use                                 */
);

alter table fiy_file add  constraint fiy_pk primary key  (fiy01,fiy02) enable validate;
grant select on fiy_file to tiptopgp;
grant update on fiy_file to tiptopgp;
grant delete on fiy_file to tiptopgp;
grant insert on fiy_file to tiptopgp;
grant index on fiy_file to public;
grant select on fiy_file to ods;
