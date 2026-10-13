/*
================================================================================
檔案代號:mmk_file
檔案名稱:加工通知单单身底稿
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mmk_file
(
mmk01       varchar2(20) NOT NULL,   /*加工通知单号                           */
                                     /*加工通知單號                           */
mmk02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
mmk03       varchar2(40),            /*加工需求料件编号                       */
                                     /*加工需求料件編號                       */
mmk031      varchar2(4),             /*单位                                   */
mmk04       varchar2(15),            /*图号                                   */
                                     /*圖號                                   */
mmk05       varchar2(10),            /*版本                                   */
mmk06       varchar2(80),            /*规格说明                               */
                                     /*規格說明                               */
mmk07       varchar2(1),             /*来源码                                 */
                                     /*來源碼 P採購 M自製 S委外               */
mmk08       varchar2(4),             /*生产单位                               */
mmk09       date,                    /*开始日期                               */
mmk091      date,                    /*需求日期                               */
mmk10       number(15,3) NOT NULL,   /*加工数量                               */
                                     /*加工數量                               */
mmk11       varchar2(20),            /*需求单号                               */
                                     /*需求單號 mma01,mmb01                   */
mmk111      number(5),               /*需求单号项次                           */
                                     /*需求單號項次 mmb02                     */
mmk12       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價                                   */
                                     /*此料件的加工需求單價                   */
mmk13       number(5),               /*工时                                   */
mmk14       varchar2(80),            /*备注                                   */
mmk15       varchar2(10),            /*加工码                                 */
                                     /*mmc01                                  */
mmkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table mmk_file add  constraint mmk_pk primary key  (mmk01,mmk02) enable validate;
grant select on mmk_file to tiptopgp;
grant update on mmk_file to tiptopgp;
grant delete on mmk_file to tiptopgp;
grant insert on mmk_file to tiptopgp;
grant index on mmk_file to public;
grant select on mmk_file to ods;
