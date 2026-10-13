/*
================================================================================
檔案代號:msc_file
檔案名稱:MPS 计划变更单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table msc_file
(
msc01       varchar2(20) NOT NULL,   /*MPS 计划变更单号                       */
                                     /*MPS 計劃變更單號                       */
msc02       date,                    /*录入日期                               */
                                     /*輸入日期                               */
msc03       varchar2(1),             /*更新码                                 */
                                     /*更新碼(Y/N)                            */
msc04       date,                    /*变更日期                               */
                                     /*變更日期                               */
mscuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
mscplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
msclegal    varchar2(10) NOT NULL,   /*所属法人                               */
mscorig     varchar2(10),            /*资料建立部门                           */
mscoriu     varchar2(10)             /*资料建立者                             */
);

alter table msc_file add  constraint msc_pk primary key  (msc01) enable validate;
grant select on msc_file to tiptopgp;
grant update on msc_file to tiptopgp;
grant delete on msc_file to tiptopgp;
grant insert on msc_file to tiptopgp;
grant index on msc_file to public;
grant select on msc_file to ods;
