/*
================================================================================
檔案代號:srj_file
檔案名稱:报工资料 人员报工资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table srj_file
(
srj01       varchar2(20) NOT NULL,   /*报工单号                               */
srj02       number(5) NOT NULL,      /*项次                                   */
srj03       number(5),               /*报工项次                               */
srj04       varchar2(10),            /*员工编号                               */
srj05       number(15,3),            /*工时(分)                               */
srj06       number(15,3),            /*数量                                   */
srj08       varchar2(255),           /*备注                                   */
srj07       varchar2(1),             /*No Use                                 */
srjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
srjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table srj_file add  constraint srj_pk primary key  (srj01,srj02) enable validate;
grant select on srj_file to tiptopgp;
grant update on srj_file to tiptopgp;
grant delete on srj_file to tiptopgp;
grant insert on srj_file to tiptopgp;
grant index on srj_file to public;
grant select on srj_file to ods;
