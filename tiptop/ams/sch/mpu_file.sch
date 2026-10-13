/*
================================================================================
檔案代號:mpu_file
檔案名稱:工单日期调整档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mpu_file
(
mpu_v       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
mpu01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
mpu02       date,                    /*开工日期                               */
                                     /*開工日期                               */
mpu03       date,                    /*完工日期                               */
mpuacti     varchar2(1),             /*资料有效码                             */
mpuuser     varchar2(10),            /*资料所有者                             */
mpugrup     varchar2(10),            /*资料所有群                             */
mpumodu     varchar2(10),            /*资料更改者                             */
mpudate     date,                    /*最近更改日                             */
mpuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mpulegal    varchar2(10) NOT NULL,   /*所属法人                               */
mpuoriu     varchar2(10),            /*资料建立者                             */
mpuorig     varchar2(10)             /*资料建立部门                           */
);

alter table mpu_file add  constraint mpu_pk primary key  (mpu_v,mpu01) enable validate;
grant select on mpu_file to tiptopgp;
grant update on mpu_file to tiptopgp;
grant delete on mpu_file to tiptopgp;
grant insert on mpu_file to tiptopgp;
grant index on mpu_file to public;
grant select on mpu_file to ods;
