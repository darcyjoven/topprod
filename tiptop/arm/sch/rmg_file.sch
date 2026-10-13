/*
================================================================================
檔案代號:rmg_file
檔案名稱:RMA 人工工资率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmg_file
(
rmg01       date NOT NULL,           /*生效日期                               */
rmg02       number(20,6),            /*工资单价($/hr)                         */
                                     /*工資單價($/hr)                         */
rmguser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rmggrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
rmgmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
rmgdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
rmgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmglegal    varchar2(10) NOT NULL,   /*所属法人                               */
rmgorig     varchar2(10),            /*资料建立部门                           */
rmgoriu     varchar2(10)             /*资料建立者                             */
);

alter table rmg_file add  constraint rmg_pk primary key  (rmg01) enable validate;
grant select on rmg_file to tiptopgp;
grant update on rmg_file to tiptopgp;
grant delete on rmg_file to tiptopgp;
grant insert on rmg_file to tiptopgp;
grant index on rmg_file to public;
grant select on rmg_file to ods;
