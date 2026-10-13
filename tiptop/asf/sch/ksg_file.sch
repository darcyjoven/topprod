/*
================================================================================
檔案代號:ksg_file
檔案名稱:制造通知单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ksg_file
(
ksg01       varchar2(20) NOT NULL,   /*制造通知单号                           */
                                     /*製造通知單號                           */
ksg02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
ksg03       varchar2(40),            /*生产料号                               */
                                     /*生產料號                               */
ksg04       date,                    /*预计生产完工日期                       */
                                     /*預計生產完工日期                       */
ksg05       number(15,3),            /*计划数量                               */
                                     /*計劃數量                               */
ksg06       varchar2(1),             /*No Use                                 */
ksg07       date,                    /*有效日期                               */
ksg08       varchar2(1),             /*No Use                                 */
ksg09       varchar2(1),             /*结案否                                 */
                                     /*結案否                                 */
ksg10       number(10),              /*No Use                                 */
ksg11       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ksg12       date,                    /*No Use                                 */
ksg13       varchar2(1),             /*No Use                                 */
ksg14       varchar2(1),             /*No Use                                 */
ksg15       varchar2(1),             /*No Use                                 */
ksg930      varchar2(10),            /*成本中心                               */
ksgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ksglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index ksg_02 on ksg_file (ksg03);
alter table ksg_file add  constraint ksg_pk primary key  (ksg01,ksg02) enable validate;
grant select on ksg_file to tiptopgp;
grant update on ksg_file to tiptopgp;
grant delete on ksg_file to tiptopgp;
grant insert on ksg_file to tiptopgp;
grant index on ksg_file to public;
grant select on ksg_file to ods;
