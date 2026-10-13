/*
================================================================================
檔案代號:add_file
檔案名稱:集團調撥申請單頭檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table add_file
(
add00       varchar2(1),             /*調撥類別                               */
add01       varchar2(16),            /*調撥申請單號                           */
add02       date,                    /*申請日期                               */
add03       varchar2(8),             /*員工編號                               */
add04       varchar2(6),             /*部門編號                               */
add05       varchar2(30),            /*備註                                   */
add06       varchar2(1),             /*狀況碼                                 */
add07       varchar2(1),             /*結案否                                 */
add08       date,                    /*結案日期                               */
addmksg     varchar2(1),             /*是否簽核                               */
addsign     varchar2(4),             /*簽核等級                               */
adddays     number(5),               /*簽核完成天數                           */
addprit     number(5),               /*簽核優先等級                           */
addsseq     number(5),               /*已簽核順序                             */
addsmax     number(5),               /*應簽核順序                             */
addconf     varchar2(1),             /*確認                                   */
addprsw     number(5),               /*列印次數                               */
addacti     varchar2(1),             /*資料有效碼                             */
adduser     varchar2(10),            /*資料所有者                             */
addgrup     varchar2(6),             /*資料所有部門                           */
addmodu     varchar2(10),            /*資料修改者                             */
adddate     date                     /*最近修改日                             */
);

create unique index add_01 on add_file (add01);
grant select on add_file to public;
grant index on add_file to public;
grant update on add_file to public;
grant delete on add_file to public;
grant insert on add_file to public;
