/*
================================================================================
檔案代號:sgb_file
檔案名稱:异常除外编号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sgb_file
(
sgb01       varchar2(6) NOT NULL,    /*异常编号                               */
sgb02       varchar2(1),             /*No Use                                 */
sgb03       varchar2(1),             /*责任部门                               */
sgb04       varchar2(10),            /*属性                                   */
sgb05       varchar2(80),            /*异常说明                               */
sgb06       varchar2(24)             /*会计科目                               */
);

alter table sgb_file add  constraint sgb_pk primary key  (sgb01) enable validate;
grant select on sgb_file to tiptopgp;
grant update on sgb_file to tiptopgp;
grant delete on sgb_file to tiptopgp;
grant insert on sgb_file to tiptopgp;
grant index on sgb_file to public;
grant select on sgb_file to ods;
