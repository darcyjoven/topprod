/*
================================================================================
檔案代號:zap_file
檔案名稱:定义查询 output
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zap_file
(
zap01       varchar2(80) NOT NULL,   /*查询单id                               */
zap02       number(5),               /*报表打印的行数                         */
zap03       number(5),               /*报表上边界                             */
zap04       number(5),               /*报表左边界                             */
zap05       number(5),               /*报表下边界                             */
zap06       number(10),              /*报表最大查询笔数                       */
zap07       varchar2(1) NOT NULL     /*客制码                                 */
);

alter table zap_file add  constraint zap_pk primary key  (zap01,zap07) enable validate;
grant select on zap_file to tiptopgp;
grant update on zap_file to tiptopgp;
grant delete on zap_file to tiptopgp;
grant insert on zap_file to tiptopgp;
grant index on zap_file to public;
grant select on zap_file to ods;
