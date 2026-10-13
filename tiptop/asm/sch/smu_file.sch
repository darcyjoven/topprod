/*
================================================================================
檔案代號:smu_file
檔案名稱:单别限定用户明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smu_file
(
smu01       varchar2(6),             /*单    别                               */
                                     /*單    別                               */
smu02       varchar2(10),            /*设限用户编号                           */
                                     /*設限使用者編號(Login user)             */
smu03       varchar2(3),             /*系统                                   */
smu04       varchar2(1)              /*No Use                                 */
);

create        index smu_01 on smu_file (smu01,smu02,smu03);
grant select on smu_file to tiptopgp;
grant update on smu_file to tiptopgp;
grant delete on smu_file to tiptopgp;
grant insert on smu_file to tiptopgp;
grant index on smu_file to public;
grant select on smu_file to ods;
