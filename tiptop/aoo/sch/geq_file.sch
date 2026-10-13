/*
================================================================================
檔案代號:geq_file
檔案名稱:自定义公式单身档（变数）
檔案目的:记录系统自定义公式使用的变数内容
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table geq_file
(
geq01       varchar2(20) NOT NULL,   /*公式编号                               */
geq02       number(5) NOT NULL,      /*项次                                   */
geq03       varchar2(10),            /*变数编号                               */
geq04       varchar2(80),            /*变数名称                               */
geq05       varchar2(2),             /*No Use                                 */
geq06       varchar2(4),             /*No Use                                 */
geq07       varchar2(1),             /*No Use                                 */
geq08       varchar2(1),             /*No Use                                 */
geq09       varchar2(4),             /*No Use                                 */
geq10       varchar2(4)              /*No Use                                 */
);

alter table geq_file add  constraint geq_pk primary key  (geq01,geq02) enable validate;
grant select on geq_file to tiptopgp;
grant update on geq_file to tiptopgp;
grant delete on geq_file to tiptopgp;
grant insert on geq_file to tiptopgp;
grant index on geq_file to public;
grant select on geq_file to ods;
