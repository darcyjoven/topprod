/*
================================================================================
檔案代號:adw_file
檔案名稱:流通配銷系統參數檔--倉退單
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adw_file
(
adw01       varchar2(10),            /*撥入營運中心                           */
adw02       varchar2(5),             /*單別                                   */
adw03       varchar2(6),             /*部門                                   */
adw04       varchar2(8),             /*人員                                   */
adw05       varchar2(4),             /*理由碼                                 */
adw06       varchar2(1),             /*No                                     */
adw07       varchar2(1),             /*No                                     */
adw08       varchar2(1),             /*No                                     */
adw09       varchar2(1),             /*No                                     */
adwacti     varchar2(1),             /*資料有效碼                             */
adwuser     varchar2(10),            /*資料所有者                             */
adwgrup     varchar2(6),             /*資料所有部門                           */
adwmodu     varchar2(10),            /*資料修改者                             */
adwdate     date                     /*最近修改日                             */
);

create unique index adw_01 on adw_file (adw01);
grant select on adw_file to public;
grant index on adw_file to public;
grant update on adw_file to public;
grant delete on adw_file to public;
grant insert on adw_file to public;
