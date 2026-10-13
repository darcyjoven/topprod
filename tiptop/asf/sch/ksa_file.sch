/*
================================================================================
檔案代號:ksa_file
檔案名稱:拆件式工单 FQC 单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ksa_file
(
ksa01       varchar2(20) NOT NULL,   /*FQC 编号                               */
                                     /*FQC 編號                               */
ksa02       date,                    /*FQC 日期                               */
ksa04       varchar2(10),            /*部门                                   */
                                     /*部門                                   */
ksa05       varchar2(10),            /*理由                                   */
ksa06       varchar2(10),            /*项目                                   */
                                     /*專案                                   */
ksa07       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ksa08       varchar2(20),            /*PBI No.                                */
                                     /*PBI#                                   */
ksa09       varchar2(1),             /*No Use                                 */
ksa10       varchar2(1),             /*No Use                                 */
ksa11       varchar2(1),             /*No Use                                 */
ksa12       varchar2(1),             /*No Use                                 */
ksapost     varchar2(1),             /*过帐否                                 */
                                     /*過帳否                                 */
ksauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ksagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ksamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ksadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ksaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ksalegal    varchar2(10) NOT NULL,   /*所属法人                               */
ksaorig     varchar2(10),            /*资料建立部门                           */
ksaoriu     varchar2(10)             /*资料建立者                             */
);

alter table ksa_file add  constraint ksa_pk primary key  (ksa01) enable validate;
grant select on ksa_file to tiptopgp;
grant update on ksa_file to tiptopgp;
grant delete on ksa_file to tiptopgp;
grant insert on ksa_file to tiptopgp;
grant index on ksa_file to public;
grant select on ksa_file to ods;
