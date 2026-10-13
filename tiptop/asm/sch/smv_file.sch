/*
================================================================================
檔案代號:smv_file
檔案名稱:单别限使用部门明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smv_file
(
smv01       varchar2(6),             /*单    别                               */
                                     /*單    別                               */
smv02       varchar2(10),            /*设限使用部门                           */
                                     /*設限使用部門                           */
smv03       varchar2(3),             /*系统                                   */
                                     /*系統別                                 */
smv04       varchar2(1)              /*No Use                                 */
);

create        index smv_01 on smv_file (smv01,smv02,smv03);
grant select on smv_file to tiptopgp;
grant update on smv_file to tiptopgp;
grant delete on smv_file to tiptopgp;
grant insert on smv_file to tiptopgp;
grant index on smv_file to public;
grant select on smv_file to ods;
