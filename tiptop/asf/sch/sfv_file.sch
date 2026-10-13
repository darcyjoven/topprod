/*
================================================================================
檔案代號:sfv_file
檔案名稱:工单完工入库单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfv_file
(
sfv01       varchar2(20) NOT NULL,   /*入库编号                               */
                                     /*入庫編號 sfu01                         */
sfv03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
sfv04       varchar2(40),            /*料号                                   */
                                     /*料號     ima01(sfa03)(img01)           */
sfv05       varchar2(10),            /*仓库                                   */
                                     /*倉庫     imd01(img02)                  */
sfv06       varchar2(10),            /*库位                                   */
                                     /*儲位     ime01(img03)                  */
sfv07       varchar2(24),            /*批号                                   */
                                     /*批號           img04                   */
sfv08       varchar2(4),             /*库存单位                               */
                                     /*庫存單位       ima25                   */
sfv09       number(15,3),            /*入库量                                 */
                                     /*入庫量                                 */
sfv11       varchar2(40),            /*工单单号                               */
                                     /*W/O No.      Sfb01(ASR The Field Is Planning Item#)*/
sfv12       varchar2(255),           /*备注                                   */
                                     /*備註 (委外工單入庫時輸入發票號碼)      */
sfv13       number(15,3),            /*No Use                                 */
sfv14       number(5),               /*No Use                                 */
sfv15       number(5),               /*No Use                                 */
sfv16       varchar2(1),             /*当月是否入联产品否                     */
sfv17       varchar2(20),            /*FQC单号                                */
sfv18       varchar2(1),             /*No Use                                 */
sfv19       varchar2(1),             /*No Use                                 */
sfv20       varchar2(23),            /*Run Card                               */
sfv30       varchar2(4),             /*单位一                                 */
sfv31       number(20,8),            /*单位一换算率(与生产单位)               */
sfv32       number(15,3),            /*单位一数量                             */
sfv33       varchar2(4),             /*单位二                                 */
sfv34       number(20,8),            /*单位二换算率(与生产单位)               */
sfv35       number(15,3),            /*单位二数量                             */
sfv930      varchar2(10),            /*成本中心                               */
sfv41       varchar2(10),            /*项目编号                               */
sfv42       varchar2(30),            /*WBS编码                                */
sfv43       varchar2(4),             /*活动编号                               */
sfv44       varchar2(10),            /*理由码                                 */
sfvud01     varchar2(255),           /*自订字段-Textedit                      */
sfvud02     varchar2(40),            /*自订字段-文字                          */
sfvud03     varchar2(40),            /*自订字段-文字                          */
sfvud04     varchar2(40),            /*自订字段-文字                          */
sfvud05     varchar2(40),            /*自订字段-文字                          */
sfvud06     varchar2(40),            /*自订字段-文字                          */
sfvud07     number(20,6),            /*单价                                   */
sfvud08     number(15,3),            /*自订字段-数值                          */
sfvud09     number(15,3),            /*自订字段-数值                          */
sfvud10     number(10),              /*自订字段-整数                          */
sfvud11     number(10),              /*自订字段-整数                          */
sfvud12     number(10),              /*自订字段-整数                          */
sfvud13     date,                    /*自订字段-日期                          */
sfvud14     date,                    /*自订字段-日期                          */
sfvud15     date,                    /*自订字段-日期                          */
sfvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfv45       varchar2(20),            /*号机                                   */
sfv46       varchar2(10),            /*QC判定结果编码                         */
sfv47       number(5)                /*QC判定结果项次                         */
);

create        index sfv_03 on sfv_file (sfv20);
create        index sfv_02 on sfv_file (sfv11);
alter table sfv_file add  constraint sfv_pk primary key  (sfv01,sfv03) enable validate;
grant select on sfv_file to tiptopgp;
grant update on sfv_file to tiptopgp;
grant delete on sfv_file to tiptopgp;
grant insert on sfv_file to tiptopgp;
grant index on sfv_file to public;
grant select on sfv_file to ods;
