/*
================================================================================
檔案代號:pod_file
檔案名稱:代采买多角贸易参数设置作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table pod_file
(
pod00       varchar2(1) NOT NULL,    /*Key Value = '0'                        */
pod01       varchar2(1),             /*代采买三角贸易使用汇率                 */
pod02       varchar2(1),             /*是否允许采购单价为零                   */
                                     /*入庫拋轉時單價是否重新計算             */
pod03       varchar2(1),             /*入库抛转时单价是否重新计算             */
                                     /*no use                                 */
pod04       varchar2(1),             /*一单到底                               */
pod05       varchar2(1),             /*是否于单据审核时自动抛转               */
pod06       varchar2(1),             /*No Use                                 */
pod07       varchar2(1),             /*No Use                                 */
podud01     varchar2(255),           /*自订字段                               */
podud02     varchar2(40),            /*自订字段                               */
podud03     varchar2(40),            /*自订字段                               */
podud04     varchar2(40),            /*自订字段                               */
podud05     varchar2(40),            /*自订字段                               */
podud06     varchar2(255),           /*自订字段                               */
podud07     number(15,3),            /*自订字段                               */
podud08     number(15,3),            /*自订字段                               */
podud09     number(15,3),            /*自订字段                               */
podud10     number(10),              /*自订字段                               */
podud11     number(10),              /*自订字段                               */
podud12     number(10),              /*自订字段                               */
podud13     date,                    /*自订字段                               */
podud14     date,                    /*自订字段                               */
podud15     date,                    /*自订字段                               */
pod08       varchar2(1) DEFAULT 'N' NOT NULL /*多角抛转时，批号需一并抛转*/
);

alter table pod_file add  constraint pod_pk primary key  (pod00) enable validate;
grant select on pod_file to tiptopgp;
grant update on pod_file to tiptopgp;
grant delete on pod_file to tiptopgp;
grant insert on pod_file to tiptopgp;
grant index on pod_file to public;
grant select on pod_file to ods;
