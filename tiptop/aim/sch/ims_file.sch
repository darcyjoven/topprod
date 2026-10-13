/*
================================================================================
檔案代號:ims_file
檔案名稱:营运中心调拨拨出单档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ims_file
(
ims01       varchar2(20) NOT NULL,   /*拨出单号                               */
                                     /*撥出單號                               */
ims02       number(5) NOT NULL,      /*拨出项次                               */
                                     /*撥出項次                               */
ims03       varchar2(20),            /*调拨单号                               */
                                     /*調撥單號                               */
ims04       number(5),               /*调拨项次                               */
                                     /*調撥項次                               */
ims05       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
ims06       number(15,3),            /*实拨数量                               */
                                     /*實撥數量                               */
ims07       number(15,3),            /*已拨入数量                             */
                                     /*已撥入數量                             */
ims08       varchar2(10),            /*拨出营运中心                           */
                                     /*撥出工廠                               */
ims09       varchar2(10),            /*拨入营运中心                           */
                                     /*撥入工廠                               */
ims10       date,                    /*审核日期                               */
                                     /*確認日期                               */
ims11       varchar2(10),            /*审核人                                 */
                                     /*確認人                                 */
ims12       varchar2(1),             /*No Use                                 */
ims13       varchar2(1),             /*No Use                                 */
ims14       number(15,3),            /*实拨单位一数量                         */
ims15       number(15,3),            /*实拨单位二数量                         */
imsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index ims_02 on ims_file (ims03);
alter table ims_file add  constraint ims_pk primary key  (ims01,ims02) enable validate;
grant select on ims_file to tiptopgp;
grant update on ims_file to tiptopgp;
grant delete on ims_file to tiptopgp;
grant insert on ims_file to tiptopgp;
grant index on ims_file to public;
grant select on ims_file to ods;
