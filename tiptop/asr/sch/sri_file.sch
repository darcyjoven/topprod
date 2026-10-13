/*
================================================================================
檔案代號:sri_file
檔案名稱:报工资料 不良原因资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sri_file
(
sri01       varchar2(20) NOT NULL,   /*报工单号                               */
sri02       number(5) NOT NULL,      /*项次                                   */
sri03       number(5),               /*报工项次                               */
sri04       varchar2(10),            /*不良原因编号                           */
sri05       number(15,3),            /*不良数量                               */
sri06       varchar2(255),           /*备注                                   */
sri07       varchar2(1),             /*No Use                                 */
sriplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
srilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table sri_file add  constraint sri_pk primary key  (sri01,sri02) enable validate;
grant select on sri_file to tiptopgp;
grant update on sri_file to tiptopgp;
grant delete on sri_file to tiptopgp;
grant insert on sri_file to tiptopgp;
grant index on sri_file to public;
grant select on sri_file to ods;
