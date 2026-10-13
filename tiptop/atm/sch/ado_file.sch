/*
================================================================================
檔案代號:ado_file
檔案名稱:车辆加油记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ado_file
(
ado01       varchar2(10) NOT NULL,   /*车辆编号                               */
ado02       date NOT NULL,           /*加油日期                               */
ado03       number(5) NOT NULL,      /*序号                                   */
ado04       number(15,6),            /*加油数量                               */
ado05       number(20,6),            /*加油金额                               */
ado06       varchar2(10),            /*驾驶员                                 */
ado07       varchar2(20),            /*加油地点                               */
adoacti     varchar2(1),             /*资料有效码                             */
adouser     varchar2(10),            /*资料所有者                             */
adogrup     varchar2(10),            /*资料所有部门                           */
adomodu     varchar2(10),            /*资料更改者                             */
adodate     date,                    /*最近更改日                             */
adoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
adolegal    varchar2(10) NOT NULL,   /*所属法人                               */
adoorig     varchar2(10),            /*资料建立部门                           */
adooriu     varchar2(10)             /*资料建立者                             */
);

alter table ado_file add  constraint ado_pk primary key  (ado01,ado02,ado03) enable validate;
grant select on ado_file to tiptopgp;
grant update on ado_file to tiptopgp;
grant delete on ado_file to tiptopgp;
grant insert on ado_file to tiptopgp;
grant index on ado_file to public;
grant select on ado_file to ods;
