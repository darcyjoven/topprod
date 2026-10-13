/*
================================================================================
檔案代號:box_file
檔案名稱:配货单主档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table box_file
(
box01       varchar2(20) DEFAULT ' ' NOT NULL, /*配货单号*/
box02       number(5) DEFAULT '0' NOT NULL, /*配货单项次*/
box03       number(5) DEFAULT '0' NOT NULL, /*子项次*/
box04       varchar2(40),            /*产品编号                               */
box05       number(15,3) DEFAULT '0' NOT NULL, /*预计出货数量*/
box06       number(15,3) DEFAULT '0' NOT NULL, /*出货数量*/
box07       number(15,3) DEFAULT '0' NOT NULL, /*挑选数量*/
box08       varchar2(1),             /*安库否                                 */
box09       varchar2(20),            /*工单单号                               */
box10       date,                    /*入库日期                               */
box11       varchar2(10),            /*Nouse                                  */
box12       varchar2(10),            /*产品分类码(系列)                       */
box13       varchar2(255),           /*月台                                   */
box14       varchar2(10),            /*配货来源                               */
boxacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
boxdate     date,                    /*最近更改日                             */
boxgrup     varchar2(10),            /*资料所有群                             */
boxlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
boxmodu     varchar2(10),            /*资料更改者                             */
boxorig     varchar2(10),            /*资料建立部门                           */
boxoriu     varchar2(10),            /*资料建立者                             */
boxplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
boxuser     varchar2(10)             /*资料所有者                             */
);

alter table box_file add  constraint box_pk primary key  (box01,box02,box03) enable validate;
grant select on box_file to tiptopgp;
grant update on box_file to tiptopgp;
grant delete on box_file to tiptopgp;
grant insert on box_file to tiptopgp;
grant index on box_file to public;
grant select on box_file to ods;
