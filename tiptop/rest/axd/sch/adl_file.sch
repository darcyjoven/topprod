/*
================================================================================
檔案代號:adl_file
檔案名稱:派車單單身檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adl_file
(
adl01       varchar2(16),            /*派車單單號                             */
adl02       number(5),               /*項次                                   */
adl03       varchar2(16),            /*來源單號                               */
adl04       number(5),               /*來源單項次                             */
adl05       number(15,6),            /*來源數量                               */
adl06       number(5),               /*撥出件數                               */
adl07       date,                    /*預計扺達日期                           */
adl08       varchar2(4),             /*預計扺達時間                           */
adl09       date,                    /*實際扺達日期                           */
adl10       varchar2(4),             /*實際扺達時間                           */
adl11       varchar2(1),             /*單據來源                               */
adl12       varchar2(4),             /*單位一                                 */
adl13       number(16,8),            /*單位一換算率                           */
adl14       number(15,3),            /*單位一數量                             */
adl15       varchar2(4),             /*單位二                                 */
adl16       number(16,8),            /*單位二換算率                           */
adl17       number(15,3),            /*單位二數量                             */
adl18       varchar2(4),             /*計價單位                               */
adl19       number(15,3),            /*計價數量                               */
adl20       varchar2(4)
);

create unique index adl_01 on adl_file (adl01,adl02);
grant select on adl_file to public;
grant index on adl_file to public;
grant update on adl_file to public;
grant delete on adl_file to public;
grant insert on adl_file to public;
