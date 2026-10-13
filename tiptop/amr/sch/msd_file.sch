/*
================================================================================
檔案代號:msd_file
檔案名稱:MPS 计划变更单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table msd_file
(
msd01       varchar2(20) NOT NULL,   /*MPS 计划变更单号                       */
                                     /*MPS 計劃變更單號                       */
msd02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
msd03       varchar2(20),            /*计划编号                               */
                                     /*計劃編號                               */
msd04       varchar2(1),             /*变异码                                 */
                                     /*變異別 1.修改 2.新增                   */
msd05       number(5),               /*项次                                   */
                                     /*項次                                   */
msd06       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
msd07       date,                    /*生产日期                               */
                                     /*生產日期                               */
msd08       date,                    /*BOM 有效日期                           */
msd09       number(15,3),            /*变更前数量                             */
                                     /*變更前數量                             */
msd10       number(15,3),            /*变更后数量                             */
                                     /*變更後數量                             */
msd11       varchar2(40),            /*主料料号                               */
                                     /*主料料號                               */
msd12       varchar2(1),             /*变更原因                               */
                                     /*變更原因                               */
msd13       varchar2(255),           /*备    注                               */
                                     /*備    註                               */
msdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
msdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index msd_02 on msd_file (msd03);
create        index msd_03 on msd_file (msd06);
alter table msd_file add  constraint msd_pk primary key  (msd01,msd02) enable validate;
grant select on msd_file to tiptopgp;
grant update on msd_file to tiptopgp;
grant delete on msd_file to tiptopgp;
grant insert on msd_file to tiptopgp;
grant index on msd_file to public;
grant select on msd_file to ods;
