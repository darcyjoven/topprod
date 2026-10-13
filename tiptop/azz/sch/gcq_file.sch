/*
================================================================================
檔案代號:gcq_file
檔案名稱:触发器建立资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gcq_file
(
gcq01       varchar2(40) DEFAULT ' ' NOT NULL, /*触发器代码*/
gcq02       varchar2(40) DEFAULT ' ' NOT NULL, /*触发器名称*/
gcq03       varchar2(40),            /*表名                                   */
gcq04       varchar2(1500),          /*触发器说明                             */
gcq05       varchar2(1) DEFAULT 'n' NOT NULL, /*已经建立*/
gcq06       varchar2(1) DEFAULT 'n' NOT NULL, /*设为共用*/
gcq07       varchar2(1500),          /*触发器内容                             */
gcq08       varchar2(1) DEFAULT 'n' NOT NULL, /*触发时机*/
gcq09       varchar2(1),             /*insert                                 */
gcq10       varchar2(1),             /*delete                                 */
gcq11       varchar2(1),             /*update                                 */
gcq12       varchar2(1),             /*for each row                           */
gcq13       varchar2(1)              /*新旧值                                 */
);

alter table gcq_file add  constraint gcq_pk primary key  (gcq02) enable validate;
grant select on gcq_file to tiptopgp;
grant update on gcq_file to tiptopgp;
grant delete on gcq_file to tiptopgp;
grant insert on gcq_file to tiptopgp;
grant index on gcq_file to public;
grant select on gcq_file to ods;
