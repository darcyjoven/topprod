/*
================================================================================
檔案代號:fje_file
檔案名稱:工单类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fje_file
(
fje01       varchar2(4) NOT NULL,    /*工单类型编号                           */
fje02       varchar2(80),            /*说明                                   */
fje03       varchar2(1),             /*性质                                   */
fje04       varchar2(1),             /*No Use                                 */
fje05       varchar2(1),             /*No Use                                 */
fje06       varchar2(1),             /*No Use                                 */
fje07       varchar2(1),             /*No Use                                 */
fje08       varchar2(1),             /*No Use                                 */
fje09       varchar2(1),             /*No Use                                 */
fje10       varchar2(1)              /*No Use                                 */
);

alter table fje_file add  constraint fje_pk primary key  (fje01) enable validate;
grant select on fje_file to tiptopgp;
grant update on fje_file to tiptopgp;
grant delete on fje_file to tiptopgp;
grant insert on fje_file to tiptopgp;
grant index on fje_file to public;
grant select on fje_file to ods;
