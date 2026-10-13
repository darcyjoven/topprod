/*
================================================================================
檔案代號:vne_file
檔案名稱:aps 鎖定使用設備維護檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vne_file
(
vne01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vne02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vne03       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vne04       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vne05       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vne06       number(15,3),            /*未完成量                               */
vne07       number(1),               /*是否排程                               */
vne25       varchar2(5),             /*开工时间                               */
vne26       varchar2(5),             /*完工时间                               */
vne301      number(15,3),            /*NO USE                                 */
vne302      number(15,3),            /*NO USE                                 */
vne303      number(15,3),            /*NO USE                                 */
vne311      number(15,3),            /*良品转出                               */
vne312      number(15,3),            /*返工转出                               */
vne313      number(15,3),            /*当站报废                               */
vne314      number(15,3),            /*当站下线                               */
vne315      number(15,3),            /*Bonus                                  */
vne316      number(15,3),            /*工单转出                               */
vne50       date,                    /*预计开工日                             */
vne51       date,                    /*预计完工日                             */
vneacti     varchar2(1),             /*资料有效码                             */
vnedate     date,                    /*最近更改日                             */
vnegrup     varchar2(10),            /*资料所有群                             */
vnemodu     varchar2(10),            /*资料更改者                             */
vneuser     varchar2(10),            /*资料所有者                             */
vnelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vneplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vne012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vne_file add  constraint vne_pk primary key  (vne01,vne02,vne03,vne04,vne05,vne012) enable validate;
grant select on vne_file to tiptopgp;
grant update on vne_file to tiptopgp;
grant delete on vne_file to tiptopgp;
grant insert on vne_file to tiptopgp;
grant index on vne_file to public;
grant select on vne_file to ods;
