/*
================================================================================
檔案代號:adi_file
檔案名稱:集團撥入單單身檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adi_file
(
adi01       varchar2(16),            /*撥入單號                               */
adi02       number(5),               /*項次                                   */
adi03       varchar2(16),            /*撥出單號                               */
adi04       number(5),               /*撥出項次                               */
adi05       varchar2(40),            /*料件編號                               */
adi06       varchar2(10),            /*撥入倉庫                               */
adi07       varchar2(10),            /*儲位                                   */
adi08       varchar2(20),            /*批號                                   */
adi09       varchar2(4),             /*單位                                   */
adi10       number(15,3),            /*撥入數量                               */
adi11       varchar2(1),             /*轉撥計價方式                           */
adi12       number(7,4),             /*轉撥百分比                             */
adi13       number(20,6),            /*撥入單價                               */
adi14       number(20,6),            /*撥入金額                               */
adi15       varchar2(16),            /*參考單號                               */
adi16       number(5),               /*參考項次                               */
adi17       number(15,3),            /*倉退數量                               */
adi18       varchar2(1),             /*計劃期別格式                           */
adi19       number(10),              /*起始期別                               */
adi20       number(5),               /*序號                                   */
adi21       varchar2(1),             /*No Use                                 */
adi22       varchar2(1),             /*No Use                                 */
adi23       varchar2(1),             /*No Use                                 */
adi30       varchar2(4),             /*單位一                                 */
adi31       number(16,8),            /*單位一轉換率(與庫存單位)               */
adi32       number(15,3),            /*單位一數量                             */
adi33       varchar2(4),             /*單位二                                 */
adi34       number(16,8),            /*單位二轉換率(與庫存單位)               */
adi35       number(15,3)             /*單位二數量                             */
);

create unique index adi_01 on adi_file (adi01,adi02);
create        index adi_02 on adi_file (adi03,adi04);
grant select on adi_file to public;
grant index on adi_file to public;
grant update on adi_file to public;
grant delete on adi_file to public;
grant insert on adi_file to public;
