/*
================================================================================
檔案代號:shp_file
檔案名稱:RUN CARD分割资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shp_file
(
shp01       varchar2(20) NOT NULL,   /*分割单号                               */
                                     /*分割單號                               */
shp02       date,                    /*分割日期                               */
shp03       varchar2(23),            /*Run Card                               */
shp04       number(5),               /*工艺顺序                               */
                                     /*製程順序                               */
shp05       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
shp06       number(15,3),            /*WIP 数量                               */
                                     /*WIP 數量                               */
shp07       varchar2(10),            /*员工编号                               */
                                     /*員工編號                               */
shp08       varchar2(1),             /*No Use                                 */
shp09       varchar2(1),             /*WIP数量                                */
shp10       varchar2(1),             /*No Use                                 */
shpconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
shptime     varchar2(5),             /*分割时间                               */
                                     /*分割時間                               */
shpacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
shpuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
shpgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
shpmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
shpdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
shpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shplegal    varchar2(10) NOT NULL,   /*所属法人                               */
shporiu     varchar2(10),            /*资料建立者                             */
shporig     varchar2(10),            /*资料建立部门                           */
shp012      varchar2(10)             /*工艺段号                               */
);

create        index shp_02 on shp_file (shp03);
alter table shp_file add  constraint shp_pk primary key  (shp01) enable validate;
grant select on shp_file to tiptopgp;
grant update on shp_file to tiptopgp;
grant delete on shp_file to tiptopgp;
grant insert on shp_file to tiptopgp;
grant index on shp_file to public;
grant select on shp_file to ods;
