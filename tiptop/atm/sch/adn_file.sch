/*
================================================================================
檔案代號:adn_file
檔案名稱:车辆工作日报档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table adn_file
(
adn01       varchar2(10) NOT NULL,   /*车辆编号                               */
adn02       date NOT NULL,           /*起始日期                               */
adn03       date NOT NULL,           /*截止日期                               */
adn04       number(5) NOT NULL,      /*项次                                   */
adn05       varchar2(10),            /*驾驶员                                 */
adn06       varchar2(20),            /*派车单单号                             */
adn07       varchar2(10),            /*派车原因                               */
adn08       date,                    /*实际返回日期                           */
adn09       varchar2(5),             /*实际返回时间                           */
adn10       number(5),               /*起始里程                               */
adn11       number(5),               /*截止里程                               */
adn12       varchar2(255),           /*备注                                   */
adnacti     varchar2(1),             /*资料有效码                             */
adnuser     varchar2(10),            /*资料所有者                             */
adngrup     varchar2(10),            /*资料所有部门                           */
adnmodu     varchar2(10),            /*资料更改者                             */
adndate     date,                    /*最近更改日                             */
adnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
adnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
adnorig     varchar2(10),            /*资料建立部门                           */
adnoriu     varchar2(10)             /*资料建立者                             */
);

alter table adn_file add  constraint adn_pk primary key  (adn01,adn02,adn03,adn04) enable validate;
grant select on adn_file to tiptopgp;
grant update on adn_file to tiptopgp;
grant delete on adn_file to tiptopgp;
grant insert on adn_file to tiptopgp;
grant index on adn_file to public;
grant select on adn_file to ods;
