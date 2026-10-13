/*
================================================================================
檔案代號:mpr_file
檔案名稱:MPS 版本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mpr_file
(
mpr_v       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
mpr01       date,                    /*运行日期                               */
                                     /*執行日期                               */
mpr02       varchar2(5),             /*起始时间                               */
                                     /*起始時間                               */
mpr03       varchar2(5),             /*结束时间                               */
                                     /*結束時間                               */
mpr04       number(5),               /*生成笔数                               */
                                     /*產生筆數                               */
mpr05       varchar2(10),            /*生成人员                               */
                                     /*產生人員                               */
mpr06       varchar2(1),             /*是否处理取替代料                       */
                                     /*是否處理取替代料                       */
mpr07       varchar2(1),             /*是否处理指定厂牌                       */
                                     /*是否處理指定廠牌                       */
lot_type    varchar2(1),             /*模拟料号来源                           */
                                     /*模擬料號來源                           */
                                     /*1.生產計劃 2.工單 3.客戶訂單           */
                                     /*4.料號 5.Net Change                    */
lot_bm      number(5),               /*BOM 下展阶数                           */
                                     /*BOM 下展階數                           */
lot_no1     varchar2(40),            /*来源号码-1                             */
                                     /*來源號碼-1                             */
lot_no2     varchar2(40),            /*来源号码-1                             */
forbdate    date,                    /*预测考虑起始日期                       */
                                     /*預測考慮起始日期                       */
bdate       date,                    /*起始供需日期                           */
edate       date,                    /*截止供需日期                           */
buk_type    varchar2(1),             /*使用时距方式                           */
                                     /*使用時距方式                           */
                                     /* 1:依時距代號 2.天 3.週 4.旬 5.月      */
buk_code    varchar2(10),            /*时距编号                               */
                                     /*時距代號                               */
po_days     number(10),              /*PR/PO 允许交期提前 (Reschedule)        */
                                     /*PR/PO 允許交期提前 (Reschedule) 調整天數*/
wo_days     number(10),              /*W/O   允许交期提前 (Reschedule)        */
                                     /*W/O   允許交期提前 (Reschedule) 調整天數*/
incl_id     varchar2(1),             /*是否纳入独立需求档资料                 */
                                     /*是否納入獨立需求檔資料 (Y/N)           */
incl_so     varchar2(1),             /*是否纳入实际订单档资料                 */
                                     /*是否納入實際訂單檔資料 (Y/N)           */
msb_expl    varchar2(1),             /*生产计划(未转工单)下阶料备             */
                                     /*生產計劃(未轉工單)下階料備料需求是否納入*/
oeb_expl    varchar2(1),             /*No Use                                 */
mss_expl    varchar2(1),             /*建议PLM自制料件是否生成下阶            */
                                     /*建議PLM自製料件是否產生下階料的備料需求*/
sub_flag    varchar2(1),             /*是否处理取替代料                       */
                                     /*是否處理取替代料                       */
sub_days    number(10),              /*处理取替代料天数                       */
                                     /*處理取替代料天數                       */
mps_save    varchar2(1),             /*保留现有MPS 计划否                     */
                                     /*保留現有MPS 計劃否 (Y/N)               */
mps_msa01   varchar2(16),            /*欲保留的MPS 计划编号                   */
mbdate      date,                    /*欲保留的MPS启始日期                    */
                                     /*欲保留的MPS啟始日期                    */
medate      date,                    /*欲保留的MPS截止日期                    */
qty_type    varchar2(1)              /*预测资料是否取审核数量                 */
                                     /*預測資料是否取確認數量                 */
);

alter table mpr_file add  constraint mpr_pk primary key  (mpr_v) enable validate;
grant select on mpr_file to tiptopgp;
grant update on mpr_file to tiptopgp;
grant delete on mpr_file to tiptopgp;
grant insert on mpr_file to tiptopgp;
grant index on mpr_file to public;
grant select on mpr_file to ods;
