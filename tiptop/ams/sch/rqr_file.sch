/*
================================================================================
檔案代號:rqr_file
檔案名稱:粗略产能规划参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table rqr_file
(
rqr_v       varchar2(10) NOT NULL,   /*模拟版本                               */
                                     /*模擬版本                               */
rqr01       date,                    /*运行日期                               */
                                     /*執行日期                               */
rqr02       varchar2(5),             /*起始时间                               */
                                     /*起始時間                               */
rqr03       varchar2(5),             /*结束时间                               */
                                     /*結束時間                               */
rqr04       number(5),               /*生成笔数                               */
                                     /*產生筆數                               */
rqr05       varchar2(10),            /*生成人员                               */
                                     /*產生人員                               */
incl_wo     varchar2(1),             /*是否纳入工单资料                       */
                                     /*是否納入工單資料                       */
incl_mps    varchar2(1),             /*是否纳入MPS 资料                       */
                                     /*是否納入MPS 資料                       */
incl_plm    varchar2(1)              /*是否纳入PLM 资料                       */
                                     /*是否納入PLM 資料                       */
);

alter table rqr_file add  constraint rqr_pk primary key  (rqr_v) enable validate;
grant select on rqr_file to tiptopgp;
grant update on rqr_file to tiptopgp;
grant delete on rqr_file to tiptopgp;
grant insert on rqr_file to tiptopgp;
grant index on rqr_file to public;
grant select on rqr_file to ods;
