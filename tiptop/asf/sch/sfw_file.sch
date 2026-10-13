/*
================================================================================
檔案代號:sfw_file
檔案名稱:工单重要备注资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfw_file
(
sfw01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
sfw02       number(5) NOT NULL,      /*行序号                                 */
                                     /*行序號                                 */
sfw03       varchar2(255),           /*重要备注                               */
                                     /*重要備註                               */
sfwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfwlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table sfw_file add  constraint sfw_pk primary key  (sfw01,sfw02) enable validate;
grant select on sfw_file to tiptopgp;
grant update on sfw_file to tiptopgp;
grant delete on sfw_file to tiptopgp;
grant insert on sfw_file to tiptopgp;
grant index on sfw_file to public;
grant select on sfw_file to ods;
