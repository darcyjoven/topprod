/*
================================================================================
檔案代號:srh_file
檔案名稱:报工资料 异常&例外资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table srh_file
(
srh01       varchar2(20) NOT NULL,   /*报工单号                               */
srh02       number(5) NOT NULL,      /*项次                                   */
srh03       number(5),               /*报工项次                               */
srh04       varchar2(10),            /*异常编号                               */
srh05       number(15,3),            /*异常例外工时                           */
srh06       varchar2(255),           /*备注                                   */
srh07       varchar2(1),             /*No Use                                 */
srhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
srhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table srh_file add  constraint srh_pk primary key  (srh01,srh02) enable validate;
grant select on srh_file to tiptopgp;
grant update on srh_file to tiptopgp;
grant delete on srh_file to tiptopgp;
grant insert on srh_file to tiptopgp;
grant index on srh_file to public;
grant select on srh_file to ods;
