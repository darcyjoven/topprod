/*
================================================================================
檔案代號:axm_file
檔案名稱:股东权益打印报表格式
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axm_file
(
axm01       varchar2(6) NOT NULL,    /*报表编号                               */
axm02       varchar2(80),            /*报表名称                               */
axm03       number(10) NOT NULL,     /*顺序                                   */
axm04       varchar2(8),             /*群组代码                               */
axm05       varchar2(80),            /*说明                                   */
axm06       varchar2(1),             /*No Use                                 */
axm07       varchar2(1),             /*No Use                                 */
axm08       varchar2(1),             /*No Use                                 */
axm00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
axm09       varchar2(1) DEFAULT ' ' NOT NULL, /*打印码*/
axm10       varchar2(1) DEFAULT ' ' NOT NULL, /*资料来源*/
axm11       number(5),               /*空格数                                 */
axm12       varchar2(1) DEFAULT ' ' NOT NULL
);

alter table axm_file add  constraint axm_pk primary key  (axm00,axm01,axm03) enable validate;
grant select on axm_file to tiptopgp;
grant update on axm_file to tiptopgp;
grant delete on axm_file to tiptopgp;
grant insert on axm_file to tiptopgp;
grant index on axm_file to public;
grant select on axm_file to ods;
