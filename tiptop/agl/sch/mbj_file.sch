/*
================================================================================
檔案代號:mbj_file
檔案名稱:报表格式单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mbj_file
(
mbj01       varchar2(6) DEFAULT ' ' NOT NULL, /*报表编号*/
mbj02       number(9,4) DEFAULT '0' NOT NULL, /*项次*/
mbj03       varchar2(1) DEFAULT ' ' NOT NULL, /*打印码*/
mbj04       number(5),               /*空行数                                 */
mbj05       number(5),               /*空格数                                 */
mbj06       varchar2(1) DEFAULT ' ' NOT NULL, /*金额来源*/
mbj07       varchar2(1) DEFAULT ' ' NOT NULL, /*正常余额类型*/
mbj08       number(5),               /*合计阶数                               */
mbj09       varchar2(1) DEFAULT ' ' NOT NULL, /*加减*/
mbj11       varchar2(1) DEFAULT ' ' NOT NULL, /*是否为百分比基准科目*/
mbj20       varchar2(255),           /*科目打印名称                           */
mbj20e      varchar2(80),            /*额外打印名称                           */
mbj23       varchar2(2),             /*类型                                   */
mbj26       number(5),               /*项次                                   */
mbj27       varchar2(256),           /*计算公式(月)                           */
mbj28       varchar2(256)            /*计算公式(年)                           */
);

create unique index mbj_01 on mbj_file (mbj01,mbj02);
alter table mbj_file add  constraint mbj_pk primary key  (mbj01,mbj02) enable validate;
grant select on mbj_file to tiptopgp;
grant update on mbj_file to tiptopgp;
grant delete on mbj_file to tiptopgp;
grant insert on mbj_file to tiptopgp;
grant index on mbj_file to public;
grant select on mbj_file to ods;
