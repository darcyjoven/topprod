/*
================================================================================
檔案代號:sfm_file
檔案名稱:工单变更纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfm_file
(
sfm00       varchar2(8) NOT NULL,    /*资料序号                               */
                                     /*資料序號(YYMMnnnn)                     */
sfm01       varchar2(20),            /*工单单号                               */
                                     /*工單單號 (for sfm10=1/3                */
sfm02       number(5),               /*变更版本                               */
                                     /*變更版本 (for sfm10='1')               */
sfm03       date,                    /*变更日期                               */
                                     /*變更日期                               */
sfm04       varchar2(8),             /*时间                                   */
                                     /*    時間                               */
sfm05       number(15,3),            /*变更前生产数量                         */
                                     /*變更前生產數量 for sfm10='1'           */
                                     /*需求數量       for sfm10='2'           */
                                     /*移轉批量       for sfm10='3'           */
sfm06       number(15,3),            /*变更后生产数量                         */
                                     /*變更後生產數量                         */
sfm07       varchar2(20),            /*退料单号码                             */
                                     /*退料單號碼     for sfm10=1/2           */
                                     /*調撥單號       for sfm10='3'           */
sfm08       varchar2(20),            /*目地工单                               */
                                     /*目地工單       for sfm10=1/2           */
                                     /*PBI NO         for sfm10='3'           */
sfm09       varchar2(20),            /*目的工单发料单                         */
                                     /*目的工單發料單                         */
sfm10       varchar2(1),             /*挪料类型                               */
                                     /*挪料型態 1:工單挪料                    */
                                     /*         2:單料挪料                    */
                                     /*         3:工單移轉(01->70,71,72)      */
sfm11       varchar2(40),            /*单笔移料之料号                         */
                                     /*單筆移料之料號(for sfm10='2')          */
sfm13       varchar2(10),            /*拨出仓库/收发料仓库                    */
                                     /*撥出倉庫/收發料倉庫                    */
sfm14       varchar2(10),            /*拨出库位/收发料库位                    */
                                     /*撥出儲位/收發料儲位                    */
sfm15       varchar2(24),            /*拨出批号/收发料批号                    */
                                     /*撥出批號/收發料批號  No.+024           */
sfm16       number(15,3),            /*挪料套数/需求数量                      */
                                     /*挪料套數/需求數量 NO:6968              */
sfm23       varchar2(10),            /*拨入仓库                               */
                                     /*撥入倉庫       for sfm10='3'           */
sfm24       varchar2(10),            /*拨入库位                               */
                                     /*撥入儲位       for sfm10='3'           */
sfm25       varchar2(24),            /*拨入批号                               */
                                     /*撥入批號       for sfm10='3'  No.+024  */
sfmuser     varchar2(10),            /*人员                                   */
                                     /*人員                                   */
sfmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfmorig     varchar2(10),            /*资料建立部门                           */
sfmoriu     varchar2(10)             /*资料建立者                             */
);

create        index sfm_02 on sfm_file (sfm01,sfm02);
alter table sfm_file add  constraint sfm_pk primary key  (sfm00) enable validate;
grant select on sfm_file to tiptopgp;
grant update on sfm_file to tiptopgp;
grant delete on sfm_file to tiptopgp;
grant insert on sfm_file to tiptopgp;
grant index on sfm_file to public;
grant select on sfm_file to ods;
