/*
================================================================================
檔案代號:adu_file
檔案名稱:流通配銷系統參數檔-採購單
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adu_file
(
adu01       varchar2(10),            /*撥出營運中心                           */
adu02       varchar2(5),             /*採購單別                               */
adu021      varchar2(5),             /*收貨單別                               */
adu03       varchar2(10),            /*付款條件                               */
adu04       varchar2(6),             /*價格條件                               */
adu05       varchar2(5),             /*送貨地址                               */
adu06       varchar2(8),             /*採購員                                 */
adu07       varchar2(6),             /*採購部門                               */
adu08       varchar2(4),             /*稅別                                   */
adu09       number(5,2),             /*稅率                                   */
adu10       varchar2(4),             /*幣別                                   */
adu11       number(20,10),           /*匯率                                   */
adu12       varchar2(1),             /*No                                     */
adu13       varchar2(1),             /*No                                     */
adu14       varchar2(1),             /*No                                     */
adu15       varchar2(1),             /*No                                     */
aduacti     varchar2(1),             /*資料有效碼                             */
aduuser     varchar2(10),            /*資料所有者                             */
adugrup     varchar2(6),             /*資料所有部門                           */
adumodu     varchar2(10),            /*資料修改者                             */
adudate     date                     /*最近修改日                             */
);

create unique index adu_01 on adu_file (adu01);
grant select on adu_file to public;
grant index on adu_file to public;
grant update on adu_file to public;
grant delete on adu_file to public;
grant insert on adu_file to public;
