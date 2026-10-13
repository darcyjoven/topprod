/*
================================================================================
檔案代號:adn_file
檔案名稱:車輛工作日報檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adn_file
(
adn01       varchar2(10),            /*車輛編號                               */
adn02       date,                    /*起始日期                               */
adn03       date,                    /*截止日期                               */
adn04       number(5),               /*項次                                   */
adn05       varchar2(8),             /*駕駛員                                 */
adn06       varchar2(16),            /*派車單單號                             */
adn07       varchar2(6),             /*派車原因                               */
adn08       date,                    /*實際返回日期                           */
adn09       varchar2(4),             /*實際返回時間                           */
adn10       number(5),               /*起始里程                               */
adn11       number(5),               /*截止里程                               */
adn12       varchar2(30),            /*備註                                   */
adnacti     varchar2(1),             /*資料有效碼                             */
adnuser     varchar2(10),            /*資料所有者                             */
adngrup     varchar2(6),             /*資料所有部門                           */
adnmodu     varchar2(10),            /*資料修改者                             */
adndate     date                     /*最近修改日                             */
);

create unique index adn_01 on adn_file (adn01,adn02,adn03,adn04);
grant select on adn_file to public;
grant index on adn_file to public;
grant update on adn_file to public;
grant delete on adn_file to public;
grant insert on adn_file to public;
