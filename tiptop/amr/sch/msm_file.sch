/*
================================================================================
檔案代號:msm_file
檔案名稱:备料指定送货地点档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msm_file
(
msm01       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
msm02       varchar2(10) NOT NULL,   /*地址编号                               */
                                     /*地址代號                               */
msm03       varchar2(10) NOT NULL,   /*仓库编号                               */
                                     /*倉庫代號                               */
msm04       varchar2(20),            /*库位                                   */
                                     /*儲位                                   */
msm05       varchar2(24),            /*批号                                   */
                                     /*批號                                   */
msm06       varchar2(10) NOT NULL,   /*生产部门                               */
                                     /*生產部門                               */
msm07       varchar2(255)            /*备注                                   */
                                     /*備註                                   */
);

alter table msm_file add  constraint msm_pk primary key  (msm01,msm06) enable validate;
grant select on msm_file to tiptopgp;
grant update on msm_file to tiptopgp;
grant delete on msm_file to tiptopgp;
grant insert on msm_file to tiptopgp;
grant index on msm_file to public;
grant select on msm_file to ods;
