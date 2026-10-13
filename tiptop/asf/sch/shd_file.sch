/*
================================================================================
檔案代號:shd_file
檔案名稱:当站下线资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shd_file
(
shd01       varchar2(20) NOT NULL,   /*移转单号                               */
                                     /*移轉單號                               */
shd02       number(5) NOT NULL,      /*行序                                   */
shd03       varchar2(10),            /*下线仓库                               */
                                     /*下線倉庫                               */
shd04       varchar2(10),            /*下线库位                               */
                                     /*下線儲位                               */
shd05       varchar2(24),            /*下线批号                               */
                                     /*下線批號                               */
shd06       varchar2(40),            /*下线料号                               */
                                     /*下線料號                               */
shd07       number(15,3),            /*下线数量                               */
                                     /*下線數量                               */
shd08       number(20,6),            /*下线单价                               */
                                     /*下線單價       1999/12/06 add          */
shd09       number(20,6),            /*下线金额                               */
                                     /*下線金額       1999/12/06 add          */
shdacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
shduser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
shdgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
shdmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
shddate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
shd10       varchar2(4),             /*单位一                                 */
shd11       number(20,8),            /*单位一转换率(与生产单位)               */
shd12       number(15,3),            /*单位一数量                             */
shd13       varchar2(4),             /*单位二                                 */
shd14       number(20,8),            /*单位二转换率(与生产单位)               */
shd15       number(15,3),            /*单位二数量                             */
shdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
shdorig     varchar2(10),            /*资料建立部门                           */
shdoriu     varchar2(10),            /*资料建立者                             */
shd082      number(20,6),            /*人工单价                               */
shd083      number(20,6),            /*制费一单价                             */
shd084      number(20,6),            /*加工单价                               */
shd085      number(20,6),            /*制费二单价                             */
shd086      number(20,6),            /*制费三单价                             */
shd087      number(20,6),            /*制费四单价                             */
shd088      number(20,6),            /*制费五单价                             */
shd16       varchar2(4),             /*单位                                   */
shd17       number(20,8),
shd18       varchar2(10)             /*理由码                                 */
);

alter table shd_file add  constraint shd_pk primary key  (shd01,shd02) enable validate;
grant select on shd_file to tiptopgp;
grant update on shd_file to tiptopgp;
grant delete on shd_file to tiptopgp;
grant insert on shd_file to tiptopgp;
grant index on shd_file to public;
grant select on shd_file to ods;
