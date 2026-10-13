/*
================================================================================
檔案代號:gde_file
檔案名稱:背景作业单头纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gde_file
(
gde01       varchar2(40) DEFAULT ' ' NOT NULL, /*作业名称*/
gde02       varchar2(80),            /*说明                                   */
gde03       varchar2(1),             /*启动否                                 */
gde04       varchar2(1),             /*周期                                   */
gde05       varchar2(80),            /*小时                                   */
gde06       varchar2(255),           /*分钟                                   */
gde07       varchar2(15),            /*周                                     */
gde08       varchar2(40),            /*月                                     */
gde09       varchar2(100),           /*日                                     */
gde10       varchar2(80),            /*批次档（Script）路径                   */
gde11       date,                    /*执行一次的日期                         */
gde12       varchar2(10) DEFAULT ' ' NOT NULL, /*用？*/
gde13       date,                    /*上次执行的完成时间                     */
gde14       varchar2(1),             /*上次执行的结果                         */
gde15       date DEFAULT sysdate NOT NULL, /*最近更改日期*/
gde16       date,
gde17       varchar2(80),
gde18       varchar2(1),
gde19       varchar2(1)
);

alter table gde_file add  constraint gde_pk primary key  (gde01,gde12) enable validate;
grant select on gde_file to tiptopgp;
grant update on gde_file to tiptopgp;
grant delete on gde_file to tiptopgp;
grant insert on gde_file to tiptopgp;
grant index on gde_file to public;
grant select on gde_file to ods;
