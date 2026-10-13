/*
================================================================================
檔案代號:adk_file
檔案名稱:派車單單頭檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adk_file
(
adk01       varchar2(16),            /*派車單單號                             */
adk02       date,                    /*單據日期                               */
adk03       varchar2(6),             /*派車原因                               */
adk04       date,                    /*出車日期                               */
adk05       varchar2(4),             /*出車時間                               */
adk06       date,                    /*預計返回日期                           */
adk07       varchar2(4),             /*預計返回時間                           */
adk08       varchar2(10),            /*車輛編號                               */
adk09       varchar2(8),             /*駕駛員                                 */
adk10       varchar2(8),             /*隨車人員一                             */
adk11       varchar2(8),             /*隨車人員二                             */
adk12       varchar2(8),             /*隨車人員三                             */
adk13       varchar2(8),             /*員工編號                               */
adk14       varchar2(6),             /*部門編號                               */
adk15       varchar2(6),             /*運輸途徑                               */
adk16       varchar2(40),            /*備註                                   */
adk17       varchar2(1),             /*狀況碼                                 */
adkmksg     varchar2(1),             /*簽核否                                 */
adksign     varchar2(4),             /*簽核等級                               */
adkdays     number(5),               /*簽核完成天數                           */
adkprit     number(5),               /*簽核優先等級                           */
adksseq     number(5),               /*已簽核順序                             */
adksmax     number(5),               /*應簽核順序                             */
adkconf     varchar2(1),             /*確認                                   */
adkprsw     number(5),               /*列印次數                               */
adkacti     varchar2(1),             /*資料有效碼                             */
adkuser     varchar2(10),            /*資料所有者                             */
adkgrup     varchar2(6),             /*資料所有部門                           */
adkmodu     varchar2(10),            /*資料修改者                             */
adkdate     date                     /*最近修改日                             */
);

create unique index adk_01 on adk_file (adk01);
grant select on adk_file to public;
grant index on adk_file to public;
grant update on adk_file to public;
grant delete on adk_file to public;
grant insert on adk_file to public;
