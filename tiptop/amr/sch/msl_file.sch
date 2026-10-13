/*
================================================================================
檔案代號:msl_file
檔案名稱:LRP 运行Log档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table msl_file
(
msl_v       varchar2(10),            /*模拟版本                               */
                                     /*模擬版本                               */
msl01       date,                    /*运行日期                               */
                                     /*執行日期                               */
msl02       varchar2(8),             /*运行时间                               */
                                     /*執行時間                               */
msl03       varchar2(80),            /*运行信息                               */
                                     /*執行訊息                               */
msl04       varchar2(10),            /*码别                                   */
                                     /*碼別                                   */
mslplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
msllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

grant select on msl_file to tiptopgp;
grant update on msl_file to tiptopgp;
grant delete on msl_file to tiptopgp;
grant insert on msl_file to tiptopgp;
grant index on msl_file to public;
grant select on msl_file to ods;
