/*
================================================================================
檔案代號:pnl_file
檔案名稱:工单整批请购条件档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnl_file
(
pnl01       varchar2(20) NOT NULL,   /*请购单号                               */
                                     /*請購單號                               */
pnl02       varchar2(300),           /*条件范围                               */
                                     /*條件範圍                               */
pnl03       date,                    /*入库日缺省值                           */
                                     /*入庫日預設值                           */
pnl04       date,                    /*供给截止日                             */
                                     /*供給截止日                             */
pnl05       varchar2(1),             /*库存可用                               */
                                     /*庫存可用                               */
pnl06       varchar2(1),             /*检验量                                 */
                                     /*檢驗量                                 */
pnl07       varchar2(1),             /*请购量                                 */
                                     /*請購量                                 */
pnl08       varchar2(1),             /*采购量                                 */
                                     /*採購量                                 */
pnl09       varchar2(1),             /*在制量                                 */
                                     /*在製量                                 */
pnl10       varchar2(1),             /*已分配量                               */
                                     /*Distributed Qty (Allotted + Indep.Req) */
pnl11       varchar2(1),             /*安全库存                               */
                                     /*安全庫存                               */
pnluser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pnlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pnllegal    varchar2(10) NOT NULL,   /*所属法人                               */
pnlorig     varchar2(10),            /*资料建立部门                           */
pnloriu     varchar2(10)             /*资料建立者                             */
);

alter table pnl_file add  constraint pnl_pk primary key  (pnl01) enable validate;
grant select on pnl_file to tiptopgp;
grant update on pnl_file to tiptopgp;
grant delete on pnl_file to tiptopgp;
grant insert on pnl_file to tiptopgp;
grant index on pnl_file to public;
grant select on pnl_file to ods;
