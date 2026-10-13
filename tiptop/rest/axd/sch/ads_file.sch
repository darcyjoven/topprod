/*
================================================================================
檔案代號:ads_file
檔案名稱:客戶庫存調整單頭檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table ads_file
(
ads01       varchar2(16),            /*庫存調整檔                             */
ads02       date,                    /*異動日期                               */
ads03       varchar2(10),            /*客戶編號                               */
ads04       varchar2(8),             /*員工編號                               */
ads05       varchar2(6),             /*部門編號                               */
ads06       varchar2(30),            /*備註                                   */
ads07       varchar2(1),             /*狀況碼                                 */
adsmksg     varchar2(1),             /*是否簽核                               */
adssign     varchar2(4),             /*簽核等級                               */
adsdays     number(5),               /*簽核完成天數                           */
adsprit     number(5),               /*簽核有先等級                           */
adssseq     number(5),               /*已簽核順序                             */
adssmax     number(5),               /*應簽核順序                             */
adsconf     varchar2(1),             /*確認                                   */
adspost     varchar2(1),             /*過帳否                                 */
adsprsw     number(5),               /*列印次數                               */
adsacti     varchar2(1),             /*有效否                                 */
adsuser     varchar2(10),            /*建檔人員                               */
adsgrup     varchar2(6),             /*建檔部門                               */
adsmodu     varchar2(10),            /*最后修改人員                           */
adsdate     date                     /*最后修改日期                           */
);

create unique index ads_01 on ads_file (ads01);
grant select on ads_file to public;
grant index on ads_file to public;
grant update on ads_file to public;
grant delete on ads_file to public;
grant insert on ads_file to public;
