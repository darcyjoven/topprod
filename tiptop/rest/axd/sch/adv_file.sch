/*
================================================================================
檔案代號:adv_file
檔案名稱:流通配銷系統參數檔-收貨單
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adv_file
(
adv01       varchar2(10),            /*撥入營運中心                           */
adv02       varchar2(5),             /*出貨單別                               */
adv03       varchar2(10),            /*銷售分類                               */
adv04       varchar2(8),             /*業務員                                 */
adv05       varchar2(6),             /*出貨部門                               */
adv06       varchar2(4),             /*稅別                                   */
adv07       number(5,2),             /*稅率                                   */
adv08       varchar2(1),             /*聯數                                   */
adv09       varchar2(1),             /*含稅否                                 */
adv10       varchar2(4),             /*幣別                                   */
adv11       number(20,10),           /*匯率                                   */
adv12       varchar2(1),             /*發票別                                 */
adv13       varchar2(4),             /*科目別                                 */
adv14       varchar2(1),             /*No                                     */
adv15       varchar2(1),             /*No                                     */
advacti     varchar2(1),             /*資料有效碼                             */
advuser     varchar2(10),            /*資料所有者                             */
advgrup     varchar2(6),             /*資料所有部門                           */
advmodu     varchar2(10),            /*資料修改者                             */
advdate     date                     /*最近修改日                             */
);

create unique index adv_01 on adv_file (adv01);
grant select on adv_file to public;
grant index on adv_file to public;
grant update on adv_file to public;
grant delete on adv_file to public;
grant insert on adv_file to public;
