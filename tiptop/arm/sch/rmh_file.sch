/*
================================================================================
檔案代號:rmh_file
檔案名稱:非key part盘点资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmh_file
(
rmh01       number(5) NOT NULL,      /*资料年度                               */
                                     /*資料年度                               */
rmh02       number(5) NOT NULL,      /*资料月份                               */
                                     /*資料月份                               */
rmh03       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
rmh04       varchar2(10) NOT NULL,   /*RMA仓库                                */
                                     /*RMA倉庫別                              */
rmh05       varchar2(10) NOT NULL,   /*RMA仓库位                              */
                                     /*RMA倉儲位                              */
rmh06       varchar2(24),            /*RMA仓批号                              */
                                     /*RMA倉批號                              */
rmh07       number(15,3),            /*现有库存量                             */
                                     /*現有庫存量                             */
rmh08       varchar2(4),             /*库存单位                               */
                                     /*庫存單位                               */
rmh09       number(15,3),            /*盘点存量                               */
                                     /*盤點存量                               */
rmh10       number(15,3),            /*本期用量                               */
rmh11       date,                    /*抛转日期                               */
                                     /*拋轉日期: 本資料拋轉為雜發單之日期     */
rmh12       varchar2(20),            /*抛转用料单号                           */
                                     /*拋轉用料單號                           */
rmh13       number(5),               /*抛转用料单号项次                       */
                                     /*拋轉用料單號項次                       */
rmh14       varchar2(10),            /*盘点人员                               */
                                     /*盤點人員                               */
rmh15       date,                    /*盘点日期                               */
                                     /*盤點日期                               */
rmhud01     varchar2(255),           /*自订字段-Textedit                      */
rmhud02     varchar2(40),            /*自订字段-文字                          */
rmhud03     varchar2(40),            /*自订字段-文字                          */
rmhud04     varchar2(40),            /*自订字段-文字                          */
rmhud05     varchar2(40),            /*自订字段-文字                          */
rmhud06     varchar2(40),            /*自订字段-文字                          */
rmhud07     number(15,3),            /*自订字段-数值                          */
rmhud08     number(15,3),            /*自订字段-数值                          */
rmhud09     number(15,3),            /*自订字段-数值                          */
rmhud10     number(10),              /*自订字段-整数                          */
rmhud11     number(10),              /*自订字段-整数                          */
rmhud12     number(10),              /*自订字段-整数                          */
rmhud13     date,                    /*自订字段-日期                          */
rmhud14     date,                    /*自订字段-日期                          */
rmhud15     date,                    /*自订字段-日期                          */
rmhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rmh_file add  constraint rmh_pk primary key  (rmh01,rmh02,rmh03,rmh04,rmh05) enable validate;
grant select on rmh_file to tiptopgp;
grant update on rmh_file to tiptopgp;
grant delete on rmh_file to tiptopgp;
grant insert on rmh_file to tiptopgp;
grant index on rmh_file to public;
grant select on rmh_file to ods;
