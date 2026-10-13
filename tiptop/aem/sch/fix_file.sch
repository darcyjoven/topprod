/*
================================================================================
檔案代號:fix_file
檔案名稱:保修项目人员资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fix_file
(
fix01       varchar2(10) NOT NULL,   /*项目编号                               */
fix02       number(5) NOT NULL,      /*项次                                   */
fix03       varchar2(6),             /*工种                                   */
fix04       number(8,3),             /*预计工时                               */
fix05       number(5),               /*人数                                   */
fix06       number(5),               /*优先级                                 */
fix07       varchar2(1),             /*No Use                                 */
fix08       varchar2(1),             /*No Use                                 */
fix09       varchar2(1),             /*No Use                                 */
fix10       varchar2(1)              /*No Use                                 */
);

alter table fix_file add  constraint fix_pk primary key  (fix01,fix02) enable validate;
grant select on fix_file to tiptopgp;
grant update on fix_file to tiptopgp;
grant delete on fix_file to tiptopgp;
grant insert on fix_file to tiptopgp;
grant index on fix_file to public;
grant select on fix_file to ods;
