/*
================================================================================
檔案代號:csb_file
檔案名稱:料件成本项目结构模拟资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table csb_file
(
csb01       varchar2(40) NOT NULL,   /*料件编号                               */
csb02       varchar2(1) NOT NULL,    /*模拟编号                               */
csb03       varchar2(1),             /*成本方式                               */
csb04       varchar2(10) NOT NULL,   /*成本项目                               */
csb05       number(20,6),            /*成本                                   */
csbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
csblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table csb_file add  constraint csb_pk primary key  (csb01,csb02,csb04) enable validate;
grant select on csb_file to tiptopgp;
grant update on csb_file to tiptopgp;
grant delete on csb_file to tiptopgp;
grant insert on csb_file to tiptopgp;
grant index on csb_file to public;
grant select on csb_file to ods;
