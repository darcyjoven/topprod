/*
================================================================================
檔案代號:adf_file
檔案名稱:集團撥出單單頭檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adf_file
(
adf00       varchar2(1),             /*調撥類型                               */
adf01       varchar2(16),            /*撥出單號                               */
adf02       date,                    /*單據日期                               */
adf03       varchar2(8),             /*員工編號                               */
adf04       varchar2(6),             /*部門編號                               */
adf05       varchar2(6),             /*調撥流程                               */
adf06       date,                    /*預計扺達日期                           */
adf07       varchar2(10),            /*在途倉                                 */
adf08       varchar2(40),            /*備註                                   */
adf09       date,                    /*過帳日期                               */
adf10       varchar2(1),             /*狀況碼                                 */
adfmksg     varchar2(1),             /*是否簽核                               */
adfsign     varchar2(4),             /*簽核等級                               */
adfdays     number(5),               /*簽核完成天數                           */
adfprit     number(5),               /*簽核優先等級                           */
adfsseq     number(5),               /*已簽核順序                             */
adfsmax     number(5),               /*應簽核順序                             */
adfconf     varchar2(1),             /*確認                                   */
adfpost     varchar2(1),             /*過帳否                                 */
adfprsw     number(5),               /*列印次數                               */
adfacti     varchar2(1),             /*資料有效碼                             */
adfuser     varchar2(10),            /*資料所有者                             */
adfgrup     varchar2(6),             /*資料所有部門                           */
adfmodu     varchar2(10),            /*資料修改者                             */
adfdate     date                     /*最近修改日                             */
);

create unique index adf_01 on adf_file (adf01);
create        index adf_02 on adf_file (adf02,adf01);
grant select on adf_file to public;
grant index on adf_file to public;
grant update on adf_file to public;
grant delete on adf_file to public;
grant insert on adf_file to public;
