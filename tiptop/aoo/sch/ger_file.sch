/*
================================================================================
檔案代號:ger_file
檔案名稱:自定义公式单身档（表达式）
檔案目的:记录系统自定义公式使用的表达式内容
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ger_file
(
ger01       varchar2(20) NOT NULL,   /*公式编号                               */
ger02       number(5) NOT NULL,      /*项次                                   */
ger03       varchar2(20),            /*表达式编号                             */
ger04       varchar2(80),            /*表达式名称                             */
ger05       varchar2(2),             /*No Use                                 */
ger06       varchar2(4),             /*No Use                                 */
ger07       varchar2(1),             /*No Use                                 */
ger08       varchar2(1),             /*No Use                                 */
ger09       varchar2(4),             /*No Use                                 */
ger10       varchar2(4)              /*No Use                                 */
);

alter table ger_file add  constraint ger_pk primary key  (ger01,ger02) enable validate;
grant select on ger_file to tiptopgp;
grant update on ger_file to tiptopgp;
grant delete on ger_file to tiptopgp;
grant insert on ger_file to tiptopgp;
grant index on ger_file to public;
grant select on ger_file to ods;
