/*
================================================================================
檔案代號:zba_file
檔案名稱:客户需求处理单档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zba_file
(
zba01       varchar2(20) NOT NULL,   /*单号                                   */
                                     /*單號                                   */
zba02       date NOT NULL,           /*日期                                   */
zba03       varchar2(3),             /*客户                                   */
                                     /*客戶                                   */
zba04       varchar2(10),            /*客户提出人                             */
                                     /*客戶提出人                             */
zba05       varchar2(8),             /*系统                                   */
                                     /*系統別                                 */
zba061      varchar2(80),            /*需求-1                                 */
zba062      varchar2(80),            /*需求-2                                 */
zba063      varchar2(80),            /*需求-3                                 */
zba07       varchar2(6),             /*状态                                   */
                                     /*狀態                                   */
zba08       varchar2(10),            /*录入人                                 */
                                     /*輸入人                                 */
zba111      varchar2(80),            /*回覆-1                                 */
zba112      varchar2(80),            /*回覆-2                                 */
zba113      varchar2(80),            /*回覆-3                                 */
zba12       varchar2(10),            /*审核人                                 */
                                     /*確認人                                 */
zba122      varchar2(10),            /*附署人                                 */
zba13       date,                    /*审核日                                 */
                                     /*確認日                                 */
zba14       varchar2(3),             /*分类                                   */
                                     /*分類                                   */
zba15       varchar2(6),             /*判定                                   */
zba16       number(5),               /*预估工时                               */
                                     /*預估工時                               */
zba17       date,                    /*预计动工                               */
                                     /*預計動工                               */
zba18       date,                    /*预计完工                               */
                                     /*預計完工                               */
zba19       varchar2(10),            /*负责人                                 */
                                     /*負責人                                 */
zba21       number(5),               /*实际工时                               */
                                     /*實際工時                               */
zba22       date,                    /*实际动工                               */
                                     /*實際動工                               */
zba23       date,                    /*实际完工                               */
                                     /*實際完工                               */
zba24       varchar2(80)             /*处理结果                               */
                                     /*處理結果                               */
);

create        index zba_02 on zba_file (zba03);
alter table zba_file add  constraint zba_pk primary key  (zba01,zba02) enable validate;
grant select on zba_file to tiptopgp;
grant update on zba_file to tiptopgp;
grant delete on zba_file to tiptopgp;
grant insert on zba_file to tiptopgp;
grant index on zba_file to public;
grant select on zba_file to ods;
