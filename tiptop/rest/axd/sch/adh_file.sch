/*
================================================================================
檔案代號:adh_file
檔案名稱:集團撥入單單頭檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adh_file
(
adh00       varchar2(1),             /*調撥類型                               */
adh01       varchar2(16),            /*撥入單號                               */
adh02       date,                    /*單據日期                               */
adh03       varchar2(8),             /*員工編號                               */
adh04       varchar2(6),             /*部門編號                               */
adh05       varchar2(40),            /*備註                                   */
adh06       date,                    /*過帳日期                               */
adh07       varchar2(1),             /*狀況碼                                 */
adhmksg     varchar2(1),             /*是否簽核                               */
adhsign     varchar2(4),             /*簽核等級                               */
adhdays     number(5),               /*簽核完成天數                           */
adhprit     number(5),               /*簽核優先等級                           */
adhsseq     number(5),               /*已簽核順序                             */
adhsmax     number(5),               /*應簽核順序                             */
adhconf     varchar2(1),             /*確認                                   */
adhprsw     number(5),               /*列印次數                               */
adhacti     varchar2(1),             /*資料有效碼                             */
adhpost     varchar2(1),             /*過帳否                                 */
adhuser     varchar2(10),            /*資料所有者                             */
adhgrup     varchar2(6),             /*資料所有部門                           */
adhmodu     varchar2(10),            /*資料修改者                             */
adhdate     date                     /*最近修改日                             */
);

create unique index adh_01 on adh_file (adh01);
create        index adh_02 on adh_file (adh02,adh01);
grant select on adh_file to public;
grant index on adh_file to public;
grant update on adh_file to public;
grant delete on adh_file to public;
grant insert on adh_file to public;
