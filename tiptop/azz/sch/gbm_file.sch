/*
================================================================================
檔案代號:gbm_file
檔案名稱:查询条件纪录单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbm_file
(
gbm01       number(10) NOT NULL,     /*QBE序号                                */
gbm02       varchar2(10),            /*用户                                   */
gbm03       varchar2(20),            /*程序编号                               */
gbm04       varchar2(20),            /*查询条件代码                           */
gbm05       varchar2(1500),          /*说明                                   */
gbm06       varchar2(1),             /*缺省QBE                                */
gbm07       varchar2(1),             /*查询时是否直接带入                     */
gbm08       varchar2(1),             /*是否分享                               */
gbm09       varchar2(2000)           /*No Use                                 */
);

create unique index gbm_02 on gbm_file (gbm02,gbm03,gbm04);
alter table gbm_file add  constraint gbm_pk primary key  (gbm01) enable validate;
grant select on gbm_file to tiptopgp;
grant update on gbm_file to tiptopgp;
grant delete on gbm_file to tiptopgp;
grant insert on gbm_file to tiptopgp;
grant index on gbm_file to public;
grant select on gbm_file to ods;
