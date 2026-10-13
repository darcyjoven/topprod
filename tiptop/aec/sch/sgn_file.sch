/*
================================================================================
檔案代號:sgn_file
檔案名稱:Run Card 工艺单元资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgn_file
(
sgn00       varchar2(23) DEFAULT ' ' NOT NULL, /*Run Card*/
sgn01       varchar2(40) NOT NULL,   /*料件编号                               */
sgn02       varchar2(10) NOT NULL,   /*工艺编号                               */
sgn03       number(5) NOT NULL,      /*工艺序号                               */
sgn04       varchar2(10) NOT NULL,   /*工作站编号                             */
sgn05       varchar2(10) NOT NULL,   /*单元编号                               */
sgn06       number(10),              /*零件数                                 */
sgn07       number(8,3),             /*单位工时                               */
sgn08       number(8,3),             /*单元工时                               */
sgn09       number(15,3),            /*单位人力                               */
sgn10       number(15,3),            /*单位机时                               */
sgn11       number(15,3),            /*单元机时                               */
sgnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgn012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sgn_file add  constraint sgn_pk primary key  (sgn00,sgn01,sgn02,sgn03,sgn04,sgn05,sgn012) enable validate;
grant select on sgn_file to tiptopgp;
grant update on sgn_file to tiptopgp;
grant delete on sgn_file to tiptopgp;
grant insert on sgn_file to tiptopgp;
grant index on sgn_file to public;
grant select on sgn_file to ods;
