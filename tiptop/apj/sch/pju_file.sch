/*
================================================================================
檔案代號:pju_file
檔案名稱:专案系统参数设定
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table pju_file
(
pju00       varchar2(1) DEFAULT ' ' NOT NULL, /*key value*/
pju01       varchar2(10),            /*费用原因(材料需求)                     */
pju02       varchar2(10),            /*费用原因(人力需求)                     */
pju03       varchar2(10),            /*费用原因(设备需求)                     */
pju04       varchar2(10),            /*费用原因(费用需求)                     */
pju05       varchar2(1),             /*no use                                 */
pju06       varchar2(1),             /*no use                                 */
pju07       varchar2(1),             /*no use                                 */
pju08       varchar2(1),             /*no use                                 */
pju09       varchar2(1),             /*no use                                 */
pju10       varchar2(1),             /*no use                                 */
pjuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pjulegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table pju_file add  constraint pju_pk primary key  (pju00) enable validate;
grant select on pju_file to tiptopgp;
grant update on pju_file to tiptopgp;
grant delete on pju_file to tiptopgp;
grant insert on pju_file to tiptopgp;
grant index on pju_file to public;
grant select on pju_file to ods;
