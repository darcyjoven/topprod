/*
================================================================================
檔案代號:ade_file
檔案名稱:集團調撥申請單單身檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table ade_file
(
ade01       varchar2(16),            /*調撥申請單號                           */
ade02       number(5),               /*項次                                   */
ade03       varchar2(20),            /*產品編號                               */
ade04       varchar2(4),             /*單位                                   */
ade05       number(15,3),            /*數量                                   */
ade06       varchar2(10),            /*需求營運中心                           */
ade07       varchar2(10),            /*撥入倉庫                               */
ade08       date,                    /*需求日期                               */
ade09       date,                    /*回復日期                               */
ade10       date,                    /*預計調撥日期                           */
ade11       varchar2(4),             /*特別註記                               */
ade12       number(15,3),            /*已調撥數量                             */
ade13       varchar2(1),             /*結案否                                 */
ade14       date,                    /*結案日期                               */
ade15       number(15,3),            /*已撥入數量                             */
ade16       varchar2(16),            /*異動單號                               */
ade17       number(5),               /*項次                                   */
ade18       varchar2(1),             /*計劃期別格式                           */
ade19       number(10),              /*起始期別                               */
ade20       number(5),               /*序號                                   */
ade21       varchar2(1),             /*No                                     */
ade22       varchar2(1),             /*No                                     */
ade23       varchar2(1),             /*No                                     */
ade30       varchar2(4),             /*單位一                                 */
ade31       number(16,8),            /*單位一轉換率(與庫存單位)               */
ade32       number(15,3),            /*單位一數量                             */
ade33       varchar2(4),             /*單位二                                 */
ade34       number(16,8),            /*單位二轉換率(與庫存單位)               */
ade35       number(15,3)             /*單位二數量                             */
);

create unique index ade_01 on ade_file (ade01,ade02);
grant select on ade_file to public;
grant index on ade_file to public;
grant update on ade_file to public;
grant delete on ade_file to public;
grant insert on ade_file to public;
