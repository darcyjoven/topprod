/*
================================================================================
檔案代號:axj_file
檔案名稱:调整与销除分录底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table axj_file
(
axj00       varchar2(5) NOT NULL,    /*帐套                                   */
axj01       varchar2(20) NOT NULL,   /*凭证编号                               */
axj02       number(5) NOT NULL,      /*项次                                   */
axj03       varchar2(24),            /*科目编号                               */
axj04       varchar2(80),            /*摘要                                   */
axj05       varchar2(15),            /*关系人/客户,厂商名称                   */
axj06       varchar2(1),             /*借贷别                                 */
axj07       number(20,6) NOT NULL,   /*异动金额                               */
axj08       varchar2(1),             /*No Use                                 */
axj09       varchar2(1),             /*No Use                                 */
axj10       varchar2(1),             /*No Use                                 */
axj11       varchar2(1),             /*No Use                                 */
axj12       varchar2(1),             /*No Use                                 */
axjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
axj13       number(5)                /*冲销组别                               */
);

create        index axj_03 on axj_file (axj00,axj01,axj03,axj06);
create        index axj_02 on axj_file (axj03);
alter table axj_file add  constraint axj_pk primary key  (axj01,axj02,axj00) enable validate;
grant select on axj_file to tiptopgp;
grant update on axj_file to tiptopgp;
grant delete on axj_file to tiptopgp;
grant insert on axj_file to tiptopgp;
grant index on axj_file to public;
grant select on axj_file to ods;
