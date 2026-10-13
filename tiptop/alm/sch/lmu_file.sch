/*
================================================================================
檔案代號:lmu_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmu_file
(
lmu01       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lmu02       varchar2(30),            /*No Use                                 */
lmu03       varchar2(1),             /*No Use                                 */
lmu04       varchar2(30) DEFAULT ' ' NOT NULL, /*No Use*/
lmu05       number(20,2),            /*No Use                                 */
lmu06       varchar2(4),             /*No Use                                 */
lmupos      varchar2(1) DEFAULT ' ' NOT NULL /*No Use*/
);

alter table lmu_file add  constraint lmu_pk primary key  (lmu01,lmu04) enable validate;
grant select on lmu_file to tiptopgp;
grant update on lmu_file to tiptopgp;
grant delete on lmu_file to tiptopgp;
grant insert on lmu_file to tiptopgp;
grant index on lmu_file to public;
grant select on lmu_file to ods;
