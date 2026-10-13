/*
================================================================================
檔案代號:msr_file
檔案名稱:MRP 版本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msr_file
(
msr_v       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
msr01       date,                    /*运行日期                               */
                                     /*執行日期                               */
msr02       varchar2(5),             /*起始时间                               */
                                     /*起始時間                               */
msr03       varchar2(5),             /*结束时间                               */
                                     /*結束時間                               */
msr04       number(10),              /*生成笔数                               */
                                     /*產生筆數                               */
msr05       varchar2(10),            /*生成人员                               */
                                     /*產生人員                               */
msr06       varchar2(1),             /*是否处理取替代料                       */
                                     /*是否處理取替代料                       */
msr07       varchar2(1),             /*是否处理指定厂牌                       */
                                     /*是否處理指定廠牌                       */
msr08       varchar2(10),            /*限定版别编号                           */
                                     /*限定版別編號                    No.7264*/
lot_type    varchar2(1),             /*模拟料号来源                           */
                                     /*模擬料號來源                           */
                                     /*1.生產計劃 2.工單 3.客戶訂單           */
                                     /*4.料號 5.Net Change                    */
lot_bm      number(5),               /*BOM 下展阶数                           */
                                     /*BOM 下展階數                           */
lot_no1     varchar2(50),            /*来源号码-1                             */
                                     /*來源號碼-1                             */
lot_no2     varchar2(50),            /*来源号码-1                             */
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
msr09       varchar2(1),             /*是否显示运行过程                       */
incl_mds    varchar2(1),             /*纳入MDS需求                            */
msr10       varchar2(10),            /*APS版本                                */
msr11       varchar2(10),            /*储存版本                               */
msr919      varchar2(50),            /*计画批号                               */
msr12       varchar2(1),             /*显示今天以前的明细                     */
msr13       number(10),              /*PR PO 允许交期提前 (Reschedule)        */
msr14       number(10)               /*WO  允许交期提前 (Reschedule) 调       */
);

alter table msr_file add  constraint msr_pk primary key  (msr_v) enable validate;
grant select on msr_file to tiptopgp;
grant update on msr_file to tiptopgp;
grant delete on msr_file to tiptopgp;
grant insert on msr_file to tiptopgp;
grant index on msr_file to public;
grant select on msr_file to ods;
