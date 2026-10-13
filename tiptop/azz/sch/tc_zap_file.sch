/*
================================================================================
檔案代號:tc_zap_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zap_file
(
zap01       varchar2(80) NOT NULL,   /*查询单id                               */
zap02       number(5),               /*报表打印的行数                         */
zap03       number(5),               /*报表上边界                             */
zap04       number(5),               /*报表左边界                             */
zap05       number(5),               /*报表下边界                             */
zap06       number(10),              /*报表最大查询笔数                       */
zap07       varchar2(1) NOT NULL     /*客制码                                 */
);

grant select on tc_zap_file to tiptopgp;
grant update on tc_zap_file to tiptopgp;
grant delete on tc_zap_file to tiptopgp;
grant insert on tc_zap_file to tiptopgp;
grant index on tc_zap_file to public;
grant select on tc_zap_file to ods;
