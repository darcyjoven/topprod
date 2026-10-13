/*
================================================================================
檔案代號:sfh_file
檔案名稱:工单完工统计资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table sfh_file
(
sfh01       varchar2(40),            /*工单单号                               */
                                     /*工單編號                               */
sfh02       date,                    /*异动日期                               */
                                     /*異動日期                               */
                                     /*記錄工單異動日期                       */
sfh03       varchar2(1),             /*资料种类                               */
                                     /*資料種類                               */
                                     /* 1. 完工全檢                           */
                                     /* 2. 全檢入庫                           */
                                     /* 3. 完工入庫                           */
                                     /* 4. 作業完工                           */
                                     /* 5. 再加工回                           */
sfh04       varchar2(40),            /*原生产料件                             */
                                     /*原生產料件                             */
sfh05       varchar2(40),            /*完工料件编号                           */
                                     /*完工料件編號                           */
sfh06       number(15,3),            /*完工套数                               */
                                     /*完工套數                               */
sfh07       varchar2(4),             /*完工单位                               */
                                     /*完工單位                               */
sfh08       varchar2(10),            /*完工入库仓库                           */
                                     /*完工入庫倉庫別                         */
sfh09       varchar2(10),            /*完工入库库位                           */
sfh10       varchar2(24),            /*完工入库批号                           */
sfh11       varchar2(24),            /*序号                                   */
sfh12       varchar2(20),            /*箱号                                   */
sfh13       varchar2(20),            /*入库单号                               */
sfh14       number(5),               /*序号                                   */
sfh15       number(15,3),            /*预计入库数量                           */
sfh16       number(15,3),            /*报废数量                               */
sfh17       number(5),               /*报废时完工程度比率                     */
                                     /*其值 0 - 100 之間                      */
sfh18       varchar2(10),            /*整批编号                               */
sfh91       varchar2(1),             /*No Use                                 */
sfh92       varchar2(1),             /*No Use                                 */
sfhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index sfh_02 on sfh_file (sfh13);
create        index sfh_01 on sfh_file (sfh01);
grant select on sfh_file to tiptopgp;
grant update on sfh_file to tiptopgp;
grant delete on sfh_file to tiptopgp;
grant insert on sfh_file to tiptopgp;
grant index on sfh_file to public;
grant select on sfh_file to ods;
