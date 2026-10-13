/*
================================================================================
檔案代號:oebi_file
檔案名稱:订单单身档(行业别档)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oebi_file
(
oebi01      varchar2(20) DEFAULT ' ' NOT NULL, /*订单单号*/
oebi03      number(5) DEFAULT '0' NOT NULL, /*项次*/
oebiicd01   varchar2(40),            /*内编母体料号                           */
oebiicd02   varchar2(10),            /*业务员                                 */
oebiicd03   number(9,4),             /*备品比率                               */
oebiicd04   varchar2(1),             /*样品否                                 */
oebiicd05   varchar2(1),             /*Multi Die                              */
oebiicd06   number(15,3),            /*已转片数                               */
oebiicd07   varchar2(10),            /*End User                               */
oebiicd08   varchar2(1),             /*已转完采购单否                         */
oebiicd09   varchar2(10),            /*单身送货地址码                         */
oebislk01   varchar2(20),            /*制单号                                 */
oebiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
oebilegal   varchar2(10) NOT NULL,   /*所属法人                               */
oebislk02   varchar2(40),            /*款号                                   */
oebislk03   number(5)                /*款號項次                               */
);

alter table oebi_file add  constraint oebi_pk primary key  (oebi01,oebi03) enable validate;
grant select on oebi_file to tiptopgp;
grant update on oebi_file to tiptopgp;
grant delete on oebi_file to tiptopgp;
grant insert on oebi_file to tiptopgp;
grant index on oebi_file to public;
grant select on oebi_file to ods;
