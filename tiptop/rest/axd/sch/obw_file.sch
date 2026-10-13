/*
================================================================================
檔案代號:obw_file
檔案名稱:車輛基本資料檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obw_file
(
obw01       varchar2(10),            /*車輛編號                               */
obw02       varchar2(4),             /*類型                                   */
obw03       varchar2(16),            /*車輛廠牌                               */
obw04       varchar2(20),            /*車輛型號                               */
obw05       varchar2(1),             /*車輛級別                               */
obw06       varchar2(1),             /*所有權                                 */
obw07       varchar2(1),             /*車輛狀態                               */
obw08       varchar2(16),            /*車輛號碼                               */
obw09       varchar2(20),            /*引擎號碼                               */
obw10       varchar2(20),            /*底盤號碼                               */
obw11       date,                    /*出廠日期                               */
obw12       date,                    /*購買日期                               */
obw13       number(5),               /*已行駛里程                             */
obw14       varchar2(8),             /*保管人                                 */
obw15       varchar2(4),             /*保養群組                               */
obw16       varchar2(8),             /*駕駛員                                 */
obw17       varchar2(8),             /*隨車人員一                             */
obw18       varchar2(8),             /*隨車人員二                             */
obw19       varchar2(8),             /*隨車人員三                             */
obw20       varchar2(6),             /*車隊編號                               */
obw21       varchar2(1),             /*外租車計價方式                         */
obw22       number(20,6),            /*外租車單位金額                         */
obw23       varchar2(10),            /*財產編號                               */
obw24       varchar2(4),             /*財產附號                               */
obw25       varchar2(30),            /*備註                                   */
obwacti     varchar2(1),             /*資料有效碼                             */
obwuser     varchar2(10),            /*資料所有者                             */
obwgrup     varchar2(6),             /*資料所有部門                           */
obwmodu     varchar2(10),            /*資料修改者                             */
obwdate     date,                    /*最近修改日                             */
obw26       date                     /*最近保養日                             */
);

create unique index obw_01 on obw_file (obw01);
grant select on obw_file to public;
grant index on obw_file to public;
grant update on obw_file to public;
grant delete on obw_file to public;
grant insert on obw_file to public;
