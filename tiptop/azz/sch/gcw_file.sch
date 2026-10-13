/*
================================================================================
檔案代號:gcw_file
檔案名稱:CR报表档名设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gcw_file
(
gcw01       varchar2(10) NOT NULL,   /*程序编号                               */
gcw02       varchar2(20) NOT NULL,   /*样板编号                               */
gcw03       varchar2(10) NOT NULL,   /*权限类型                               */
gcw04       varchar2(10) NOT NULL,   /*用户                                   */
gcw05       varchar2(1),             /*报表档案命名第一段                     */
gcw06       varchar2(1),             /*报表档案命名第二段                     */
gcw07       varchar2(1),             /*报表档案命名第三段                     */
gcw08       varchar2(1),             /*报表档案命名第四段                     */
gcw09       varchar2(1),             /*报表档案命名第五段                     */
gcw10       varchar2(1),             /*报表档案命名第六段                     */
gcw11       varchar2(1) DEFAULT 'Y' NOT NULL, /*重复时覆写*/
gcw12       varchar2(5) DEFAULT ' ' NOT NULL /*行业别*/
);

alter table gcw_file add  constraint gcw_pk primary key  (gcw01,gcw02,gcw03,gcw04,gcw12) enable validate;
grant select on gcw_file to tiptopgp;
grant update on gcw_file to tiptopgp;
grant delete on gcw_file to tiptopgp;
grant insert on gcw_file to tiptopgp;
grant index on gcw_file to public;
grant select on gcw_file to ods;
