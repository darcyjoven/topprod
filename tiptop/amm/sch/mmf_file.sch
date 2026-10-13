/*
================================================================================
檔案代號:mmf_file
檔案名稱:加工通知单单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mmf_file
(
mmf01       varchar2(20) NOT NULL,   /*加工通知单号                           */
                                     /*加工通知單號                           */
mmf02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
mmf03       varchar2(40) DEFAULT ' ',/*加工需求料件编号                       */
                                     /*加工需求料件編號                       */
mmf031      varchar2(4),             /*单位                                   */
                                     /*單位                                   */
mmf04       varchar2(15),            /*图号                                   */
                                     /*圖號                                   */
mmf05       varchar2(10),            /*版本                                   */
mmf06       varchar2(80),            /*规格说明                               */
                                     /*規格說明                               */
mmf07       varchar2(1),             /*来源码                                 */
                                     /*來源碼 P採購 M自製 S委外               */
mmf08       varchar2(4),             /*生产单位                               */
                                     /*生產單位                               */
mmf09       date,                    /*开始日期                               */
                                     /*開始日期                               */
mmf091      date,                    /*需求日期                               */
mmf10       number(15,3) NOT NULL,   /*加工数量                               */
                                     /*加工數量                               */
mmf11       varchar2(20),            /*需求单号                               */
                                     /*需求單號 mma01,mmb01                   */
mmf111      number(5),               /*需求单号项次                           */
                                     /*需求單號項次 mmb02                     */
mmf12       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價                                   */
                                     /*此料件的加工需求單價                   */
mmf13       number(5),               /*工时                                   */
mmf14       varchar2(80),            /*加工说明                               */
                                     /*備註                                   */
mmf15       varchar2(80),            /*备注                                   */
                                     /*加工碼 mmc01                           */
mmfacti     varchar2(1),             /*资料有效码                             */
mmfuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
mmfgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
mmfmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
mmfdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
mmfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmflegal    varchar2(10) NOT NULL,   /*所属法人                               */
mmforig     varchar2(10),            /*资料建立部门                           */
mmforiu     varchar2(10)             /*资料建立者                             */
);

alter table mmf_file add  constraint mmf_pk primary key  (mmf01,mmf02) enable validate;
grant select on mmf_file to tiptopgp;
grant update on mmf_file to tiptopgp;
grant delete on mmf_file to tiptopgp;
grant insert on mmf_file to tiptopgp;
grant index on mmf_file to public;
grant select on mmf_file to ods;
