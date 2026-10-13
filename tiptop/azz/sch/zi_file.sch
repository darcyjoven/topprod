/*
================================================================================
檔案代號:zi_file
檔案名稱:批次运行指令资料主档    BATCH INSTRU
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zi_file
(
zi01        varchar2(10) NOT NULL,   /*批次编号                               */
                                     /*批次編號                               */
zi02        varchar2(36),            /*批次编号名称                           */
                                     /*批次編號名稱                           */
zi03        date,                    /*失效日期                               */
zi04        date,                    /*最近运行日期                           */
                                     /*最近執行日期                           */
zi05        varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ziacti      varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
ziuser      varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
zigrup      varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
zimodu      varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
zidate      date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ziorig      varchar2(10),            /*资料建立部门                           */
zioriu      varchar2(10)             /*资料建立者                             */
);

alter table zi_file add  constraint zi_pk primary key  (zi01) enable validate;
grant select on zi_file to tiptopgp;
grant update on zi_file to tiptopgp;
grant delete on zi_file to tiptopgp;
grant insert on zi_file to tiptopgp;
grant index on zi_file to public;
grant select on zi_file to ods;
