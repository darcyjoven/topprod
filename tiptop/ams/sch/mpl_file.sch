/*
================================================================================
檔案代號:mpl_file
檔案名稱:MPS 运行Log档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table mpl_file
(
mpl_v       varchar2(10),            /*模拟版本                               */
                                     /*模擬版本                               */
mpl01       date,                    /*运行日期                               */
                                     /*執行日期                               */
mpl02       varchar2(8),             /*运行时间                               */
                                     /*執行時間                               */
mpl03       varchar2(80),            /*运行信息                               */
                                     /*執行訊息                               */
mplplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mpllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

grant select on mpl_file to tiptopgp;
grant update on mpl_file to tiptopgp;
grant delete on mpl_file to tiptopgp;
grant insert on mpl_file to tiptopgp;
grant index on mpl_file to public;
grant select on mpl_file to ods;
